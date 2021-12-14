//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface ERC223 {
    function balanceOf(address _addr) external returns (uint);
    function transfer(address _to, uint _value, bytes memory _data) external returns (bool success);
    event Transfer(address indexed _from, address indexed _to, uint value, bytes indexed _data); 
}