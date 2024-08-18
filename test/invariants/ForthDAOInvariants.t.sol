// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {StatefulTest} from "../StatefulTest.sol";

contract ForthDAOInvariants is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    /// @custom:invariant The Timelock owns every contract
    function testInvariant_TimelockOwnsEveryContract() public {
        // Ampleforth
        assertEq(ampl.owner(), address(timelock));
        assertEq(cpiOracle.owner(), address(timelock));
        assertEq(marketOracle.owner(), address(timelock));
        assertEq(monetaryPolicy.owner(), address(timelock));
        assertEq(orchestrator.owner(), address(timelock));

        // Forth
        // Note that FORTH only provides a minter role.
        assertEq(forth.minter(), address(timelock));
    }

    /// @custom:invariant A DAO vote can be initiated and executed before a CPI
    ///                   report's activation delay passed
    function testInvariant_DAOVoteCanPurgeCPIReports() public {
        // Get DAO vote min length.
        uint minVoteLength = 1e18;

        // Get CPI oracle delay.
        uint cpiDelay = cpiOracle.reportDelaySec();

        assertTrue(minVoteLength < cpiDelay);
    }
}
