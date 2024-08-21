// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {StatefulTest} from "../StatefulTest.sol";

contract SPOTInvariants is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    // TODO: Not sure whether this actually true.
    function test_BondIssuerHasAtLeastThreeActiveBonds() public {
        assertTrue(bondIssuer.activeCount() > 3);
    }

    // Every Bond is collateralized via AMPL.
    //function test_EveryBondIsCollateralizedViaAMPL() public {
    //    // Note to only test active bonds.
    //    uint count = bondIssuer.activeCount();
    //    for (uint i; i < count; i++) {
    //        // TODO: Need BondController.
    //        BondController bond = bondIssuer.activeBondAt(i);
    //        assertEq(bond.collateralToken(), address(ampl));
    //    }
    //}
}
