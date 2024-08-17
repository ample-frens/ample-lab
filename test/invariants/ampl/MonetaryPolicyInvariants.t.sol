// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Database} from "src/std/Database.sol";

import {MonetaryPolicy} from "src/ampl/MonetaryPolicy.sol";

contract MonetaryPolicyInvariants is Test {
    using stdJson for string;

    MonetaryPolicy policy;
    string config;

    function setUp() public {
        // Create mainnet fork from $RPC_URL.
        vm.createSelectFork(vm.envString("RPC_URL"));

        // Read config from database and instantiate contract.
        config = Database.read("./db/ampl/MonetaryPolicy.json");
        policy = MonetaryPolicy(config.readAddress(".address"));
    }

    /// @custom:invariant The monetary policy rebased in the last 24 hours
    function testInvariant_RebasedInTheLast24Hours() public {
        uint lastRebase = policy.lastRebaseTimestampSec();

        assertTrue(block.timestamp - lastRebase < 24 hours);
    }
}
