pragma solidity ^0.4.6;

import 'https://github.com/aragon/zeppelin-solidity/blob/master/contracts/token/ERC20Lib.sol';

contract MarketplaceToken {
  using ERC20Lib for ERC20Lib.TokenStorage;
  ERC20Lib.TokenStorage token;
  string public name = "MarketplaceToken";
  string public symbol = "MT";
  uint public decimals = 18;
  uint public initialSupply = 1000;
  constructor(uint _initialSupply) public {
    initialSupply = _initialSupply;
    token.init(initialSupply);
  }
  function totalSupply() constant public returns (uint) {
    return token.totalSupply;
  }
  function balanceOf(address who) constant public returns (uint) {
    return token.balanceOf(who);
  }
  function allowance(address owner, address spender) constant public returns (uint) {
    return token.allowance(owner, spender);
  }
  function transfer(address to, uint value) public returns (bool ok) {
    return token.transfer(to, value);
  }
  function transferFrom(address from, address to, uint value) public returns (bool ok) {
    return token.transferFrom(from, to, value);
  }
  function approve(address spender, uint value) public returns (bool ok) {
    return token.approve(spender, value);
  }

   event Transfer(address indexed from, address indexed to, uint value);
   event Approval(address indexed owner, address indexed spender, uint value);
}