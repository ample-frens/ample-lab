// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";
import {ProxyLib} from "../ProxyLib.sol";

// Tests every contract that is behind a proxy.
contract ProxiesChaincheck is StatefulTest {
    using stdJson for string;

    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    function test_ampl_AMPL() public {
        address admin = amplConfig.readAddress(".proxy.admin");
        address impl = amplConfig.readAddress(".proxy.implementation");

        assertTrue(ProxyLib.verify(address(ampl), admin, impl));
    }
}
