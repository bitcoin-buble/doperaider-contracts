# doperaider-contracts
This is the suite of contracts that make up the DopeRaider system.

Use truffle to compile and migrate the contracts to local RPC or POA Sokol/Core Networks

## Main contracts
1. DopeRaider Narcos is the **ERC721** token contract.
2. DopeRaider Districts is the main game logic.
3. SaleClockAuction is a standard reverse dutch auction contract.
4. DopeRaider Calculations is where the raiding and must formulas are maintained.
5. The **ERC20** token contracts are used to airdrop to addresses.

## Installation
1. Install truffle with **sudo npm install -g truffle**
2. Install TESTRPC with **sudo npm install -g ethereumjs-testrpc**
3. Install dependencies with **npm install**
4. In a separate shell start the local chain with increased block gas limit **testrpc -l 6700000**
5. Set an environment variable **export MNEMONIC="your seed words"**
6. Compile with **truffle compile**
7. Deploy to local RPC with **truffle migrate --network development --reset**
8. Test with **truffle test**
9. Deploy to sokol with **truffle migrate --network sokol --reset**
10. Deploy to core with **truffle migrate --network sokol --reset**

Note: You will need to use a funded account to deploy to sokol/core for gas pricing.
