//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "/library/customlib.sol"; //library import

contract Math {
    using math for uint; //using library fucntions for uint

    function testIncrement(uint _self) pure public returns(uint) {
        return _self.increment();
    }

    function testDecrement(uint _self) pure public returns(uint) {
        return _self.decrement();
    } 

    function testIncrementByValue(uint _self, uint _value) pure public returns(uint) {
        return _self.incrementByValue(_value);
    }

    function testDecrementByValue(uint _self, uint _value) pure public returns(uint) {
        return _self.decrementByValue(_value);
    }

}