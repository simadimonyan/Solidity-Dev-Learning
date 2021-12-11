//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "/tokens/ERC 20/ERC20.sol";

contract MyFirstToken is ERC20 {

    uint256 private constant __totalSupply = 1000;
    mapping (address => uint) private __balanceOf;
    mapping (address => mapping(address => uint)) __allowences;

    string public constant tokenName = "MyFirstToken";
    string public constant tokenSymbol = "MFT";
    uint8 public constant tokenDecimals = 18;

    function test() public {
        __balanceOf[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = 100;
        __balanceOf[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = 0;
    }

    function name() public pure returns (string memory) {
        return tokenName;
    }

    function symbol() public pure returns (string memory) {
        return tokenSymbol;
    }

    function decimals() public pure returns (uint8) {
        return tokenDecimals;
    }

    function totalSupply() public pure returns (uint256) {
        return __totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return __balanceOf[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (_value > 0 && _value <= balanceOf(msg.sender)) {
            __balanceOf[msg.sender] -= _value;
            __balanceOf[_to] += _value;
            return true;
        }
        return false;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (__allowences[_from][msg.sender] > 0 
        && _value > 0 
        && __allowences[_from][msg.sender] >= _value) {
            __balanceOf[_from] -= _value;
            __balanceOf[_to] += _value;
            return true;
        }
        return false;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        __allowences[msg.sender][_spender] = _value;
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return __allowences[_owner][_spender];
    }
    
}


