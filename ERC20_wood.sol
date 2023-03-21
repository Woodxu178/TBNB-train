// SPDX-License-Identifier:MIT
// 
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ERC20_wood is IERC20{
    using SafeERC20 for IERC20;
    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;
    uint256 public override totalSupply; //代币总供给
    string public name;
    string public symbol;
    uint8 public decimal = 18;
    constructor(string memory name_,string memory symbol_){
        name = name_;
        symbol = symbol_;
    }
    
    // 转账函数
    function transfer(address recipient,uint amount) external override returns(bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender,recipient,amount);
        return true;
    }

    //代币授权逻辑
    function approve(address spender,uint amount) external override returns(bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }

    //代币授权后转账逻辑
    function transferFrom(address sender,address recipient,uint amount) external override returns(bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender,recipient,amount);
        return true;
    }

    //铸造函数
    function mint(uint amount) external{
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0),msg.sender,amount);
    }
    // 烧毁函数
    function burn(uint amount) external{
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender,address(0),amount);
    }



}
