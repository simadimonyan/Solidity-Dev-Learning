//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Random {

    uint private randomNonce;

    function getRandNum() // randomizer function based on timestamp and nonce
        public
        returns (uint) {
            return uint(keccak256(abi.encodePacked(block.timestamp,
                                                   msg.sender,
                                                   randomNonce++))) % 100;
    }

}
