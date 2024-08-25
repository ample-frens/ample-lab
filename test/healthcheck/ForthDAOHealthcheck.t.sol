// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {StatefulTest} from "../StatefulTest.sol";

contract ForthDAOHealthcheck is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    /// @dev The ForthDAO timelock owns every protocol contract.
    function test_timelock_OwnsEveryContract() public view {
        // Ampleforth
        assertEq(ampl.owner(), address(timelock));
        assertEq(cpiOracle.owner(), address(timelock));
        assertEq(marketOracle.owner(), address(timelock));
        assertEq(monetaryPolicy.owner(), address(timelock));
        assertEq(orchestrator.owner(), address(timelock));

        // Forth
        assertEq(forth.minter(), address(timelock));
        assertEq(governor.admin(), address(timelock));

        // SPOT
        assertEq(spot.owner(), address(timelock));
        assertEq(bondIssuer.owner(), address(timelock));
    }

    /// @dev Test whether the ForthDAO can purge invalid CPI reports before they
    ///      are becoming valid, ie their delay passed.
    function test_daoVote_CanPurgeCPIReportsBeforeBecomingValid() public view {
        // Get DAO vote min length.
        // Note that time is in blocks.
        uint votingDelay = governor.votingDelay();
        uint votingPeriod = governor.votingPeriod();

        // Let minimum vote delay be 12 seconds per block and a 1 week buffer
        // for social coordination.
        uint minVoteDelay = (votingDelay + votingPeriod) * 12 seconds + 1 weeks;

        // Get CPI oracle delay.
        uint cpiDelay = cpiOracle.reportDelaySec();

        assertTrue(minVoteDelay < cpiDelay);
    }
}
