// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Hero Contract for On-Chain Battle Game
/// @notice This contract manages hero creation, saving, and loading for the game
contract Hero {
    // Structs
    struct HeroAttributes {
        uint256 spring;
        uint256 summer;
        uint256 autumn;
        uint256 winter;
    }

    struct HeroSkills {
        uint256 sharpen;
        uint256 heal;
        uint256 fireball;
        uint256 thunder;
    }

    struct HeroData {
        string heroName;
        HeroAttributes attributes;
        uint256 heroEnergy;
        HeroSkills skills;
    }

    // State variables
    mapping(address => HeroData) private heroes;
    mapping(address => bool) private hasHero;
    
    // Events
    event HeroCreated(address indexed owner, string heroName);
    event HeroUpdated(address indexed owner, string heroName);

    // Errors
    error HeroAlreadyExists();
    error HeroDoesNotExist();

    /// @notice Creates a new hero for the caller
    /// @param _heroName The name of the hero
    function createHero(string calldata _heroName) external {
        if (hasHero[msg.sender]) revert HeroAlreadyExists();
        
        // Initialize hero with default values
        HeroData memory newHero = HeroData({
            heroName: _heroName,
            attributes: HeroAttributes({
                spring: 1,
                summer: 1,
                autumn: 1,
                winter: 1
            }),
            heroEnergy: 3,
            skills: HeroSkills({
                sharpen: 1,
                heal: 1,
                fireball: 1,
                thunder: 1
            })
        });

        heroes[msg.sender] = newHero;
        hasHero[msg.sender] = true;

        emit HeroCreated(msg.sender, _heroName);
    }

    /// @notice Updates an existing hero's data
    /// @param _heroData The updated hero data
    function saveHero(HeroData calldata _heroData) external {
        if (!hasHero[msg.sender]) revert HeroDoesNotExist();
        
        heroes[msg.sender] = _heroData;
        emit HeroUpdated(msg.sender, _heroData.heroName);
    }

    /// @notice Retrieves the hero data for an address
    /// @param _owner The address of the hero owner
    /// @return The hero data
    function getHero(address _owner) external view returns (HeroData memory) {
        if (!hasHero[_owner]) revert HeroDoesNotExist();
        return heroes[_owner];
    }

    /// @notice Checks if an address has a hero
    /// @param _owner The address to check
    /// @return Whether the address has a hero
    function hasHeroCreated(address _owner) external view returns (bool) {
        return hasHero[_owner];
    }
} 