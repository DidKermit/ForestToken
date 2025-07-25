// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {DeployForestToken} from "../script/DeployForestToken.s.sol";
import {ForestToken} from "../src/ForestToken.sol";

contract DeployForestTokenTest is Test {
    DeployForestToken public deployForestToken;
    ForestToken public forestToken;

    uint256 public constant cap = 10000000 * (1e18);
    uint256 public reward = 5 * (1e18);

    address bob = makeAddr("BOB");
    address miner = address(0x123);

    event TreesPlanted(address indexed sender, uint256 amount);
    event MintedReward(address indexed miner, uint256 indexed reward, uint256 indexed timestamp);
    event TokensBurned(address indexed burner, uint256 indexed amount, uint256 timestamp);

    function setUp() public {
        deployForestToken = new DeployForestToken();
        forestToken = new ForestToken(cap, reward);
        forestToken.transfer(bob, 100 ether);
    }

    function test_revertWhen_capIsZero() public {
        vm.expectRevert();
        new ForestToken(0, reward);
    }

    function test_InitialSupplyofToken() public view {
        uint256 initial_totalSupply = forestToken.initialSupply(cap) * 1e18;
        assertEq(forestToken.totalSupply(), initial_totalSupply);
    }

    function test_AdminRoleGranted() public view {
        bytes32 ADMIN = 0x00;
        assertEq(ADMIN, forestToken.DEFAULT_ADMIN_ROLE());
    }

    function test_MinerRoleGranted() public view {
        bytes32 MINER = forestToken.MINER_ROLE();
        assertTrue(forestToken.hasRole(MINER, address(this)));
    }

    //plantTree function
    function test_revertWhen_MinerPlantTree() public {
        vm.expectRevert();
        forestToken.plantTree(100 ether);
    }

    function test_revertWhen_TotalSupplyMoreThanCap() public {
        vm.coinbase(miner);

        uint256 _cap = forestToken.cap();
        uint256 _total = forestToken.totalSupply();
        uint256 _reward = forestToken.getBlockReward();

        require(_cap > _total + _reward, "Test SetUp : cap underflow");
        uint256 Safeamount = _cap - _total - _reward;

        vm.prank(bob);
        forestToken.plantTree(Safeamount);

        vm.expectRevert("ForestToken_ERC20Capped: cap exceeded");
        vm.prank(bob);
        forestToken.plantTree(1);
    }

    function test_TotalTreesPlanted() public {
        uint256 before_planting = forestToken.s_TotalTreesPlanted();

        vm.coinbase(miner);
        vm.prank(bob);
        forestToken.plantTree(100 ether);

        uint256 after_planting = forestToken.s_TotalTreesPlanted();

        assertGt(after_planting, before_planting);
    }

    function test_EmitTreesPlanted() public {
        vm.coinbase(miner);

        vm.prank(bob);
        vm.expectEmit(true, false, false, true);
        emit TreesPlanted(bob, 100 ether);
        forestToken.plantTree(100 ether);
    }

    function test_EmitMintedReward() public {
        vm.coinbase(miner);

        uint256 _reward = forestToken.getBlockReward();
        vm.prank(bob);
        vm.expectEmit(true, true, false, false);
        emit MintedReward(miner, _reward, block.timestamp);
        forestToken.plantTree(100 ether);
    }

    //setBlockReward
    function test_revertWhen_NotAdmin() public {
        vm.coinbase(miner);

        vm.prank(miner);
        vm.expectRevert();
        forestToken.setBlockReward(555);
    }

    function testBurnTokensSuccess() public {
        uint256 initialSupply = forestToken.totalSupply();

        vm.prank(bob);
        forestToken.burnTokens(50 ether);

        assertEq(forestToken.balanceOf(bob), 50 ether);
        assertEq(forestToken.totalSupply(), initialSupply - 50 ether);
    }

    function testBurnTokensRevert_InsufficientBalance() public {
        vm.expectRevert("Insufficient balance to burn");
        vm.prank(bob);
        forestToken.burnTokens(200 ether);
    }

    function testEmitBurnEvent() public {
        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit TokensBurned(bob, 10 ether, block.timestamp);
        forestToken.burnTokens(10 ether);
    }

    //test DeployForestToken.s.sol
    function test_DeployScript() public {
        ForestToken token = deployForestToken.run();
        assert(address(token) != address(0));
    }
}
