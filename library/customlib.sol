//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

library math {
    
    function increment(uint _self) pure internal returns(uint) {
        return _self+1;
    }

    function decrement(uint _self) pure internal returns(uint) {
        return _self-1;
    }

    function incrementByValue(uint _self, uint _value) pure internal returns(uint) {
        return _self+_value;
    }

    function decrementByValue(uint _self, uint _value) pure internal returns(uint) {
        return _self-_value;
    }

}