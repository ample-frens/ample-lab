// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {console2 as console} from "forge-std/console2.sol";

// Ampleforth
import {CPIOracle} from "src/ampl/CPIOracle.sol";
import {MarketOracle} from "src/ampl/MarketOracle.sol";
import {Orchestrator} from "src/ampl/Orchestrator.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract AmpleforthHealthcheck is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    /// @dev Tests whether the monetary policy rebased in the last 24 hours.
    function test_monetaryPolicy_RebasedInTheLast24Hours() public view {
        uint lastRebase = monetaryPolicy.lastRebaseTimestampSec();

        assertTrue(block.timestamp - lastRebase < 24 hours);
    }

    /// @dev Tests whether the CPI oracle can be read, ie provides valid data.
    function test_cpiOracle_ProvidesValidData() public {
        uint val;
        bool ok;
        (val, ok) = cpiOracle.getData();

        assertTrue(ok);
    }

    /// @dev Tests whether the market oracle can be read, ie provides valid data.
    function test_marketOracle_ProvidesValidData() public {
        uint val;
        bool ok;
        (val, ok) = marketOracle.getData();

        assertTrue(ok);
    }

    /// @dev Tests whether every CPI oracle provider has a valid report onchain.
    function test_cpiOracle_EveryProviderHasValidReport() public {
        // Get delay and expiration thresholds.
        uint delay = cpiOracle.reportDelaySec();
        uint expiration = cpiOracle.reportExpirationTimeSec();

        uint providersSize = cpiOracle.providersSize();
        for (uint i; i < providersSize; i++) {
            address provider = cpiOracle.providers(i);
            assertTrue(provider != address(0));

            CPIOracle.Report memory report;
            uint age;
            bool passedDelay;
            bool expired;

            // Check report[0].
            report = cpiOracle.providerReports(provider, 0);
            age = report.timestamp;
            passedDelay = block.timestamp - age > delay;
            expired = block.timestamp - age > expiration;
            if (passedDelay && !expired) {
                // Continue is report is valid.
                continue;
            }

            // Check report[1].
            report = cpiOracle.providerReports(provider, 1);
            age = report.timestamp;
            passedDelay = block.timestamp - age > delay;
            expired = block.timestamp - age > expiration;
            if (passedDelay && !expired) {
                // Continue is report is valid.
                continue;
            }

            console.log(
                string.concat(
                    "CPI oracle provider does not have valid report: provider=",
                    vm.toString(provider)
                )
            );
            fail();
        }
    }

    /// @dev Tests whether every CPI oracle provider has a valid report onchain.
    function test_marketOracle_EveryProviderHasValidReport() public {
        // Get delay and expiration thresholds.
        uint delay = marketOracle.reportDelaySec();
        uint expiration = marketOracle.reportExpirationTimeSec();

        uint providersSize = marketOracle.providersSize();
        for (uint i; i < providersSize; i++) {
            address provider = marketOracle.providers(i);
            assertTrue(provider != address(0));

            MarketOracle.Report memory report;
            uint age;
            bool passedDelay;
            bool expired;

            // Check report[0].
            report = marketOracle.providerReports(provider, 0);
            age = report.timestamp;
            passedDelay = block.timestamp - age > delay;
            expired = block.timestamp - age > expiration;
            if (passedDelay && !expired) {
                // Continue is report is valid.
                continue;
            }

            // Check report[1].
            report = marketOracle.providerReports(provider, 1);
            age = report.timestamp;
            passedDelay = block.timestamp - age > delay;
            expired = block.timestamp - age > expiration;
            if (passedDelay && !expired) {
                // Continue is report is valid.
                continue;
            }

            console.log(
                string.concat(
                    "Market oracle provider does not have valid report: provider=",
                    vm.toString(provider)
                )
            );
            fail();
        }
    }

    /// @dev Tests whether every orchestrator transaction is enabled.
    function test_orchestrator_EveryTransactionIsEnabled() public view {
        uint transactionsSize = orchestrator.transactionsSize();

        for (uint i; i < transactionsSize; i++) {
            bool enabled;
            (enabled, /*target*/, /*data*/ ) = orchestrator.transactions(i);

            assertTrue(enabled);
        }
    }

    /// @dev Tests whether every orchestrator transaction is executable.
    function test_orchestrator_EveryTransactionIsExecutable() public {
        uint transactionsSize = orchestrator.transactionsSize();

        for (uint i; i < transactionsSize; i++) {
            bool enabled;
            address target;
            bytes memory data;
            (enabled, target, data) = orchestrator.transactions(i);

            if (!enabled) {
                continue;
            }

            vm.prank(address(orchestrator));
            (bool ok,) = target.call(data);
            assertTrue(ok);
        }
    }
}
