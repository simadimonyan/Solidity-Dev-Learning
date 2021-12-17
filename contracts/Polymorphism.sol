//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface Letter {
    function n() external returns (uint);
}

contract A is Letter {
    function n()
        public 
        pure
        returns (uint) {
        return 1;  
    }
}

contract B is A {}

contract C is Letter {
    function n() 
        public
        pure 
        returns (uint) {
        return 2;
    }

    function x()
        public 
        pure
        returns (string memory) {
        return 'x';
    }
}

contract Alphabet {

    Letter[] private letters; 

    event Printer(uint);

    constructor() {
        letters.push(new A());
        letters.push(new B());
        letters.push(new C());
    }

    function loadRemote(address _addrX,
                        address _addrY,
                        address _addrZ) 
        public {
        letters.push(Letter(_addrX));
        letters.push(Letter(_addrY));
        letters.push(Letter(_addrZ));
    }

    function printLetters()
        public returns (Letter[] memory) {
            for(uint i =0; i < letters.length; i++) {
                emit Printer(letters[i].n());
        }
        return letters;
    }
 
}