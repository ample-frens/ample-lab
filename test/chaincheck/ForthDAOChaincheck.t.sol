// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract ForthDAOChaincheck is StatefulTest {
    using stdJson for string;

    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    function test_forth_minter() public view {
        address want = forthConfig.readAddress(".minter");
        address got = forth.minter();

        assertEq(want, got);
    }

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
}