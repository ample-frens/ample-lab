// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Database} from "src/std/Database.sol";

import {Orchestrator} from "src/ampl/Orchestrator.sol";

contract OrchestratorInvariants is Test {
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

    /// @custom:invariant Every transaction is enabled
    function testInvariant_EveryTransactionIsEnabled() public {
        uint transactionsSize = orchestrator.transactionsSize();

        for (uint i; i < transactionsSize; i++) {
            Orchestrator.Transaction memory transaction = orchestrator.transactions(i);

            assertTrue(transaction.enabled);
        }
    }

    /// @custom:invariant Every transaction is executable
    function testInvariant_EveryTransactionIsExecutable() public {
        uint transactionsSize = orchestrator.transactionsSize();

        for (uint i; i < transactionsSize; i++) {
            Orchestrator.Transaction memory tx_ = orchestrator.transactions(i);

            if (!tx_.enabled) {
                continue;
            }

            vm.prank(address(orchestrator));
            tx_.destination.call(tx_.data);
        }
    }
}

