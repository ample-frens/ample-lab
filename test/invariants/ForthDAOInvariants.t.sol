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
    }

    /// @custom:invariant [2] A DAO vote can be initiated and executed before a CPI
    ///                       report's activation delay passed
    function testInvariant_DAOVoteCanPurgeCPIReports() public {
        // TODO: ForthDAO: testInvariant_DAOVoteCanPurgeCPIReports
        vm.skip(true);

        // Get DAO vote min length.
        uint minVoteLength;

        // Get CPI oracle delay.
        uint cpiDelay = cpiOracle.reportDelaySec();

        assertTrue(minVoteLength < cpiDelay);
    }
}
