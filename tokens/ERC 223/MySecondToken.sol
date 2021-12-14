//SPDX-License-Identifier: MIT

import "/tokens/ERC 223/Token.sol";
import "/tokens/ERC 223/ERC20.sol";
import "/tokens/ERC 223/ERC223.sol";
import "/tokens/ERC 223/ERC223ReceivingContract.sol";

pragma solidity ^0.8.10;

contract MySecondContract is Token("MST", "My Second Token", 18, 1000), ERC20, ERC223 {

    function ICO() public {
        _balanceOf[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = 100;
    }

    function balanceOf(address _addr) public view returns (uint) {
        return _balanceOf[_addr];
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        if (_value > 0 
        && _value == _balanceOf[msg.sender] 
        && !isContract(_to)) {
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    function transfer(address _to, uint _value, bytes memory _data) public returns (bool success) {
        if (_value > 0 
        && _value == _balanceOf[msg.sender] 
        && isContract(_to)) {
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value;
            ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
            _contract.tokenFallback(msg.sender, _value, _data);
            emit Transfer(msg.sender, _to, _value, _data);
            return true;
        }
        return false;
    }

    function isContract(address _addr) public view returns (bool success) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }
        return codeSize > 0;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        if (_allowances[_from][msg.sender] > 0 
        && _value > 0 
        && _allowances[_from][msg.sender] >= _value 
        && _balanceOf[_from] >= _value) {
            _balanceOf[_from] -= _value;
            _balanceOf[_to] += _value;
            _allowances[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        }
        return false;
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint) {
        return _allowances[_owner][_spender];
    }

}