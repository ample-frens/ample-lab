// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Database} from "src/std/Database.sol";

import {MonetaryPolicy} from "src/ampl/MonetaryPolicy.sol";

contract MonetaryPolicyChaincheck is Test {
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

    function testChaincheck_ownable() public view {
        address want = config.readAddress(".owner");
        address got = policy.owner();

        assertEq(want, got);
    }

    function testChaincheck_ampl() public view {
        address want = config.readAddress(".ampl");
        address got = policy.uFrags();

        assertEq(want, got);
    }

    function testChaincheck_cpiOracle() public view {
        address want = config.readAddress(".cpiOracle");
        address got = policy.cpiOracle();

        assertEq(want, got);
    }

    function testChaincheck_marketOracle() public view {
        address want = config.readAddress(".marketOracle");
        address got = policy.marketOracle();

        assertEq(want, got);
    }

    function testChaincheck_orchestrator() public view {
        address want = config.readAddress(".orchestrator");
        address got = policy.orchestrator();

        assertEq(want, got);
    }

    function testChaincheck_deviationThreshold() public view {
        uint want = config.readUint(".deviationThreshold");
        uint got = policy.deviationThreshold();

        assertEq(want, got);
    }

    function testChaincheck_rebaseLag() public view {
        uint want = config.readUint(".rebaseLag");
        uint got = policy.rebaseLag();

        assertEq(want, got);
    }

    function testChaincheck_minRebaseTimeIntervalSec() public view {
        uint want = config.readUint(".minRebaseTimeIntervalSec");
        uint got = policy.minRebaseTimeIntervalSec();

        assertEq(want, got);
    }

    function testChaincheck_rebaseWindowOffsetSec() public view {
        uint want = config.readUint(".rebaseWindowOffsetSec");
        uint got = policy.rebaseWindowOffsetSec();

        assertEq(want, got);
    }

    function testChaincheck_rebaseWindowLengthSec() public view {
        uint want = config.readUint(".rebaseWindowLengthSec");
        uint got = policy.rebaseWindowLengthSec();

        assertEq(want, got);
    }
}

