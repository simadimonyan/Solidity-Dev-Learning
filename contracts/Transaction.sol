//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract eventslogging {

    event SenderLogger(address);
    event EtherLogger(uint);

    address private owner;

    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }

    modifier validValue() {
        assert(msg.value >= 1 ether);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function recieve() external payable isOwner validValue {
        //recieve
        emit SenderLogger(msg.sender);
        emit EtherLogger(msg.value);
    }

}

