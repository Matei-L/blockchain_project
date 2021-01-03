pragma solidity ^0.4.6;
pragma experimental ABIEncoderV2;

import 'https://github.com/aragon/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol';
import './MarketplaceToken.sol';
import './CrowdFunding.sol';
import './Utils.sol';

contract Marketplace is Ownable, Utils {
    
    struct Manager {
        bool active;
        string name;
        uint reputation;
    }
    
    struct Freelancer {
        bool active;
        string name;
        uint reputation;
        string areaOfExpertise;
    }
    
    struct Evaluator {
        bool active;
        string name;
        uint reputation;
        string areaOfExpertise;
    }
    
    struct Founder {
        bool active;
        string name;
    }
    
    struct Product {
        string description;
        uint developmentCost;
        uint evaluationCost;
        string areaOfExpertise;
        address managerAddress;
        CrowdFunding crowdFunding;
    }
    
    MarketplaceToken token;
    
    uint NR_AREAS_OF_EXPERTISE = 3;
    
    address[] managerAddresses;
    address[] freelancerAddresses;
    address[] evaluatorAddresses;
    address[] founderAddresses;
    string[] productNames;
    
    mapping(address => Manager) managers;
    mapping(address => Freelancer) freelancers;
    mapping(address => Evaluator) evaluators;
    mapping(address => Founder) founders;
    mapping(string => Product) products;
    
    // datatype initializatiors
    function initManager(address addr, string name) private {
        managerAddresses.push(addr);
        managers[addr].name = name;
        managers[addr].reputation = 5;
        managers[addr].active = true;
    }
    
    function initFreelancer(address addr, string name, string areaOfExpertise) private {
        freelancerAddresses.push(addr);
        freelancers[addr].name = name;
        freelancers[addr].areaOfExpertise = areaOfExpertise;
        freelancers[addr].reputation = 5;
        freelancers[addr].active = true;
    }
    
    function initEvaluator(address addr, string name, string areaOfExpertise) private {
        evaluatorAddresses.push(addr);
        evaluators[addr].name = name;
        evaluators[addr].areaOfExpertise = areaOfExpertise;
        evaluators[addr].reputation = 5;
        evaluators[addr].active = true;
    }
    
    function initFounder(address addr, string name) private {
        founderAddresses.push(addr);
        founders[addr].name = name;
        founders[addr].active = true;
    }
    
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
        products[_name].crowdFunding = new CrowdFunding(token, _developmentCost + _evaluationCost);
    }
    
    // get Alls
    // not scalable, might run into out of gas exceptions
    
    function getManagers() public view returns (Manager[] memory) {
        uint managerAddressesLength = managerAddresses.length;
        Manager[] memory managerList = new Manager[](managerAddressesLength);
        for(uint i = 0; i < managerAddressesLength; i++) {
            managerList[i] = managers[managerAddresses[i]];
        }
        return managerList;
    }
    
    // function getFreelancers() public view returns (Freelancer[] memory) {
    //     uint freelancerAddressesLength = freelancerAddresses.length;
    //     Freelancer[] memory freelancerList = new Freelancer[](freelancerAddressesLength);
    //     for(uint i = 0; i < freelancerAddressesLength; i++) {
    //         freelancerList[i] = freelancers[freelancerAddresses[i]];
    //     }
    //     return freelancerList;
    // }
    
    // function getEvaluators() public view returns (Evaluator[] memory) {
    //     uint evaluatorAddressesLength = evaluatorAddresses.length;
    //     Evaluator[] memory evaluatorList = new Evaluator[](evaluatorAddressesLength);
    //     for(uint i = 0; i < evaluatorAddressesLength; i++) {
    //         evaluatorList[i] = evaluators[evaluatorAddresses[i]];
    //     }
    //     return evaluatorList;
    // }
    
    function getFounders() public view returns (Founder[] memory) {
        uint founderAddressesLength = founderAddresses.length;
        Founder[] memory founderList = new Founder[](founderAddressesLength);
        for(uint i = 0; i < founderAddressesLength; i++) {
            founderList[i] = founders[founderAddresses[i]];
        }
        return founderList;
    }
    
    // function getProducts() public view returns (Product[] memory) {
    //     uint productNamesLength = productNames.length;
    //     Product[] memory productList = new Product[](productNamesLength);
    //     for(uint i = 0; i < productNamesLength; i++) {
    //         productList[i] = products[productNames[i]];
    //     }
    //     return productList;
    // }
    
    // gets 
    function getTokenBalance() public view returns (uint) {
        return token.balanceOf(msg.sender);
    }
    
    function getProduct(string _name) public view returns (Product) {
        return products[_name];
    }
    
    // constructors
    constructor(MarketplaceToken _token) public {
        token = _token;
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
    
    // dummy Marketplace initialisation intended for testing...
    function dummyInit(address[] _managerAddresses,
                       address[] _freelancerAddresses,
                       address[] _evaluatorAddresses,
                       address[] _founderAddresses) public onlyOwner {
        uint managerAddressesLength = _managerAddresses.length;
        uint freelancerAddressesLength = _freelancerAddresses.length;
        uint evaluatorAddressesLength = _evaluatorAddresses.length;
        uint founderAddressesLength = _founderAddresses.length;
        uint foundersInitSupply = token.initialSupply() / 2;
        uint i;
        for(i=0; i < managerAddressesLength; i++){
            initManager(_managerAddresses[i], appendUintToString("manager", i + 1));
        }
        for(i=0; i < freelancerAddressesLength; i++){
            initFreelancer(_freelancerAddresses[i], appendUintToString("freelancer", i + 1),
                appendUintToString("areaOfExpertise", (i % NR_AREAS_OF_EXPERTISE) + 1));
        }
        for(i=0; i < evaluatorAddressesLength; i++){
            initEvaluator(_evaluatorAddresses[i], appendUintToString("evaluator", i + 1),
                appendUintToString("areaOfExpertise", (i % NR_AREAS_OF_EXPERTISE) + 1));
        }
        for(i=0; i < founderAddressesLength; i++){
            initFounder(_founderAddresses[i], appendUintToString("founder", i + 1));
            token.transfer(_founderAddresses[i], foundersInitSupply / founderAddressesLength);
        }
    }
    
    // modifiers
    modifier isManager() {
        require(managers[msg.sender].active == true, "Caller is not manager");
        _;
    }
    
    modifier isFreelancer() {
        require(freelancers[msg.sender].active == true, "Caller is not freelancer");
        _;
    }
    
    modifier isEvaluator() {
        require(evaluators[msg.sender].active == true, "Caller is not evaluator");
        _;
    }
    
    modifier isFounder() {
        require(founders[msg.sender].active == true, "Caller is not founder");
        _;
    }
}