pragma solidity ^0.4.6;
pragma experimental ABIEncoderV2;

import './Users.sol';
import './MarketplaceInterface.sol';
import './MarketplaceFreelancers.sol';

contract Marketplace is MarketplaceInterface  {


    struct Product {
        string description;
        uint developmentCost;
        uint developmentCostUsed;
        uint evaluationCost;
        string areaOfExpertise;
        address managerAddress;
        CrowdFunding crowdFunding;
        address evaluatorAddress;
    }
    

    Users users;
    MarketplaceFreelancers marketplaceFreelancers;
    uint NR_AREAS_OF_EXPERTISE = 3;
    
    string[] productNames;
    
    
    mapping(string => Product) products;
    
    Product[] fundingStatusReachedProducts;
    
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
        products[_name].developmentCostUsed = 0;
    }

    
    // gets 
    function getTokenBalance() public view returns (uint) {
        return users.getToken().balanceOf(msg.sender);
    }
    
    function getProduct(string _name) public view returns (Product) {
        return products[_name];
    }
    
    function getFundingStatusReachedProducts() public isFreelancerOrEvaluator view returns (Product[]){
        return fundingStatusReachedProducts;
    }
    
    function getFreelancersApplications(string name) public view returns(FreelancersApplications[] memory){
        FreelancersApplications[] memory result = marketplaceFreelancers.getFreelancersApplications(name);
        return result;
    }
    
    // constructors
    constructor(Users _users) public {
        users = _users;
        marketplaceFreelancers = new MarketplaceFreelancers(users);
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
        if(areStringsEqual(getFundingStatus(name), "Target reached!"))
            fundingStatusReachedProducts.push(products[name]);
        
    }
    
    function removeFunding(string name, uint valueInTokens) public isFounder {
        products[name].crowdFunding.removeMoneyFromContribution(msg.sender, valueInTokens);
    }
    
    function forceCloseProductFunding(string name) public isManager {
        products[name].crowdFunding.forceClose();
    }
    
    function registerEvaluator(string name) public isEvaluator isEvaluatorNotSet(name) {
        if(areStringsEqual(getFundingStatus(name), "Target reached!"))
            products[name].evaluatorAddress = msg.sender;
    }
    
    function registerFralancer(string name, uint cost) public isFreelancer {
        if(areStringsEqual(getFundingStatus(name), "Target reached!"))
            marketplaceFreelancers.registerFralancer(name, cost, msg.sender);
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
    
    modifier isFreelancerOrEvaluator(){
        require(users.isFreelancer(msg.sender) == true ||
                users.isEvaluator(msg.sender) == true, "Caller is not freelancer or evaluator");
        _;
    }
    
    modifier isFounder() {
        require(users.isFounder(msg.sender) == true, "Caller is not founder");
        _;
    }
    
    modifier isEvaluatorNotSet(string name){
        require(products[name].evaluatorAddress == address(0), "This product has already an evaluator");
        _;
    }
    
    
}