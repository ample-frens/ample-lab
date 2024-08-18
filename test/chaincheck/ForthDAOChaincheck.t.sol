// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract ForthDAOChaincheck is StatefulTest {
    using stdJson for string;

    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    // -- FORTH --

    function test_forth_minter() public view {
        address want = forthConfig.readAddress(".minter");
        address got = forth.minter();

        assertEq(want, got);
    }

    // -- Timelock --

    function test_timelock_admin() public view {
        address want = timelockConfig.readAddress(".admin");
        address got = timelock.admin();

        assertEq(want, got);
    }

    function test_timelock_pendingAdmin() public view {
        address want = timelockConfig.readAddress(".pendingAdmin");
        address got = timelock.pendingAdmin();

        assertEq(want, got);
    }

    function test_timelock_delay() public view {
        uint want = timelockConfig.readUint(".delay");
        uint got = timelock.delay();

        assertEq(want, got);
    }

    // -- Governor --

    function test_governor_admin() public view {
        address want = governorConfig.readAddress(".admin");
        address got = governor.admin();

        assertEq(want, got);
    }

    function test_governor_pendingAdmin() public view {
        address want = governorConfig.readAddress(".pendingAdmin");
        address got = governor.pendingAdmin();

        assertEq(want, got);
    }

    function test_governor_implementation() public view {
        address want = governorConfig.readAddress(".implementation");
        address got = governor.implementation();

        assertEq(want, got);
    }

    function test_governor_timelock() public view {
        address want = governorConfig.readAddress(".timelock");
        address got = governor.timelock();

        assertEq(want, got);
    }

    function test_governor_forth() public view {
        address want = governorConfig.readAddress(".forth");
        address got = governor.forth();

        assertEq(want, got);
    }

    function test_governor_proposalThreshold() public view {
        uint want = governorConfig.readUint(".proposalThreshold");
        uint got = governor.proposalThreshold();

        assertEq(want, got);
    }

    function test_governor_quorumVotes() public view {
        uint want = governorConfig.readUint(".quorumVotes");
        uint got = governor.quorumVotes();

        assertEq(want, got);
    }

    function test_governor_votingDelay() public view {
        uint want = governorConfig.readUint(".votingDelay");
        uint got = governor.votingDelay();

        assertEq(want, got);
    }

    function test_governor_votingPeriod() public view {
        uint want = governorConfig.readUint(".votingPeriod");
        uint got = governor.votingPeriod();

        assertEq(want, got);
    }

    function test_governor_proposalMaxOperations() public view {
        uint want = governorConfig.readUint(".proposalMaxOperations");
        uint got = governor.proposalMaxOperations();

        assertEq(want, got);
    }
}
