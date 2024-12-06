// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {console2 as console} from "forge-std/console2.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {Proxy} from "src/common/Proxy.sol";

import {StatefulTest} from "../StatefulTest.sol";

// Tests every contract that is behind a proxy.
contract ProxiesChaincheck is StatefulTest {
    using stdJson for string;

    bytes32 constant SLOT_ADMIN =
        hex"10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b";
    bytes32 constant SLOT_IMPL =
        hex"7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3";

    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    function _testProxy(address proxy, address admin, address impl) private {
        // Verify admin:
        // - via storage slot
        assertEq(admin, address(uint160(uint(vm.load(proxy, SLOT_ADMIN)))));
        // - via admin() function
        vm.prank(admin);
        assertEq(admin, Proxy(proxy).admin());

        // Verify implementation:
        // - via storage slot
        assertEq(impl, address(uint160(uint(vm.load(proxy, SLOT_IMPL)))));
        // - via implementation() function
        vm.prank(admin);
        assertEq(impl, Proxy(proxy).implementation());

        // Verify upgradeability:
        address multicall3 = 0xcA11bde05977b3631167028862bE2a173976CA11;
        vm.startPrank(admin);
        Proxy(proxy).upgradeTo(multicall3);
        assertEq(multicall3, Proxy(proxy).implementation());
        vm.stopPrank();
    }

    // -- Ampleforth --

    function test_AMPL() public {
        address admin = amplConfig.readAddress(".proxy.admin.address");
        address impl = amplConfig.readAddress(".proxy.implementation");

        _testProxy(address(ampl), admin, impl);
    }

    function test_MonetaryPolicy() public {
        address admin = monetaryPolicyConfig.readAddress(".proxy.admin.address");
        address impl = monetaryPolicyConfig.readAddress(".proxy.implementation");

        _testProxy(address(monetaryPolicy), admin, impl);
    }
}
