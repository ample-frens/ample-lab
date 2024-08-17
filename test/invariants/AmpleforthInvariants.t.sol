// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Database} from "src/std/Database.sol";

import {AMPL} from "src/ampl/AMPL.sol";
import {WAMPL} from "src/ampl/WAMPL.sol";
import {MonetaryPolicy} from "src/ampl/MonetaryPolicy.sol";
import {CPIOracle} from "src/ampl/CPIOracle.sol";
import {MarketOracle} from "src/ampl/MarketOracle.sol";
import {Orchestrator} from "src/ampl/Orchestrator.sol";

contract AmpleforthInvariants is Test {
    using stdJson for string;

    AMPL ampl;
    WAMPL wampl;
    MonetaryPolicy monetaryPolicy;
    CPIOracle cpiOracle;
    MarketOracle marketOracle;
    Orchestrator orchestrator;

    function setUp() public {
        // Create mainnet fork from $RPC_URL.
        vm.createSelectFork(vm.envString("RPC_URL"));

        // Read configs from database and instantiate contracts.
        ampl =
            AMPL(Database.read("./db/ampl/AMPL.json").readAddress(".address"));
        wampl =
            WAMPL(Database.read("./db/ampl/WAMPL.json").readAddress(".address"));
        monetaryPolicy = MonetaryPolicy(
            Database.read("./db/ampl/MonetaryPolicy.json").readAddress(
                ".address"
            )
        );
        cpiOracle = CPIOracle(
            Database.read("./db/ampl/CPIOracle.json").readAddress(".address")
        );
        marketOracle = MarketOracle(
            Database.read("./db/ampl/MarketOracle.json").readAddress(".address")
        );
        orchestrator = Orchestrator(
            Database.read("./db/ampl/Orchestrator.json").readAddress(".address")
        );
    }

    /// @custom:invariant The monetary policy rebased in the last 24 hours
    function testInvariant_MonetaryPolicyRebasedInTheLast24Hours() public {
        uint lastRebase = monetaryPolicy.lastRebaseTimestampSec();

        assertTrue(block.timestamp - lastRebase < 24 hours);
    }

    /// @custom:invariant The CPI oracle providers valid data
    function testInvariant_CPIOracleProvidesValidData() public {
        uint val;
        bool ok;
        (val, ok) = cpiOracle.getData();

        assertTrue(ok);
    }

    /// @custom:invariant Every CPI oracle provider provides a valid report
    function testInvariant_EveryCPIOracleProviderProvidesValidReport() public {
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

    /// @custom:invariant The market oracle providers valid data
    function testInvariant_MarketOracleProvidesValidData() public {
        uint val;
        bool ok;
        (val, ok) = marketOracle.getData();

        assertTrue(ok);
    }

    /// @custom:invariant Every market oracle provider provides a valid report
    function testInvariant_EveryMarketOracleProviderProvidesValidReport()
        public
    {
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

    /// @custom:invariant Every orchestrator transaction is enabled
    function testInvariant_EveryOrchestratorTransactionIsEnabled() public {
        uint transactionsSize = orchestrator.transactionsSize();

        for (uint i; i < transactionsSize; i++) {
            Orchestrator.Transaction memory transaction =
                orchestrator.transactions(i);

            assertTrue(transaction.enabled);
        }
    }

    /// @custom:invariant Every orchestrator transaction is executable
    function testInvariant_EveryOrchestratorTransactionIsExecutable() public {
        uint transactionsSize = orchestrator.transactionsSize();

        for (uint i; i < transactionsSize; i++) {
            Orchestrator.Transaction memory tx_ = orchestrator.transactions(i);

            if (!tx_.enabled) {
                continue;
            }

            vm.prank(address(orchestrator));
            (bool ok,) = tx_.destination.call(tx_.data);
            assertTrue(ok);
        }
    }
}
