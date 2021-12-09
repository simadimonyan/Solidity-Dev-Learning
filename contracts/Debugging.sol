//SPDX-License-Identifier: MIT 

pragma solidity ^0.8.10;

contract Debugger {

    uint[] private vars;

    function assignment() pure public { //variables not equals
        uint myVal1 = 1;
        uint myVal2 = 2;
        assert(myVal1 == myVal2);
    }

    function memoryAlloc() pure public { //bytes amount not equals
        string memory myString = "test";
        assert(bytes(myString).length == 10);
    }

    function storageAlloc() public { //arrays objects amount not equals
        vars.push(2);
        uint testValue = vars[0];
        testValue = vars.length;
        assert(vars.length == 4);
    }

}