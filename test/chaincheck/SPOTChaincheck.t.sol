// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract SPOTChaincheck is StatefulTest {
    using stdJson for string;

    function setUp() public override(StatefulTest) {
        super.setUp();
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
        // However, it is enforces that the sum of ratios must be 1000.
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
}
