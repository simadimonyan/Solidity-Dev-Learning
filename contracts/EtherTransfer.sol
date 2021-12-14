//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

/*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

contract EtherTransferTo {

    receive() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}

contract EtherTransferFrom {
    
    EtherTransferTo private _instance; // adress you want to send ether to

    constructor() {
        _instance = new EtherTransferTo();
    }

    function getBalance() public view returns (uint) { // _to
        return address(this).balance;
    }

    function getInstanceBalance() public view returns (uint) { // _from
        return address(_instance).balance;
    }

    receive() external payable {
        address payable rec = payable(address(_instance)); // converts address to address payable 
        rec.transfer(msg.value); 
    }

}