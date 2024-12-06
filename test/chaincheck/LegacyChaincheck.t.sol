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

    function test_proxyAdmin_ownable() public view {
        address want = proxyAdminConfig.readAddress(".owner");
        address got = proxyAdmin.owner();

        assertEq(want, got);
    }

    // TODO: Prove that storage is empty.
    // Tested for now via $ cast storage $proxyAdmin
}
