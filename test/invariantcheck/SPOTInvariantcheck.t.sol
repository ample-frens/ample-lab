// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {BondController} from "src/spot/BondController.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract SPOTInvariantcheck is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    /// @dev SPOT's underlying token is AMPL.
    function test_spot_underlyingIsAMPL() public view {
        assertEq(spot.underlying(), address(ampl));
    }

    function test_spot_reserveAtZeroIsAMPL() public {
        assertEq(spot.getReserveAt(0), address(ampl));
    }

    /// @dev SPOT's deposit bond is collateralized via AMPL.
    function test_spot_depositBondCollateralIsAMPL() public {
        BondController depositBond = BondController(spot.getDepositBond());

        assertEq(depositBond.collateralToken(), address(ampl));
    }

    /// @dev SPOT's deposit tranche is senior.
    function test_spot_depositTrancheIsSenior() public {
        // A bond's senior tranche is at index 0.
        address want;
        (want, /*ratio*/) = BondController(spot.getDepositBond()).tranches(0);

        address got = spot.getDepositTranche();

        assertEq(want, got);
    }

    // Tranche ratios always sum up to 1k.

    /// @dev Every bond is collateralized by AMPL.
    function test_bondIssuer_EveryBondIsCollateralizedViaAMPL() public view {
        // Note to only test active bonds.
        uint count = bondIssuer.activeCount();
        for (uint i; i < count; i++) {
            BondController bond = BondController(bondIssuer.activeBondAt(i));
            assertEq(bond.collateralToken(), address(ampl));
        }
    }
}
