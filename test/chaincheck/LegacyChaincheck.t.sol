// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";

import {Proxy} from "src/common/Proxy.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract LegacyChaincheck is StatefulTest {
    using stdJson for string;

    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    // -- ProxyAdmin --

    //// TODO:
    function test_proxyAdmin_ownable() public view {
        address want = proxyAdminConfig_AMPL.readAddress(".owner");
        address got = proxyAdmin_AMPL.owner();

        assertEq(want, got);
    }

    function test_proxyAdmin_ownable2() public view {
        address want = proxyAdminConfig_MonetaryPolicy.readAddress(".owner");
        address got = proxyAdmin_MonetaryPolicy.owner();

        assertEq(want, got);
    }

    // TODO: Prove that storage is empty.
    // Tested for now via $ cast storage $proxyAdmin
}
