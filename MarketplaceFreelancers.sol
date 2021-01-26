pragma solidity ^0.4.6;
pragma experimental ABIEncoderV2;

import './Users.sol';
import './MarketplaceInterface.sol';

contract MarketplaceFreelancers is MarketplaceInterface  {
    mapping(string => ProductFrelancers) productsFreelancers;
    mapping(string => ProductFrelancers) acceptedFreelancers;
    mapping(string => uint) productCostUsed;
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
    
    function getAcceptedFreelancers(string name) public view returns(FreelancersApplications[] memory){
        uint freelancersLen = acceptedFreelancers[name].freelancersApplicationsAddr.length;
        FreelancersApplications[] memory freelancersAcceptedList = new FreelancersApplications[](freelancersLen);
        for(uint i = 0; i<freelancersLen; i++){
            address addr = acceptedFreelancers[name].freelancersApplicationsAddr[i];
            freelancersAcceptedList[i] = acceptedFreelancers[name].freelancersApplications[addr];
        }
        return freelancersAcceptedList;
    }
    
    function registerFreelancer(string name, uint cost, address freelancerAddress) public {
        productsFreelancers[name].freelancersApplicationsAddr.push(freelancerAddress);
        Freelancer memory freelancer = users.getFreelancer(freelancerAddress);
        productsFreelancers[name].freelancersApplications[freelancerAddress].cost = cost;
        productsFreelancers[name].freelancersApplications[freelancerAddress].reputation = freelancer.reputation;
        productsFreelancers[name].freelancersApplications[freelancerAddress].areaOfExpertise = freelancer.areaOfExpertise;
        productsFreelancers[name].freelancersApplications[freelancerAddress].frelancerAddr = freelancerAddress;
    }
    
    function acceptFreelancer(string name, uint developmentCost, address freelancerAddress) public returns(bool){
        if(productsFreelancers[name].freelancersApplications[freelancerAddress].cost + productCostUsed[name] <= developmentCost && 
           productsFreelancers[name].freelancersApplications[freelancerAddress].frelancerAddr != address(0)){
            acceptedFreelancers[name].freelancersApplicationsAddr.push(freelancerAddress);
            acceptedFreelancers[name].freelancersApplications[freelancerAddress] = productsFreelancers[name].freelancersApplications[freelancerAddress];
            productCostUsed[name] = productCostUsed[name] + productsFreelancers[name].freelancersApplications[freelancerAddress].cost;
            }
            
        if (productCostUsed[name] == developmentCost)
            return true;
        else
            return false;
    }
    
    
}