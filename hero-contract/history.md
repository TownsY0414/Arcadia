
# Product history md for hero contract

## Idea background

- We will create a on-chain game where users can battle each other to earn points.
- The game will be built on top of the hero contract.
- The game will be a simple turn-based battle game.
- The game will be free to play.
- Users will be able to battle each other to earn points.
- Users will be able to use the points to bid for NFTs or redeem real business coupons and more.

## Hero contract

- We will use the hero contract as the core logic for the game.
- Act as:
  - Initial(create new hero with random attributes).
  - Saving(save the hero attributes to the contract).
  - Loading(load the hero attributes from the contract).

## Contract API

- We will use API, ABIs to interact with the hero contract.
- Act as:
  - Initial:
    - Frontend send a request to get a new hero(if this account never has a hero in hero contract)
    - create a new hero with random attributes.
      - Data structure send to backend:
        - Account address
        - heroName
      - heroAttributes(random initiate)
        - {"Spring"：1，"Summer"：1，"Autumn"：1，"Winter"：1}
      - heroEnergy(default 3)
      - heroSkills
        - {"sharpen":1，"heal":1，"fireball":1，"thunder":1}
      - Response:
        - Status(success or failed).
        <!-- - Last Hash of the hero attributes(generate by backend with sha256 and salt). -->
  - Saving(save the hero attributes to the contract).
    - Invoke API to send the client's hero attributes to the contract.
    - Data structure:
      - Account address
      - heroName
      - heroAttributes(random initiate)
        - {"Spring"：1，"Summer"：1，"Autumn"：1，"Winter"：1}
      - heroEnergy(default 3)
      - heroSkills
        - {"sharpen":1，"heal":1，"fireball":1，"thunder":1}
    - Response:
      - Status(success or failed).
  - Loading(load the hero attributes from the contract).
    - Invoke API to get the hero attributes from the contract.
    - Data structure:
      - Account address
      - heroName
      - heroAttributes(random initiate)
        - {"Spring"：1，"Summer"：1，"Autumn"：1，"Winter"：1}
      - heroEnergy(default 3)
      - heroSkills
        - {"sharpen":1，"heal":1，"fireball":1，"thunder":1}

## Version 0.1

- Initial the hero.
- Save the hero.
- Load the hero.

## Version 0.1.1 Changes

### Contract Structure Updates

- Simplified hero data structure by removing unnecessary fields (heroId, heroLevel, heroExperience)
- Removed hash verification and signature requirements for simpler implementation
- Added default values for new heroes:
  - All attributes (Spring, Summer, Autumn, Winter) start at 1
  - heroEnergy starts at 3
  - All skills (sharpen, heal, fireball, thunder) start at 1

### New Features

- Added `hasHeroCreated` function to check if an address has a hero
- Simplified hero creation to only require a hero name
- Structured hero attributes into seasonal powers (Spring, Summer, Autumn, Winter)
- Implemented specific skill set structure (sharpen, heal, fireball, thunder)

### Contract Functions

1. `createHero(string calldata _heroName)`
   - Creates new hero with default attributes and skills
   - Emits HeroCreated event

2. `saveHero(HeroData calldata _heroData)`
   - Updates existing hero data
   - Emits HeroUpdated event

3. `getHero(address _owner)`
   - Returns hero data for given address

4. `hasHeroCreated(address _owner)`
   - Returns boolean indicating if address has a hero

### Test Coverage

- Added comprehensive tests for:
  - Hero creation with default values
  - Duplicate hero prevention
  - Hero data updates
  - Error cases for non-existent heroes

Test result:
```
hero-contract|main ⇒ forge build
[⠊] Compiling...
[⠔] Compiling 29 files with Solc 0.8.23
[⠑] Solc 0.8.23 finished in 3.43s
Compiler run successful!
hero-contract|main ⇒ forge test -vvv
[⠒] Compiling...
No files changed, compilation skipped

Ran 4 tests for test/Hero.t.sol:HeroTest
[PASS] testCannotCreateDuplicateHero() (gas: 259289)
[PASS] testCannotSaveNonexistentHero() (gas: 14395)
[PASS] testCreateHero() (gas: 267986)
[PASS] testSaveHero() (gas: 271374)
Suite result: ok. 4 passed; 0 failed; 0 skipped; finished in 11.18ms (1.84ms CPU time)

Ran 2 tests for test/Counter.t.sol:CounterTest
[PASS] testFuzz_SetNumber(uint256) (runs: 256, μ: 31210, ~: 31288)
[PASS] test_Increment() (gas: 31303)
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 21.96ms (15.21ms CPU time)

Ran 2 test suites in 396.87ms (33.15ms CPU time): 6 tests passed, 0 failed, 0 skipped (6 total tests)
```

Please create a contract in this git repo.
I initialed hero-contract in this repo by foundry forge.
Please follow  history.md to create the contract and test file for it

## How to Use

### Interacting with Contract ABI

1. Creating a Hero

```javascript
// Function signature: createHero(string)
const createHeroABI = {
    "inputs": [{"type": "string", "name": "_heroName"}],
    "name": "createHero",
    "type": "function"
};

// Example calldata construction
const heroName = "MyHero";
const createCalldata = web3.eth.abi.encodeFunctionCall(createHeroABI, [heroName]);
// Result: 0x4c988c16000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000064d794865726f000000000000000000000000000000000000000000000000000000
```

1. Saving Hero Data

