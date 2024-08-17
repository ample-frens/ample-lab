// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Database} from "src/std/Database.sol";

import {Orchestrator} from "src/ampl/Orchestrator.sol";

contract OrchestratorChaincheck is Test {
    using stdJson for string;

    Orchestrator orchestrator;
    string config;

    function setUp() public {
        // Create mainnet fork from $RPC_URL.
        vm.createSelectFork(vm.envString("RPC_URL"));

        // Read config from database and instantiate contract.
        config = Database.read("./db/ampl/Orchestrator.json");
        orchestrator = Orchestrator(config.readAddress(".address"));
    }

    function testChaincheck_ownable() public view {
        address want = config.readAddress(".owner");
        address got = orchestrator.owner();

        assertEq(want, got);
    }

    function testChaincheck_monetaryPolicy() public view {
        address want = config.readAddress(".monetaryPolicy");
        address got = orchestrator.policy();

        assertEq(want, got);
    }

    function testChaincheck_transactions() public {
        console.log("not yet implemented");
        fail();
    }
}
