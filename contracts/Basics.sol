//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract MyFirstContract {
    string private name;
    uint private age;

    function setName(string memory _name) public {
        name = _name;
    }

    function getName() view external returns(string memory) {
        return name;
    }

    function setAge(uint _age) public {
        age = _age;
    }

    function getAge() view external returns(uint) {
        return age;
    } 

}