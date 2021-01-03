// "SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.4.6;

import 'https://github.com/aragon/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol';
import './MarketplaceToken.sol';

contract DistributeFunding is Ownable {
    
    uint totalShares;
    uint leftShares;
    address[] shareHolders;
    mapping(address => uint) shares;
    MarketplaceToken token;
    
    constructor(uint _totalShares, MarketplaceToken _token) public {
        token = _token;
        totalShares = _totalShares;
        leftShares = _totalShares;
    }
    
    function addShare(address shareHolderAdress, uint shareValue) public onlyOwner {
        if(shareValue <= leftShares){
            shares[shareHolderAdress] += shareValue;
            leftShares -= shareValue;
            shareHolders.push(shareHolderAdress);
        }
        else {
            revert('Not enough shares left.');
        }
    }
    
    function removeShare(address shareHolderAdress, uint shareValue) public onlyOwner {
        if(shareValue <= shares[shareHolderAdress]){
            shares[shareHolderAdress] -= shareValue;
            leftShares += shareValue;
        }
        else{
            revert('Shareholder doesn\'t have this many shares.');
        }
    }
    
    function checkLeftShares() public view returns (uint) {
        return leftShares;
    }
    
    function checkTotalShares() public view returns (uint) {
        return totalShares;
    }
    
    function checkSharesFor(address shareHolderAdress) public view onlyOwner returns (uint) {
        return shares[shareHolderAdress];
    }
    
    function distributeFunding(address vaultAdress) public onlyOwner {
        for (uint i = 0; i < shareHolders.length; i++){
            if(!token.transferFrom(vaultAdress, shareHolders[i], shares[shareHolders[i]])) {
                revert(string(abi.encodePacked("transaction to ", abi.encodePacked(shareHolders[i]), "failed")));
            }
        }
    }
}