// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

error FunctionDisabled(string errorMsg);

contract ForestToken is ERC20, ERC20Capped, ERC20Burnable, AccessControl {
    bytes32 public constant MINER_ROLE = keccak256("MINER_ROLE");

    address payable public s_owner;
    uint256 private s_blockReward;
    uint256 public s_TotalTreesPlanted;

    event TreesPlanted(address indexed sender, uint256 amount);

    event MintedReward(address indexed miner, uint256 indexed reward, uint256 indexed timestamp);
    event TokensBurned(address indexed burner, uint256 indexed amount, uint256 timestamp);

    constructor(uint256 cap, uint256 _reward) ERC20("ForestToken", "FST") ERC20Capped(cap * (10 ** decimals())) {
        s_owner = payable(msg.sender);
        s_blockReward = _reward * (10 ** decimals());
        s_TotalTreesPlanted = (initialSupply(cap) * (10 ** decimals()));
        _mint(s_owner, s_TotalTreesPlanted);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINER_ROLE, msg.sender);
    }

    //calculating the 25% of the cap as the inital supply of the token launch
    function initialSupply(uint256 _cap) public pure returns (uint256) {
        return (_cap * 25) / 100;
    }

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Capped) {
        if (
            from != address(0) && to != block.coinbase && block.coinbase != address(0)
                && ERC20.totalSupply() + s_blockReward <= cap()
        ) {
            _mintMinerReward();
            emit MintedReward(block.coinbase, s_blockReward, block.timestamp);
        }
        super._update(from, to, value);
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, s_blockReward);
    }

    function plantTree(uint256 amount) external {
        require(!hasRole(MINER_ROLE, msg.sender), "MINER IS NOT ALLOWED TO PLANT");
        require(totalSupply() + amount + s_blockReward <= cap(), "ForestToken_ERC20Capped: cap exceeded");

        s_TotalTreesPlanted = s_TotalTreesPlanted + amount;
        _mint(msg.sender, amount);
        emit TreesPlanted(msg.sender, amount);
        _mintMinerReward();
        emit MintedReward(block.coinbase, s_blockReward, block.timestamp);
    }

    function setBlockReward(uint256 _reward) public onlyRole(DEFAULT_ADMIN_ROLE) {
        s_blockReward = _reward * (10 ** decimals());
    }

    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn");
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount, block.timestamp);
    }

    //getter function
    function getBlockReward() public view returns (uint256) {
        return s_blockReward;
    }

    //removing some functions

    function renounceRole(bytes32, /*role*/ address /*callerConfirnation*/ ) public virtual override {
        revert FunctionDisabled("Support Interface is disabled");
    }
}
