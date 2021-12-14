//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Token {

    string internal __symbol;
    string internal __name;
    uint8 internal __decimals;
    uint internal __totalSupply = 1000;
    mapping (address => uint) internal _balanceOf;
    mapping (address => mapping (address => uint)) internal _allowances;
    event Transfer(address indexed _from, address indexed _to, uint _value);

    constructor(string memory _symbol, string memory _name, uint8 _decimals, uint _totalSupply) {
        __symbol = _symbol;
        __name = _name;
        __decimals = _decimals;
        __totalSupply = _totalSupply;
    }

    function name() public view returns (string memory) {
        return __name;
    }

    function symbol() public view returns (string memory) {
        return __symbol;
    }

    function decimals() public view returns (uint8) {
        return __decimals;
    }

    function totalSupply() public view returns (uint) {
        return __totalSupply;
    }

}