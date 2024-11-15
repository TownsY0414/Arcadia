
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

## Frontend

- We will use API, ABIs to interact with the hero contract.
- Act as:
  - Initial:
    - Frontend send a request to get a new hero(if this account never has a hero in hero contract)
    - create a new hero with random attributes.
      - Data structure send to backend:
        - Account address
        - heroName
        - heroAttributes:4
        - heroEnergy: default 3
        <!-- - heroSkills: -->
        <!-- - Signature(generate by this AirAccount with BLS(fingerprint) key). -->
      - Response:
        - Status(success or failed).
        <!-- - Last Hash of the hero attributes(generate by backend with sha256 and salt). -->
  - Saving(save the hero attributes to the contract).
    - Invoke API to send the client's hero attributes to the contract.
    - Data structure:
      - Account address
      - heroName
      - heroAttributes(random 4)
      - heroEnergy(default 3)
      - heroSkills
        - ???
      <!-- - Last Hash of the hero attributes(generate by backend with sha256 and salt, get from initial or saving response). -->
      <!-- - Signature(generate by this AirAccount with BLS(fingerprint) key). -->
    - Response:
      - Status(success or failed).
      <!-- - Hash of the hero attributes(generate by backend with sha256 and salt, get from initial or saving response). -->
  - Loading(load the hero attributes from the contract).
    - Invoke API to get the hero attributes from the contract.
    - Data structure:
      - Account address
      - heroName
      - heroAttributes
      - heroEnergy
      - heroSkills
      <!-- - Last Hash of the hero attributes(generate by backend with sha256 and salt) -->

## Version 0.1

- Initial the hero.
- Save the hero.
- Load the hero.

Please create a contract in this git repo.
I initialed hero-contract in this repo by foundry forge.
Please follow  history.md to create the contract and test file for it
