// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract SPOTChaincheck is StatefulTest {
    using stdJson for string;

    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    // -- SPOT --

    function test_spot_owner() public view {
        address want = spotConfig.readAddress(".owner");
        address got = spot.owner();

        assertEq(want, got);
    }

    function test_spot_underlying() public view {
        address want = spotConfig.readAddress(".underlying");
        address got = spot.underlying();

        assertEq(want, got);
    }

    function test_spot_bondIssuer() public view {
        address want = spotConfig.readAddress(".bondIssuer");
        address got = spot.bondIssuer();

        assertEq(want, got);
    }

    function test_spot_keeper() public view {
        address want = spotConfig.readAddress(".keeper");
        address got = spot.keeper();

        assertEq(want, got);
    }

    function test_spot_vault() public view {
        address want = spotConfig.readAddress(".vault");
        address got = spot.vault();

        assertEq(want, got);
    }

    function test_spot_feePolicy() public view {
        address want = spotConfig.readAddress(".feePolicy");
        address got = spot.feePolicy();

        assertEq(want, got);
    }

    function test_spot_minTrancheMaturitySec() public view {
        uint want = spotConfig.readUint(".minTrancheMaturitySec");
        uint got = spot.minTrancheMaturitySec();

        assertEq(want, got);
    }

    function test_spot_maxTrancheMaturitySec() public view {
        uint want = spotConfig.readUint(".maxTrancheMaturitySec");
        uint got = spot.maxTrancheMaturitySec();

        assertEq(want, got);
    }

    function test_spot_maxSupply() public view {
        uint want = spotConfig.readUint(".maxSupply");
        uint got = spot.maxSupply();

        assertEq(want, got);
    }

    function test_spot_maxDepositTrancheValuePerc() public view {
        uint want = spotConfig.readUint(".maxDepositTrancheValuePerc");
        uint got = spot.maxDepositTrancheValuePerc();

        assertEq(want, got);
    }

    // -- BondIssuer --

    function test_bondIssuer_owner() public view {
        address want = bondIssuerConfig.readAddress(".owner");
        address got = bondIssuer.owner();

        assertEq(want, got);
    }

    function test_bondIssuer_bondFactory() public view {
        address want = bondIssuerConfig.readAddress(".bondFactory");
        address got = bondIssuer.bondFactory();

        assertEq(want, got);
    }

    function test_bondIssuer_collateral() public view {
        address want = bondIssuerConfig.readAddress(".collateral");
        address got = bondIssuer.collateral();

        assertEq(want, got);
    }

    function test_bondIssuer_maxMaturityDuration() public view {
        uint want = bondIssuerConfig.readUint(".maxMaturityDuration");
        uint got = bondIssuer.maxMaturityDuration();

        assertEq(want, got);
    }

    function test_bondIssuer_trancheRatios() public view {
        uint[] memory trancheRatios =
            bondIssuerConfig.readUintArray(".trancheRatios");

        // Note that no trancheRatiosSize()(uint) function is provided.
        // However, it is enforced that the sum of ratios must be 1000.
        uint sum;
        for (uint i; i < trancheRatios.length; i++) {
            uint want = trancheRatios[i];
            uint got = bondIssuer.trancheRatios(i);

            assertEq(want, got);

            sum += want;
        }
        assertEq(sum, 1000);

        // Verify no more ratios exist.
        try bondIssuer.trancheRatios(trancheRatios.length) {
            assertTrue(false);
        } catch {
            // Want
        }
    }

    function test_bondIssuer_minIssueTimeIntervalSec() public view {
        uint want = bondIssuerConfig.readUint(".minIssueTimeIntervalSec");
        uint got = bondIssuer.minIssueTimeIntervalSec();

        assertEq(want, got);
    }

    function test_bondIssuer_issueWindowOffsetSec() public view {
        uint want = bondIssuerConfig.readUint(".issueWindowOffsetSec");
        uint got = bondIssuer.issueWindowOffsetSec();

        assertEq(want, got);
    }

    // -- BondFactory --

    function test_bondFactory_target() public view {
        address want = bondFactoryConfig.readAddress(".target");
        address got = bondFactory.target();

        assertEq(want, got);
    }

    function test_bondFactory_trancheFactory() public view {
        address want = bondFactoryConfig.readAddress(".trancheFactory");
        address got = bondFactory.trancheFactory();

        assertEq(want, got);
    }
}
