//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface ERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Token is ERC20 {

    uint256 private constant __totalSupply = 210000000;
    mapping (address => uint) private __balanceOf;
    mapping (address => mapping(address => uint)) __allowences;

    string public constant tokenName = "BearToken";
    string public constant tokenSymbol = "BTK";
    uint8 public constant tokenDecimals = 9;

    constructor(address dapp, address channel, address[] memory owners) {
        __balanceOf[dapp] = 200000000*10**tokenDecimals;
        __allowences[dapp][channel] = 200000000*10**tokenDecimals;
        
        for (uint i = 0; i < owners.length; i++) {
            __balanceOf[owners[i]] = 2000000*10**tokenDecimals;
        } 
    } 

    function name() public pure returns (string memory) {
        return tokenName;
    }

    function symbol() public pure returns (string memory) {
        return tokenSymbol;
    }

    function decimals() public pure returns (uint8) {
        return tokenDecimals;
    }

    function totalSupply() public pure returns (uint256) {
        return __totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return __balanceOf[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (_value > 0 && _value <= balanceOf(msg.sender)) {
            __balanceOf[msg.sender] -= _value;
            __balanceOf[_to] += _value;
            return true;
        }
        return false;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (__allowences[_from][msg.sender] > 0 
        && _value > 0 
        && __allowences[_from][msg.sender] >= _value) {
            __balanceOf[_from] -= _value;
            __balanceOf[_to] += _value;
            return true;
        }
        return false;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        __allowences[msg.sender][_spender] = _value;
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return __allowences[_owner][_spender];
    }
    
}
