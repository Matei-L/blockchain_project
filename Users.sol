pragma solidity ^0.4.6;
pragma experimental ABIEncoderV2;

import './MarketplaceInterface.sol';


contract Users is MarketplaceInterface{
    
    MarketplaceToken token;
    uint NR_AREAS_OF_EXPERTISE = 3;

    address[] managerAddresses;
    address[] freelancerAddresses;
    address[] evaluatorAddresses;
    address[] founderAddresses;

    mapping(address => Manager) managers;
    mapping(address => Freelancer) freelancers;
    mapping(address => Evaluator) evaluators;
    mapping(address => Founder) founders;

        // constructors
    constructor(MarketplaceToken _token) public {
        token = _token;
    }

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
    
    function getManagers() public view returns (Manager[]) {
        uint managerAddressesLength = managerAddresses.length;
        Manager[] memory managerList = new Manager[](managerAddressesLength);
        for(uint i = 0; i < managerAddressesLength; i++) {
            managerList[i] = managers[managerAddresses[i]];
        }
        return managerList;
    }
    
    function getFreelancers() public view returns (Freelancer[] memory) {
        uint freelancerAddressesLength = freelancerAddresses.length;
        Freelancer[] memory freelancerList = new Freelancer[](freelancerAddressesLength);
        for(uint i = 0; i < freelancerAddressesLength; i++) {
            freelancerList[i] = freelancers[freelancerAddresses[i]];
        }
        return freelancerList;
    }
    
    function getEvaluators() public view returns (Evaluator[] memory) {
        uint evaluatorAddressesLength = evaluatorAddresses.length;
        Evaluator[] memory evaluatorList = new Evaluator[](evaluatorAddressesLength);
        for(uint i = 0; i < evaluatorAddressesLength; i++) {
            evaluatorList[i] = evaluators[evaluatorAddresses[i]];
        }
        return evaluatorList;
    }
    
    function getFounders() public view returns (Founder[] memory) {
        uint founderAddressesLength = founderAddresses.length;
        Founder[] memory founderList = new Founder[](founderAddressesLength);
        for(uint i = 0; i < founderAddressesLength; i++) {
            founderList[i] = founders[founderAddresses[i]];
        }
        return founderList;
    }
    
    function dummyInit(address[] _managerAddresses,
                   address[] _freelancerAddresses,
                   address[] _evaluatorAddresses,
                   address[] _founderAddresses) {
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
    
    //boolean getters
    function isManager(address sender) public view returns (bool) {
        return managers[sender].active;
    }
    
    function isFreelancer(address sender) public view returns (bool) {
        return freelancers[sender].active;
    }
    
    
    function isEvaluator(address sender) public view returns (bool) {
        return evaluators[sender].active;
    }
    
    function isFounder(address sender) public view returns (bool) {
        return founders[sender].active;
    }    
    
    
    //getters
    
    function getToken() public view returns (MarketplaceToken){
        return token;
    }
    
}