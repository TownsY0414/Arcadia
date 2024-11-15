// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {Hero} from "../src/Hero.sol";

contract HeroTest is Test {
    Hero public hero;
    address public player;
    bytes32 public constant SALT = bytes32(uint256(1));

    function setUp() public {
        hero = new Hero(SALT);
        player = makeAddr("player");
        vm.deal(player, 100 ether);
    }

    function testCreateHero() public {
        vm.startPrank(player);

        string[] memory skills = new string[](2);
        skills[0] = "Slash";
        skills[1] = "Block";

        Hero.HeroAttributes memory attrs = Hero.HeroAttributes({
            strength: 10,
            dexterity: 10,
            constitution: 10,
            intelligence: 10,
            wisdom: 10,
            charisma: 10
        });

        Hero.HeroData memory heroData = Hero.HeroData({
            heroId: 1,
            heroName: "TestHero",
            attributes: attrs,
            heroLevel: 1,
            heroExperience: 0,
            heroSkills: skills,
            lastHash: bytes32(0)
        });

        // TODO: Generate proper signature
        bytes memory signature = bytes("dummy_signature");

        hero.createHero(heroData, signature);

        Hero.HeroData memory savedHero = hero.getHero(player);
        assertEq(savedHero.heroName, "TestHero");
        assertEq(savedHero.heroLevel, 1);
        assertEq(savedHero.attributes.strength, 10);

        vm.stopPrank();
    }

    function testCannotCreateDuplicateHero() public {
        vm.startPrank(player);

        string[] memory skills = new string[](1);
        skills[0] = "Slash";

        Hero.HeroAttributes memory attrs = Hero.HeroAttributes({
            strength: 10,
            dexterity: 10,
            constitution: 10,
            intelligence: 10,
            wisdom: 10,
            charisma: 10
        });

        Hero.HeroData memory heroData = Hero.HeroData({
            heroId: 1,
            heroName: "TestHero",
            attributes: attrs,
            heroLevel: 1,
            heroExperience: 0,
            heroSkills: skills,
            lastHash: bytes32(0)
        });

        bytes memory signature = bytes("dummy_signature");

        hero.createHero(heroData, signature);
        
        vm.expectRevert(Hero.HeroAlreadyExists.selector);
        hero.createHero(heroData, signature);

        vm.stopPrank();
    }
} 