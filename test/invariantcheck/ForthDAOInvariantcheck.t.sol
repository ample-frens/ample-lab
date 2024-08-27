// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {StatefulTest} from "../StatefulTest.sol";

contract ForthDAOInvariantcheck is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    function test_nop() public {}
}
