//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract DataTypes {

    bool myBool = false;

    int8 myInt = -128;
    uint8 myUint = 255;

    string myString;
    uint8[] myStringArr;

    bytes myValue2;
    bytes1 myBytes1;
    bytes32 myBytes32; 

    //fixed256x8 myFixed = 1; ///255.0 ---- not yet implemented 
    //ufixed myFixed2 = 1;

    enum Action {ADD, REMOVE, UPDATE}
    Action myAction = Action.ADD;

    address myAddress;

    function assignAddress() public {
        myAddress = msg.sender;
        myAddress.balance;
    }

    uint[] myIntArr = [1,2,3];

    function arrFunc() public {
        myIntArr.push(1);
        myIntArr.length;
        myIntArr[0];
    }

    uint[10] myFixedArr;

    struct Account {
        uint balance;
        uint dailyLimit;
    }

    Account myAccount;

    function structFunc() public {
        myAccount.balance = 100;
    }

    mapping (address => Account) _accounts;

    function mappingFunc() payable public {
        _accounts[msg.sender].balance += msg.value;
    }

    function getBalance() view public returns(uint) {
        return _accounts[msg.sender].balance;
    }

}