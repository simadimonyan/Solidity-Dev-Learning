//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract MultiSigBearWallet {

    event Deposit(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(address indexed owner, uint indexed txIndex, address indexed to, uint value, bytes data);
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);
    event OwnerAddition(address indexed sender, address indexed newOwner);
    event OwnerApproval(address indexed sender, address indexed approvedOwner);
    event OwnerDisactivation(address indexed sender, address indexed disactivatedOwner);

    address[] public owners;
    Transaction[] public transactions;
    mapping(uint256 => bool) public usedNonces;
    mapping(address => bool) public isOwner;
    mapping(uint => mapping(address => bool)) public isConfirmed;
    uint public confirmationsRequired;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint confirmations;
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "SENDER_IS_NOT_OWNER");
        _;
    }

    modifier onwerNotApproved(address _owner) {
        require(!isOwner[_owner], "ONWER_IS_ALREADY_APPROVED");
        _;
    }

    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "TRANSACTION_DOES_NOT_EXIST");
        _;
    }

    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "TRANSACTION_IS_ALREADY_EXECUTED");
        _;
    }

    modifier notConfirmed(uint _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "TRANSACTION_IS_ALREADY_CONFIRMED");
        _;
    }

    constructor(address[] memory _owners, uint _confirmationsRequired) {
        require(_owners.length > 0, "NULL_OWNERS_PROVIDED");
        require(_confirmationsRequired > 0 && 
                    _confirmationsRequired <= _owners.length, "INVALID_CONFIRMATIONS_NUMBER");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "INVALID_OWNER_PROVIDED");
            require(!isOwner[owner], "NOT_UNIQUE_OWNER_PROVIDED");

            isOwner[owner] = true;
            owners.push(owner);
        }
        confirmationsRequired = _confirmationsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        uint txIndex = transactions.length;

        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            confirmations: 0
        }));

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    function confirmTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        transaction.confirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    function revokeConfirmation(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "TRANSACTION_IS_NOT_CONFIRMED");

        transaction.confirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    function executeTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(transaction.confirmations >= confirmationsRequired, "INSUFFICIENT_CONFIRMATIONS_AMOUNT");

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "TRANSACTION_FAILED");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    function addOwner(address _owner) public onlyOwner onwerNotApproved(_owner) {
        owners.push(_owner);
        isOwner[_owner] = false;
        emit OwnerAddition(msg.sender, _owner);
    }

    function approveOwner(address _owner, uint[] memory nonces, bytes[] memory signatures) public onlyOwner onwerNotApproved(_owner) {
        require(_owner != address(0), "INVALID_OWNER_ADDRESS");
        require(nonces.length == signatures.length, "NONCES_ARE_NOT_CORRESPONDING_THE_SIGNATURES");
        require(signatures.length >= confirmationsRequired, "UNSUFFICIENT_SIGNATURES_CONFIRMATIONS");
        for (uint i = 0; i < nonces.length; i++) {
            require(!usedNonces[nonces[i]], "NONCE_IS_ALREADY_USED");
            usedNonces[nonces[i]] = true;
        }
        for (uint j = 0; j < nonces.length; j++) {
            for (uint k = 0; k < signatures.length; k++) {
                bytes32 message = getEthSignedHash(keccak256(abi.encodePacked(_owner, nonces[j])));
                require(validate(message, signatures[k]), "DIGITAL_SIGNATURE_IS_NOT_GENUINE");
            }
        }
        isOwner[_owner] = true;
        emit OwnerApproval(msg.sender, _owner);
    }

    function disactivateOwner(address _owner, uint[] memory nonces, bytes[] memory signatures) public onlyOwner {
        require(_owner != address(0), "INVALID_OWNER_ADDRESS");
        require(nonces.length == signatures.length, "NONCES_ARE_NOT_CORRESPONDING_THE_SIGNATURES");
        require(signatures.length >= confirmationsRequired, "UNSUFFICIENT_SIGNATURES_CONFIRMATIONS");
        for (uint i = 0; i < nonces.length; i++) {
            require(!usedNonces[nonces[i]], "NONCE_IS_ALREADY_USED");
            usedNonces[nonces[i]] = true;
        }
        for (uint j = 0; j < nonces.length; j++) {
            for (uint k = 0; k < signatures.length; k++) {
                bytes32 message = getEthSignedHash(keccak256(abi.encodePacked(_owner, nonces[j])));
                require(validate(message, signatures[k]), "DIGITAL_SIGNATURE_IS_NOT_GENUINE");
            }
        }
        isOwner[_owner] = false;
        emit OwnerDisactivation(msg.sender, _owner);
    }

    function validate(bytes32 message, bytes memory sig) private view returns (bool genuine) {
        address validator = verify(message, sig);

        for (uint i = 0; i < owners.length; i++) {
            if (validator == owners[i]) {
                return true;
            }
        }
        return false;
    }

    function getEthSignedHash(bytes32 _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _message));
    }

    function splitSignature(bytes memory signature) public pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(signature.length == 65, "INVALID_SIGNATURE_LENGTH");
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        return (r, s, v);
    } 

    function verify(bytes32 _ethSignedMessage, bytes memory _signanture) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signanture);
        return ecrecover(_ethSignedMessage, v, r, s);
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    function getTransaction(uint _txIndex) public view returns (address to, uint value, bytes memory data, bool executed, uint confimations) {
        Transaction storage transaction = transactions[_txIndex];
        return (transaction.to, transaction.value, transaction.data, transaction.executed, transaction.confirmations); 
    }

}