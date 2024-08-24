// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {BondController} from "src/spot/BondController.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract SPOTInvariantcheck is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    // Tranche ratios always sum up to 10k.

    /// @dev Every bond is collateralized by AMPL.
    function test_bondIssuer_EveryBondIsCollateralizedViaAMPL() public {
        // Note to only test active bonds.
        uint count = bondIssuer.activeCount();
        for (uint i; i < count; i++) {
            BondController bond = BondController(bondIssuer.activeBondAt(i));
            assertEq(bond.collateralToken(), address(ampl));
        }
    }
}