```javascript
// Function signature: saveHero((string,(uint256,uint256,uint256,uint256),uint256,(uint256,uint256,uint256,uint256)))
const saveHeroABI = {
    "inputs": [{
        "components": [
            {"name": "heroName", "type": "string"},
            {"components": [
                {"name": "spring", "type": "uint256"},
                {"name": "summer", "type": "uint256"},
                {"name": "autumn", "type": "uint256"},
                {"name": "winter", "type": "uint256"}
            ], "name": "attributes", "type": "tuple"},
            {"name": "heroEnergy", "type": "uint256"},
            {"components": [
                {"name": "sharpen", "type": "uint256"},
                {"name": "heal", "type": "uint256"},
                {"name": "fireball", "type": "uint256"},
                {"name": "thunder", "type": "uint256"}
            ], "name": "skills", "type": "tuple"}
        ],
        "name": "_heroData",
        "type": "tuple"
    }],
    "name": "saveHero",
    "type": "function"
};

// Example data
const heroData = {
    heroName: "MyHero",
    attributes: {
        spring: 1,
        summer: 1,
        autumn: 1,
        winter: 1
    },
    heroEnergy: 3,
    skills: {
        sharpen: 1,
        heal: 1,
        fireball: 1,
        thunder: 1
    }
};

// Encode calldata
const saveCalldata = web3.eth.abi.encodeFunctionCall(saveHeroABI, [heroData]);
```

1. Loading Hero Data

```javascript
// Function signature: getHero(address)
const getHeroABI = {
    "inputs": [{"type": "address", "name": "_owner"}],
    "name": "getHero",
    "outputs": [{
        "components": [
            {"name": "heroName", "type": "string"},
            {"components": [
                {"name": "spring", "type": "uint256"},
                {"name": "summer", "type": "uint256"},
                {"name": "autumn", "type": "uint256"},
                {"name": "winter", "type": "uint256"}
            ], "name": "attributes", "type": "tuple"},
            {"name": "heroEnergy", "type": "uint256"},
            {"components": [
                {"name": "sharpen", "type": "uint256"},
                {"name": "heal", "type": "uint256"},
                {"name": "fireball", "type": "uint256"},
                {"name": "thunder", "type": "uint256"}
            ], "name": "skills", "type": "tuple"}
        ],
        "type": "tuple"
    }],
    "type": "function"
};

// Example calldata construction
const address = "0x1234..."; // The address to query
const getCalldata = web3.eth.abi.encodeFunctionCall(getHeroABI, [address]);

// Decoding the response
const decodedData = web3.eth.abi.decodeParameters([{
    components: [
        { name: 'heroName', type: 'string' },
        { 
            name: 'attributes', 
            type: 'tuple',
            components: [
                { name: 'spring', type: 'uint256' },
                { name: 'summer', type: 'uint256' },
                { name: 'autumn', type: 'uint256' },
                { name: 'winter', type: 'uint256' }
            ]
        },
        { name: 'heroEnergy', type: 'uint256' },
        {
            name: 'skills',
            type: 'tuple',
            components: [
                { name: 'sharpen', type: 'uint256' },
                { name: 'heal', type: 'uint256' },
                { name: 'fireball', type: 'uint256' },
                { name: 'thunder', type: 'uint256' }
            ]
        }
    ],
    type: 'tuple'
}], responseData);
```

### Important Notes

1. All numeric values (uint256) should be passed as strings to avoid precision issues
2. The calldata can be used in:
   - Web3.js: `web3.eth.sendTransaction({to: contractAddress, data: calldata})`
   - Ethers.js: `contract.interface.encodeFunctionData()`
   - Direct blockchain transactions: Use the calldata in the `data` field
3. For view functions (like getHero), you can use eth_call instead of sending a transaction
4. Always verify the contract address before sending transactions

### Deploy

Deployer: 0xe24b6f321B0140716a2b671ed0D983bb64E7DaFA
Deployed to: 0xA7704A27E7c26021e61BB00fd7D21DdAaE822e58
Transaction hash: 0xaeff7d73302e342181e5c00da0b10b6914bde8bb1af2b1e6208dd67fc9ab0c1c
Starting contract verification...
Waiting for etherscan to detect contract deployment...
Start verifying contract `0xA7704A27E7c26021e61BB00fd7D21DdAaE822e58` deployed on sepolia

Submitting verification for [src/Hero.sol:Hero] 0xA7704A27E7c26021e61BB00fd7D21DdAaE822e58.
Submitted contract for verification:
	Response: `OK`
	GUID: `ncejxxahbazhtw7sm9klxccjcggnrngt8gdjhcvivdsgpwlsnz`
	URL: https://sepolia.etherscan.io/address/0xa7704a27e7c26021e61bb00fd7d21ddaae822e58
Contract verification status:
Response: `NOTOK`
Details: `Pending in queue`
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified

# Version 0.1.2

- we will add two new features:
  1. add verification to the client side communication to avoid the man-in-the-middle attack.
     1. It is a simple session-key, signed by user's fingerprint.
     2. The session-key will be generated in the client side and stored in the local-storage of the client.
     3. The session-key will be sent within calldata to the backend server and verified by the backend validators.
     4. The session-key will be updated in the client side when it is expired.
     5. Only used in the loading and saving method to skip the signature verification of the client side for 1 hour.
  2. add a NFT address verification to the loading and saving method.
     1. Account should have a NFT to interact with the hero contract.
     2. This NFT published by the Community NFT feature by specific NFT contract.
     3. The NFT contract address will be added in the hero contract.
     4. The NFT owner address will be verified in the loading and saving method.
     5. The NFT is a Soul Bound NFT, it means it cannot be transferred or sold.

