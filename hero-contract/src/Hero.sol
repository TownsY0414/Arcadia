// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Hero Contract for On-Chain Battle Game
/// @notice This contract manages hero creation, saving, and loading for the game
contract Hero {
    // Structs
    struct HeroAttributes {
        uint256 strength;
        uint256 dexterity;
        uint256 constitution;
        uint256 intelligence;
        uint256 wisdom;
        uint256 charisma;
    }

    struct HeroData {
        uint256 heroId;
        string heroName;
        HeroAttributes attributes;
        uint256 heroLevel;
        uint256 heroExperience;
        string[] heroSkills;
        bytes32 lastHash;
    }

    // State variables
    mapping(address => HeroData) private heroes;
    mapping(address => bool) private hasHero;
    bytes32 private salt;
    
    // Events
    event HeroCreated(address indexed owner, uint256 heroId, string heroName);
    event HeroUpdated(address indexed owner, uint256 heroId, bytes32 newHash);

    // Errors
    error HeroAlreadyExists();
    error HeroDoesNotExist();
    error InvalidHash();
    error InvalidSignature();

    constructor(bytes32 _salt) {
        salt = _salt;
    }

    /// @notice Creates a new hero for the caller
    /// @param _heroData The hero data to initialize
    /// @param _signature The signature to verify the request
    function createHero(HeroData calldata _heroData, bytes calldata _signature) external {
        if (hasHero[msg.sender]) revert HeroAlreadyExists();
        
        // TODO: Implement signature verification
        _verifySignature(_heroData, _signature);

        heroes[msg.sender] = _heroData;
        hasHero[msg.sender] = true;

        emit HeroCreated(msg.sender, _heroData.heroId, _heroData.heroName);
    }

    /// @notice Updates an existing hero's data
    /// @param _heroData The updated hero data
    /// @param _signature The signature to verify the request
    function saveHero(HeroData calldata _heroData, bytes calldata _signature) external {
        if (!hasHero[msg.sender]) revert HeroDoesNotExist();
        
        // Verify the last hash matches
        if (_heroData.lastHash != heroes[msg.sender].lastHash) revert InvalidHash();
        
        // TODO: Implement signature verification
        _verifySignature(_heroData, _signature);

        // Calculate new hash
        bytes32 newHash = _calculateHash(_heroData);
        _heroData.lastHash = newHash;

        heroes[msg.sender] = _heroData;
        emit HeroUpdated(msg.sender, _heroData.heroId, newHash);
    }

    /// @notice Retrieves the hero data for an address
    /// @param _owner The address of the hero owner
    /// @return The hero data
    function getHero(address _owner) external view returns (HeroData memory) {
        if (!hasHero[_owner]) revert HeroDoesNotExist();
        return heroes[_owner];
    }

    /// @notice Calculates the hash of hero data
    /// @param _heroData The hero data to hash
    /// @return The calculated hash
    function _calculateHash(HeroData calldata _heroData) internal view returns (bytes32) {
        return keccak256(abi.encodePacked(
            _heroData.heroId,
            _heroData.heroName,
            _heroData.attributes.strength,
            _heroData.attributes.dexterity,
            _heroData.attributes.constitution,
            _heroData.attributes.intelligence,
            _heroData.attributes.wisdom,
            _heroData.attributes.charisma,
            _heroData.heroLevel,
            _heroData.heroExperience,
            _heroData.heroSkills,
            salt
        ));
    }

    /// @notice Verifies the signature of a request
    /// @param _heroData The hero data to verify
    /// @param _signature The signature to verify
    function _verifySignature(HeroData calldata _heroData, bytes calldata _signature) internal pure {
        // TODO: Implement BLS signature verification
        // This is a placeholder that needs to be implemented based on your specific signature scheme
        require(_signature.length > 0, "Signature required");
    }
} 