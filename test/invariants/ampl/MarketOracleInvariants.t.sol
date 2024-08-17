// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Database} from "src/std/Database.sol";

import {MarketOracle} from "src/ampl/MarketOracle.sol";

contract MarketOracleChaincheck is Test {
    using stdJson for string;

    MarketOracle oracle;
    string config;

    function setUp() public {
        // Create mainnet fork from $RPC_URL.
        vm.createSelectFork(vm.envString("RPC_URL"));

        // Read config from database and instantiate contract.
        config = Database.read("./db/ampl/MarketOracle.json");
        oracle = MarketOracle(config.readAddress(".address"));
    }

    /// @custom:invariant The oracle providers valid data
    function testInvariant_ProvidesValidData() public {
        uint val;
        bool ok;
        (val, ok) = oracle.getData();

        assertTrue(ok);
    }

    /// @custom:invariant Every provider provides a valid report
    function testInvariant_EveryProviderProvidesValidReport() public {
        // Get delay and expiration thresholds.
        uint delay = oracle.reportDelaySec();
        uint expiration = oracle.reportExpirationTimeSec();

        uint providersSize = oracle.providersSize();
        for (uint i; i < providersSize; i++) {
            address provider = oracle.providers(i);
            assertTrue(provider != address(0));

            MarketOracle.Report memory report;
            uint age;
            bool passedDelay;
            bool expired;

            // Check report[0].
            report = oracle.providerReports(provider, 0);
            age = report.timestamp;
            passedDelay = block.timestamp - age > delay;
            expired = block.timestamp - age > expiration;
            if (passedDelay && !expired) {
                // Continue is report is valid.
                continue;
            }

            // Check report[1].
            report = oracle.providerReports(provider, 1);
            age = report.timestamp;
            passedDelay = block.timestamp - age > delay;
            expired = block.timestamp - age > expiration;
            if (passedDelay && !expired) {
                // Continue is report is valid.
                continue;
            }

            console.log(
                string.concat(
                    "provider does not have valid report: provider=",
                    vm.toString(provider)
                )
            );
            fail();
        }
    }
}

