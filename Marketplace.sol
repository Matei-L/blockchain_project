pragma solidity ^0.4.6;
pragma experimental ABIEncoderV2;

import 'https://github.com/aragon/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol';
import './MarketplaceToken.sol';
import './Utils.sol';

contract Marketplace is Ownable, Utils {
    
    struct Manager {
        string name;
        uint reputation;
    }
    
    struct Freelancer {
        string name;
        uint reputation;
        string areaOfExpertise;
    }
    
    struct Evaluator {
        string name;
        uint reputation;
        string areaOfExpertise;
    }
    
    struct Founder {
        string name;
    }
    
    struct Product {
        string name;
        string description;
        uint developmentCost;
        uint evaluationCost;
        string areaOfExpertise;
        Manager manager;
    }
    
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
    
    // datatype initializatiors
    function initManager(address addr, string name) private {
        managerAddresses.push(addr);
        managers[addr].name = name;
        managers[addr].reputation = 5;
    }
    
    function initFreelancer(address addr, string name, string areaOfExpertise) private {
        freelancerAddresses.push(addr);
        freelancers[addr].name = name;
        freelancers[addr].areaOfExpertise = areaOfExpertise;
        freelancers[addr].reputation = 5;
    }
    
    function initEvaluator(address addr, string name, string areaOfExpertise) private {
        evaluatorAddresses.push(addr);
        evaluators[addr].name = name;
        evaluators[addr].areaOfExpertise = areaOfExpertise;
        evaluators[addr].reputation = 5;
    }
    
    function initFounder(address addr, string name) private {
        founderAddresses.push(addr);
        founders[addr].name = name;
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
    
    // gets 
    function getTokenBalance() public view returns (uint) {
        return token.balanceOf(msg.sender);
    }
     
    // constructors
    constructor(uint initialSupply) public {
        token = new MarketplaceToken(initialSupply);
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
        uint foundersInitSupply = token.currentSupply() / 2;
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
}