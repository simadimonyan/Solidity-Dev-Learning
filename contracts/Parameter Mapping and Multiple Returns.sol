//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Assignments {

    function returnValues(uint a, uint b) 
        public
        pure
        returns (uint, uint) {
        return (a, b);
    }

    function caller() 
        public
        pure
        returns (uint, uint) {
        return returnValues({a:3, b:6}); // parameter mapping - returnValues
    }

    function callerAll() //returning multiple values
        public
        pure
        returns (uint, uint, uint) {
        uint x;
        uint y;
        uint z = 2;
        (x, y) = caller(); 
        (x, z) = (z, x);
        return (x, y, z);
    }

}