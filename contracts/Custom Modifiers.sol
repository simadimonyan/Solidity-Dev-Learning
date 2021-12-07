//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface Regulator {
    function checkValue(uint amount) view external returns(bool); 
    function loan() view external returns(bool);
}

contract Bank is Regulator {
    uint private value;
    address private owner;

    modifier ownerCheck() { //owner check for the smart contract and user balance 
        require(owner == msg.sender);
        _;
    }

    constructor(uint amount) {
        value = amount;
        owner = msg.sender;
    }

    function deposit(uint amount) public ownerCheck {
        value += amount;
    }

    function withdraw(uint amount) public ownerCheck {
        if (checkValue(amount)) {
            value -= amount;
        }
    }

    function balance() view external returns(uint) {
        return value;
    }

    function checkValue(uint amount) view public returns(bool) {
        return value >= amount;
    }

    function loan()  view public returns(bool) {
        return value > 0;
    }

}

contract MyFirstContract is Bank(10) {
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