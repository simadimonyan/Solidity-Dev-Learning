//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IBearToken {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}

contract PaymentChannel {

    event ReplacementValidators(address indexed owner, address[] indexed validators);
    event Withdrawal(address indexed player, uint256 payment, uint256 nonce, bytes indexed sig);

    mapping(uint256 => bool) _usedNonces;
    address[] _validators;
    IBearToken _token;
    address owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "SENDER_IS_NOT_OWNER");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function replaceValidators(address[] memory validators) public onlyOwner {
        _validators = validators;
        emit ReplacementValidators(msg.sender, validators);
    }

    function connectToken(address token) public onlyOwner {
        _token = IBearToken(token);
    }

    function getValidators() public view returns(address[] memory) {
        return _validators;
    }

    function validate(bytes32 message, bytes memory sig) public view returns (bool genuine) {
        address validator = verify(message, sig);

        for (uint i = 0; i < _validators.length; i++) {
            if (validator == _validators[i]) {
                return true;
            }
        }
        return false;
    }

    function claimPayment(address _reciever, uint256 payment, uint256 nonce, bytes memory sig) public {
        require(!_usedNonces[nonce], "NONCE_IS_ALREADY_USED");
        _usedNonces[nonce] = true;
        bytes32 message = getEthSignedHash(keccak256(abi.encodePacked(_reciever, payment, nonce)));
        require(validate(message, sig), "DIGITAL_SIGNATURE_IS_NOT_GENUINE");
        _token.transferFrom(owner, _reciever, payment);
        emit Withdrawal(_reciever, payment, nonce, sig);
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

}