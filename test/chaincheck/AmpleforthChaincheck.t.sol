// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract AmpleforthChaincheck is StatefulTest {
    using stdJson for string;

    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    function test_ampl_ownable() public view {
        address want = amplConfig.readAddress(".owner");
        address got = ampl.owner();

        assertEq(want, got);
    }

    // -- AMPL --

    function test_ampl_monetaryPolicy() public view {
        address want = amplConfig.readAddress(".monetaryPolicy");
        address got = ampl.monetaryPolicy();

        assertEq(want, got);
    }

    // -- WAMPL --

    function test_wampl_underlying() public view {
        address want = wamplConfig.readAddress(".underlying");
        address got = wampl.underlying();

        assertEq(want, got);
    }

    // -- Monetary Policy --

    function test_monetaryPolicy_ownable() public view {
        address want = monetaryPolicyConfig.readAddress(".owner");
        address got = monetaryPolicy.owner();

        assertEq(want, got);
    }

    function test_monetaryPolicy_ampl() public view {
        address want = monetaryPolicyConfig.readAddress(".ampl");
        address got = monetaryPolicy.uFrags();

        assertEq(want, got);
    }

    function test_monetaryPolicy_cpiOracle() public view {
        address want = monetaryPolicyConfig.readAddress(".cpiOracle");
        address got = monetaryPolicy.cpiOracle();

        assertEq(want, got);
    }

    function test_monetaryPolicy_marketOracle() public view {
        address want = monetaryPolicyConfig.readAddress(".marketOracle");
        address got = monetaryPolicy.marketOracle();

        assertEq(want, got);
    }

    function test_monetaryPolicy_orchestrator() public view {
        address want = monetaryPolicyConfig.readAddress(".orchestrator");
        address got = monetaryPolicy.orchestrator();

        assertEq(want, got);
    }

    function test_monetaryPolicy_deviationThreshold() public view {
        uint want = monetaryPolicyConfig.readUint(".deviationThreshold");
        uint got = monetaryPolicy.deviationThreshold();

        assertEq(want, got);
    }

    function test_monetaryPolicy_rebaseLag() public view {
        uint want = monetaryPolicyConfig.readUint(".rebaseLag");
        uint got = monetaryPolicy.rebaseLag();

        assertEq(want, got);
    }

    function test_monetaryPolicy_minRebaseTimeIntervalSec() public view {
        uint want = monetaryPolicyConfig.readUint(".minRebaseTimeIntervalSec");
        uint got = monetaryPolicy.minRebaseTimeIntervalSec();

        assertEq(want, got);
    }

    function test_monetaryPolicy_rebaseWindowOffsetSec() public view {
        uint want = monetaryPolicyConfig.readUint(".rebaseWindowOffsetSec");
        uint got = monetaryPolicy.rebaseWindowOffsetSec();

        assertEq(want, got);
    }

    function test_monetaryPolicy_rebaseWindowLengthSec() public view {
        uint want = monetaryPolicyConfig.readUint(".rebaseWindowLengthSec");
        uint got = monetaryPolicy.rebaseWindowLengthSec();

        assertEq(want, got);
    }

    // -- CPI Oracle --

    function test_cpiOracle_ownable() public view {
        address want = cpiOracleConfig.readAddress(".owner");
        address got = cpiOracle.owner();

        assertEq(want, got);
    }

    function test_cpiOracle_minimumProviders() public view {
        uint want = cpiOracleConfig.readUint(".minimumProviders");
        uint got = cpiOracle.minimumProviders();

        assertEq(want, got);
    }

    function test_cpiOracle_providers() public view {
        address[] memory providers =
            cpiOracleConfig.readAddressArray(".providers");

        // Verify providers size.
        assertEq(providers.length, cpiOracle.providersSize());

        // Verify each provider.
        for (uint i; i < providers.length; i++) {
            address got = cpiOracle.providers(i);
            assertEq(providers[i], got);
        }
    }

    function test_cpiOracle_reportExpirationTimeSec() public view {
        uint want = cpiOracleConfig.readUint(".reportExpirationTimeSec");
        uint got = cpiOracle.reportExpirationTimeSec();

        assertEq(want, got);
    }

    function test_cpiOracle_reportDelaySec() public view {
        uint want = cpiOracleConfig.readUint(".reportDelaySec");
        uint got = cpiOracle.reportDelaySec();

        assertEq(want, got);
    }

    function test_cpiOracle_scalar() public view {
        uint want = cpiOracleConfig.readUint(".scalar");
        uint got = cpiOracle.scalar();

        assertEq(want, got);
    }

    // -- Market Oracle --

    function test_marketOracle_ownable() public view {
        address want = marketOracleConfig.readAddress(".owner");
        address got = marketOracle.owner();

        assertEq(want, got);
    }

    function test_marketOracle_minimumProviders() public view {
        uint want = marketOracleConfig.readUint(".minimumProviders");
        uint got = marketOracle.minimumProviders();

        assertEq(want, got);
    }

    function test_marketOracle_providers() public view {
        address[] memory providers =
            marketOracleConfig.readAddressArray(".providers");

        // Verify providers size.
        assertEq(providers.length, marketOracle.providersSize());

        // Verify each provider.
        for (uint i; i < providers.length; i++) {
            address got = marketOracle.providers(i);
            assertEq(providers[i], got);
        }
    }

    function test_marketOracle_reportExpirationTimeSec() public view {
        uint want = marketOracleConfig.readUint(".reportExpirationTimeSec");
        uint got = marketOracle.reportExpirationTimeSec();

        assertEq(want, got);
    }

    function test_marketOracle_reportDelaySec() public view {
        uint want = marketOracleConfig.readUint(".reportDelaySec");
        uint got = marketOracle.reportDelaySec();

        assertEq(want, got);
    }

    // -- Orchestrator --

    function test_orchestrator_ownable() public view {
        address want = orchestratorConfig.readAddress(".owner");
        address got = orchestrator.owner();

        assertEq(want, got);
    }

    function test_orchestrator_monetaryPolicy() public view {
        address want = orchestratorConfig.readAddress(".monetaryPolicy");
        address got = orchestrator.policy();

        assertEq(want, got);
    }

    function test_orchestrator_transactions() public view {
        bytes[] memory want = orchestratorConfig.readBytesArray(".transactions");

        uint size = orchestrator.transactionsSize();
        assertEq(want.length, size);

        for (uint i; i < size; i++) {
            bool enabled;
            address target;
            bytes memory payload;
            (enabled, target, payload) = orchestrator.transactions(i);

            bytes memory got = abi.encodePacked(enabled, target, payload);

            assertEq(want[i], got);
        }
    }
}
