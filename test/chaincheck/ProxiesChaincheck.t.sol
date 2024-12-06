// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {console2 as console} from "forge-std/console2.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";
import {ProxyLib} from "../ProxyLib.sol";

// Tests every contract that is behind a proxy.
contract ProxiesChaincheck is StatefulTest {
    using stdJson for string;

    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    // -- Ampleforth --

    function test_AMPL() public {
        address admin = amplConfig.readAddress(".proxy.admin");
        address impl = amplConfig.readAddress(".proxy.implementation");

        assertTrue(ProxyLib.verify(address(ampl), admin, impl));
    }

    function test_MonetaryPolicy() public {
        address admin = monetaryPolicyConfig.readAddress(".proxy.admin");
        address impl = monetaryPolicyConfig.readAddress(".proxy.implementation");

        assertTrue(ProxyLib.verify(address(monetaryPolicy), admin, impl));
    }
}
