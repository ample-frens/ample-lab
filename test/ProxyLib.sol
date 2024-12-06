// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Vm} from "forge-std/Vm.sol";

import {Proxy} from "src/common/Proxy.sol";

library ProxyLib {
    Vm private constant vm =
        Vm(address(uint160(uint(keccak256("hevm cheat code")))));

    // -- Constants --

    // TODO: Link to OZ version.
    bytes32 constant SLOT_ADMIN =
        hex"10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b";
    bytes32 constant SLOT_IMPL =
        hex"7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3";

    function verify(address who, address admin, address impl)
        internal
        returns (bool)
    {
        return _verify_admin(who, admin)
            && _verify_implementation(who, admin, impl)
            && _verify_upgradeability(who, admin);
    }

    function _verify_admin(address who, address admin) private returns (bool) {
        // Via reading slot.
        bool ok1 = admin == address(uint160(uint(vm.load(who, SLOT_ADMIN))));

        // Via reading onlyAdmin admin() function.
        vm.prank(admin);
        bool ok2 = admin == Proxy(who).admin();

        return ok1 && ok2;
    }

    function _verify_implementation(address who, address admin, address impl)
        private
        returns (bool)
    {
        // Via reading slot.
        bool ok1 = impl == address(uint160(uint(vm.load(who, SLOT_IMPL))));

        // Via reading onlyAdmin implementation() function.
        vm.prank(admin);
        bool ok2 = impl == Proxy(who).implementation();

        return ok1 && ok2;
    }

    function _verify_upgradeability(address who, address admin)
        private
        returns (bool)
    {
        address multicall3 = 0xcA11bde05977b3631167028862bE2a173976CA11;

        vm.startPrank(admin);
        Proxy(who).upgradeTo(multicall3);
        bool ok = multicall3 == Proxy(who).implementation();
        vm.stopPrank();

        return ok;
    }
}
