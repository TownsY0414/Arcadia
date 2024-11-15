// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {Hero} from "../src/Hero.sol";

contract HeroTest is Test {
    Hero public hero;
    address public player;

    function setUp() public {
        hero = new Hero();
        player = makeAddr("player");
        vm.deal(player, 100 ether);
    }

    function testCreateHero() public {
        vm.startPrank(player);

        // Create hero with just a name
        hero.createHero("TestHero");

        // Verify hero was created with default values
        Hero.HeroData memory savedHero = hero.getHero(player);
        
        assertEq(savedHero.heroName, "TestHero");
        assertEq(savedHero.heroEnergy, 3);
        
        // Check default attributes
        assertEq(savedHero.attributes.spring, 1);
        assertEq(savedHero.attributes.summer, 1);
        assertEq(savedHero.attributes.autumn, 1);
        assertEq(savedHero.attributes.winter, 1);
        
        // Check default skills
        assertEq(savedHero.skills.sharpen, 1);
        assertEq(savedHero.skills.heal, 1);
        assertEq(savedHero.skills.fireball, 1);
        assertEq(savedHero.skills.thunder, 1);

        vm.stopPrank();
    }

    function testCannotCreateDuplicateHero() public {
        vm.startPrank(player);

        hero.createHero("TestHero");
        
        vm.expectRevert(Hero.HeroAlreadyExists.selector);
        hero.createHero("AnotherHero");

        vm.stopPrank();
    }

    function testSaveHero() public {
        vm.startPrank(player);

        // First create a hero
        hero.createHero("TestHero");

        // Create updated hero data
        Hero.HeroData memory updatedHero = Hero.HeroData({
            heroName: "UpdatedHero",
            attributes: Hero.HeroAttributes({
                spring: 2,
                summer: 2,
                autumn: 2,
                winter: 2
            }),
            heroEnergy: 5,
            skills: Hero.HeroSkills({
                sharpen: 2,
                heal: 2,
                fireball: 2,
                thunder: 2
            })
        });

        // Save updated hero data
        hero.saveHero(updatedHero);

        // Verify updates
        Hero.HeroData memory savedHero = hero.getHero(player);
        assertEq(savedHero.heroName, "UpdatedHero");
        assertEq(savedHero.heroEnergy, 5);
        assertEq(savedHero.attributes.spring, 2);
        assertEq(savedHero.skills.sharpen, 2);

        vm.stopPrank();
    }

    function testCannotSaveNonexistentHero() public {
        vm.startPrank(player);

        Hero.HeroData memory heroData = Hero.HeroData({
            heroName: "TestHero",
            attributes: Hero.HeroAttributes({
                spring: 1,
                summer: 1,
                autumn: 1,
                winter: 1
            }),
            heroEnergy: 3,
            skills: Hero.HeroSkills({
                sharpen: 1,
                heal: 1,
                fireball: 1,
                thunder: 1
            })
        });

        vm.expectRevert(Hero.HeroDoesNotExist.selector);
        hero.saveHero(heroData);

        vm.stopPrank();
    }

    function testCalldataEncoding() public {
        vm.startPrank(player);

        // Test createHero calldata
        bytes memory createCalldata = abi.encodeWithSignature(
            "createHero(string)", 
            "TestHero"
        );
        (bool success,) = address(hero).call(createCalldata);
        assertTrue(success);

        // Test saveHero calldata
        Hero.HeroData memory heroData = Hero.HeroData({
            heroName: "UpdatedHero",
            attributes: Hero.HeroAttributes({
                spring: 2,
                summer: 2,
                autumn: 2,
                winter: 2
            }),
            heroEnergy: 5,
            skills: Hero.HeroSkills({
                sharpen: 2,
                heal: 2,
                fireball: 2,
                thunder: 2
            })
        });

        bytes memory saveCalldata = abi.encodeWithSignature(
            "saveHero((string,(uint256,uint256,uint256,uint256),uint256,(uint256,uint256,uint256,uint256)))",
            heroData
        );
        (success,) = address(hero).call(saveCalldata);
        assertTrue(success);

        // Test getHero directly instead of using low-level calls
        Hero.HeroData memory retrievedHero = hero.getHero(player);
        assertEq(retrievedHero.heroName, "UpdatedHero");
        assertEq(retrievedHero.heroEnergy, 5);
        assertEq(retrievedHero.attributes.spring, 2);
        assertEq(retrievedHero.skills.sharpen, 2);

        vm.stopPrank();
    }
} 