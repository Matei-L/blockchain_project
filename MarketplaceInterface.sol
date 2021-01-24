pragma solidity ^0.4.6;

import 'https://github.com/aragon/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol';
import './MarketplaceToken.sol';
import './CrowdFunding.sol';
import './Utils.sol';

contract MarketplaceInterface is Ownable, Utils {
    
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
}