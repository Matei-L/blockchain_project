pragma solidity ^0.4.6;
pragma experimental ABIEncoderV2;

import './Users.sol';
import './MarketplaceInterface.sol';

contract Marketplace is MarketplaceInterface  {

    struct Product {
        string description;
        uint developmentCost;
        uint evaluationCost;
        string areaOfExpertise;
        address managerAddress;
        CrowdFunding crowdFunding;
    }
    
    Users users;
    
    uint NR_AREAS_OF_EXPERTISE = 3;
    
    address[] managerAddresses;
    address[] freelancerAddresses;
    address[] evaluatorAddresses;
    address[] founderAddresses;
    string[] productNames;
    
    mapping(string => Product) products;
    
    
    function initProduct(string _name,
                         string _description,
                         uint _developmentCost,
                         uint _evaluationCost,
                         string _areaOfExpertise) public isManager {
        uint productsLength = productNames.length;
        
        for(uint i=0; i < productsLength; i++) {
            require(!areStringsEqual(_name, productNames[i]), "Name isn't unique");
        }
        productNames.push(_name);
        products[_name].description = _description;
        products[_name].developmentCost = _developmentCost;
        products[_name].evaluationCost = _evaluationCost;
        products[_name].areaOfExpertise = _areaOfExpertise;
        products[_name].managerAddress = msg.sender;
        products[_name].crowdFunding = new CrowdFunding(users.getToken() , _developmentCost + _evaluationCost);
    }

    
    // gets 
    function getTokenBalance() public view returns (uint) {
        return users.getToken().balanceOf(msg.sender);
    }
    
    function getProduct(string _name) public view returns (Product) {
        return products[_name];
    }
    
        
    // function getManagers() public view returns (Manager[]) {
    //     return users.getManagers();
    // }
    
    // function getFreelancers() public view returns (Freelancer[] memory) {
    //     return users.getFreelancers();
    // }
    
    // function getEvaluators() public view returns (Evaluator[] memory) {
    //     return users.getEvaluators();
    // }
    
    // function getFounders() public view returns (Founder[] memory) {
    //     return users.getFounders();
    // }
    
    
    // constructors
    constructor(Users _users) public {
        users = _users;
    }
    
    
    // product founding
     function getFundingStatus(string name) public view returns (string) {
        return products[name].crowdFunding.getState();
    }
    
    function getFundingGoal(string name) public view returns (uint) {
        return products[name].crowdFunding.getFundingGoal();
    }
    
    function getFundsReceived(string name) public view returns (uint) {
        return products[name].crowdFunding.getFundsReceived();
    }
    
    function contributeFunding(string name, uint valueInTokens) public isFounder {
        products[name].crowdFunding.contribute(msg.sender, valueInTokens);
    }
    
    function removeFunding(string name, uint valueInTokens) public isFounder {
        products[name].crowdFunding.removeMoneyFromContribution(msg.sender, valueInTokens);
    }
    
    function forceCloseProductFunding(string name) public isManager {
        products[name].crowdFunding.forceClose();
    }
    
    
    // modifiers
    modifier isManager() {
        require(users.isManager(msg.sender) == true, "Caller is not manager");
        _;
    }
    
    modifier isFreelancer() {
        require(users.isFreelancer(msg.sender) == true, "Caller is not freelancer");
        _;
    }
    
    modifier isEvaluator() {
        require(users.isEvaluator(msg.sender) == true, "Caller is not evaluator");
        _;
    }
    
    modifier isFounder() {
        require(users.isFounder(msg.sender) == true, "Caller is not founder");
        _;
    }
    
    
}