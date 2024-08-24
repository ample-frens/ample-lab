// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {StatefulTest} from "../StatefulTest.sol";

contract SPOTHealthcheck is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    // TODO: Not sure whether this actually true.
    function test_bondIssuer_HasAtLeastThreeActiveBonds() public {
        assertTrue(bondIssuer.activeCount() > 3);
    }
}

