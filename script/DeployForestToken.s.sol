// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {ForestToken} from "../src/ForestToken.sol";

contract DeployForestToken is Script {
    uint256 public constant cap = 10_000_000;
    uint256 public reward = 5;
    ForestToken public token;

    function run() external returns (ForestToken) {
        vm.startBroadcast();
        token = new ForestToken(cap, reward);
        vm.stopBroadcast();
        return token;
    }
}
