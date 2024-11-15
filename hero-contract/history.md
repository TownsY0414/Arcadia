
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

Please create a contract in this git repo.
I initialed hero-contract in this repo by foundry forge.
Please follow  history.md to create the contract and test file for it
