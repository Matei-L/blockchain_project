pragma solidity ^0.4.6;
pragma experimental ABIEncoderV2;

import './Users.sol';
import './MarketplaceInterface.sol';

contract MarketplaceFreelancers is MarketplaceInterface  {
    mapping(string => ProductFrelancers) productsFreelancers;

    Users users;
        
    constructor(Users _users) public {
        users = _users;
    }
    
    
    function getFreelancersApplications(string name) public view returns(FreelancersApplications[] memory){
        uint freelancersLen = productsFreelancers[name].freelancersApplicationsAddr.length;
        FreelancersApplications[] memory freelancersApplicationsList = new FreelancersApplications[](freelancersLen);
        for(uint i = 0; i<freelancersLen; i++){
            address addr = productsFreelancers[name].freelancersApplicationsAddr[i];
            freelancersApplicationsList[i] = productsFreelancers[name].freelancersApplications[addr];
        }
        return freelancersApplicationsList;
    }
    
    function registerFralancer(string name, uint cost, address freelancerAddress) public {
        productsFreelancers[name].freelancersApplicationsAddr.push(freelancerAddress);
        Freelancer memory freelancer = users.getFreelancer(freelancerAddress);
        productsFreelancers[name].freelancersApplications[freelancerAddress].cost = cost;
        productsFreelancers[name].freelancersApplications[freelancerAddress].reputation = freelancer.reputation;
        productsFreelancers[name].freelancersApplications[freelancerAddress].areaOfExpertise = freelancer.areaOfExpertise;
        productsFreelancers[name].freelancersApplications[freelancerAddress].frelancerAddr = freelancerAddress;
    }
    
    
}