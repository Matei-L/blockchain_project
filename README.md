# blockchain_project
## Notes:
Stage 1 done.
Todo: some code is commented because Marketplace.sol was to big for remix. We need to break it appart in more contracts (maybe add a contract for the logic related to the user types)
### To start:
1. deploy MarketplaceToken with what you want to be the mak amount of tokens.
2. deploy Users with MarketplaceToken's address
3. deploy MarketPlace with Users's address
4. the owner transfers all tokens to the Users (using MarketplaceToken)
5. the owner makes a dummyInit (using Users)

### Steps to make a contribution:
Node: they can be applyed to other token transactions as well
1. the "user" makes an approve with that sum for the product's address (using MarketplaceToken)
2. the "user" calls contributeFunding with that sum (using Marketplace)