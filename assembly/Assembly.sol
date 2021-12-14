//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Assembly {

    function nativeLoops() public pure returns (uint _r) { // more gas cost
        for (uint i = 0; i < 10; i++) {
            _r++;
        }
    }

    function asmLoops() public pure returns (uint _r) { // less gas cost
        assembly {
            let i := 0
            for { } lt(i, 10) { i := add(i, 1) } {
                _r := add(_r, 1)
            }
        }
    }

    function nativeConditional(uint _v) public pure returns (uint) { // less gas cost
        if (5 == _v) {
            return 55;
        } else if (7 == _v) {
            return 77;
        }
        return 11;
    }

    function asmConditional(uint _v) public pure returns (uint _r) { // more gas cost
        assembly {
            switch _v
            case 5 { _r := 55 }
            case 7 { _r := 77 }
            default { _r := 11 }
        }
    }

    function asmAddition(uint a, uint b) public pure returns (uint) {
        assembly {
            let result := add(a, b) //a + b
            mstore(0x0, result) // store result in memory address 0x0
            return(0x0, 32) // return 32 bytes from memory address 0x0
        }
    }  

}