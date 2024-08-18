// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {StatefulTest} from "../StatefulTest.sol";

contract ForthDAOInvariants is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    /// @custom:invariant [1] The Timelock owns every contract except itself
    function testInvariant_TimelockOwnsEveryContract() public view {
        // Ampleforth
        assertEq(ampl.owner(), address(timelock));
        assertEq(cpiOracle.owner(), address(timelock));
        assertEq(marketOracle.owner(), address(timelock));
        assertEq(monetaryPolicy.owner(), address(timelock));
        assertEq(orchestrator.owner(), address(timelock));

        // Forth
        // Note that FORTH only provides a minter role.
        assertEq(forth.minter(), address(timelock));
        assertEq(governor.admin(), address(timelock));
    }

    /// @custom:invariant [2] A DAO vote can be initiated and executed before a CPI
    ///                       report's activation delay passed
    function testInvariant_DAOVoteCanPurgeCPIReports() public {
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
