//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Lease {

    mapping (address => uint) _balanceOf;
    mapping (address => uint) _expiryOf;

    uint private leaseTime = 30; //seconds

    modifier expire(address _addr) {
        if (_expiryOf[_addr] >= block.timestamp) {
            _balanceOf[_addr] = 0;
            _expiryOf[_addr] = 0;
        }
        _;
    }

    modifier expireCheck(address _addr) {
        if (_expiryOf[_addr] <= block.timestamp) {
            _balanceOf[_addr] = 0;
            _expiryOf[_addr] = 0;
        }
        _;
    }
 
    function lease() public payable expire(msg.sender) returns (bool) {
        require(msg.value == 1 ether);
        require(_balanceOf[msg.sender] == 0);
        _balanceOf[msg.sender] = 1;
        _expiryOf[msg.sender] = block.timestamp + leaseTime;
        return true;
    } 

    function timestamp() public view returns (uint) {
        return block.timestamp;
    }

    function balanceOf() public expireCheck(msg.sender) returns (uint) {
        return _balanceOf[msg.sender];
    }

    function balanceOf(address _addr) public expireCheck(msg.sender) returns (uint) {
        return _balanceOf[_addr];
    }

    function expiryOf() public expireCheck(msg.sender) returns (uint) {
        return _expiryOf[msg.sender];
    }

    function expiryOf(address _addr) public expireCheck(msg.sender) returns (uint) {
        return _expiryOf[_addr];
    }

}