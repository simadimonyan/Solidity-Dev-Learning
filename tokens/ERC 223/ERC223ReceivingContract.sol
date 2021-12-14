//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

abstract contract ERC223ReceivingContract {
    constructor(address _mock) {
        
    }
    function tokenFallback(address _from, uint _value, bytes memory _data) public {

    }
}