// "SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.4.6;

import 'https://github.com/aragon/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol';
import "./DistributeFunding.sol";
import './MarketplaceToken.sol';

contract CrowdFunding is Ownable {
    
    enum State { TARGET_NOT_REACHED, TARGET_REACHED, CLOSED }
    State state;
    
    uint fundingGoal;
    uint totalFundsReceived;
    MarketplaceToken token;
    
    address[] contributors;
    mapping(address => uint) contributions;
    event Log(string msg);
    event Log(uint msg);
    
    constructor(MarketplaceToken _token, uint _fundingGoal) public {
        token = _token;
        state = State.TARGET_NOT_REACHED;
        fundingGoal = _fundingGoal;
        totalFundsReceived = 0;
    }
    
    function forceClose() public onlyOwner {
        require(state == State.TARGET_NOT_REACHED, "Can't do this anymore!");
        if (totalFundsReceived > 0){
            DistributeFunding distributeFunding = new DistributeFunding(totalFundsReceived, token);
            
            for(uint i=0; i < contributors.length; i++) {
                distributeFunding.addShare(contributors[i], contributions[contributors[i]]);
            }
            token.approve(distributeFunding, totalFundsReceived);
            distributeFunding.distributeFunding(this);
        }
        state = State.CLOSED;
    }
    
    function distributeFunding(DistributeFunding _distributeFundingContract) public onlyOwner {
        if (state != State.TARGET_REACHED) {
            revert(getState());
        }
        token.approve(_distributeFundingContract, totalFundsReceived);
        _distributeFundingContract.distributeFunding(address(this));
        state = State.CLOSED;
    }
    
    function contribute(address contributor, uint amount) public onlyOwner {
        
        if (state != State.TARGET_NOT_REACHED) {
            revert("Target is already reached!");
        }
        if (amount <= 0 || token.balanceOf(contributor) < amount) {
            revert("Invalid contribution!");
        }
        uint fundsToAdd;
        if (totalFundsReceived + amount >= fundingGoal) {
            fundsToAdd = fundingGoal - totalFundsReceived;
            state = State.TARGET_REACHED;
        } else {
            fundsToAdd = amount;
        }
        if (token.transferFrom(contributor, address(this), fundsToAdd)) {
            if (contributions[contributor] == 0) {
                contributors.push(contributor);
            }
            contributions[contributor] += fundsToAdd;
            totalFundsReceived += fundsToAdd;
        }
    }
    
    function removeMoneyFromContribution(address contributor, uint amount) public onlyOwner {
        
        if (state != State.TARGET_NOT_REACHED) {
            revert("Target is already reached!");
        }
        
        
        if (contributions[contributor] < amount) {
            revert("Retrieved money is bigger than contribution");
        }
        
        if (token.transfer(contributor, amount)) {
            contributions[contributor] -= amount;
            totalFundsReceived -= amount;
        }
    }
    
    function getState() public view returns (string memory) {
        
        if(state == State.TARGET_REACHED) {
            
            return "Target reached!";
        } else if (state == State.CLOSED) {
            
            return "Target reached! Funding Closed!";
        }
        
        return "Target not reached!";
    }
    
    function getFundingGoal() public view returns (uint) {
        
        return fundingGoal;
    }
    
    function getFundsReceived() public view returns (uint) {
        
        return totalFundsReceived;
    }
}