// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Database} from "src/std/Database.sol";

import {Timelock} from "src/forth/Timelock.sol";

contract TimelockChaincheck is Test {
    using stdJson for string;

    Timelock timelock;
    string config;

    function setUp() public {
        // Create mainnet fork from $RPC_URL.
        vm.createSelectFork(vm.envString("RPC_URL"));

        // Read config from database and instantiate contract.
        config = Database.read("./db/forth/Timelock.json");
        timelock = Timelock(config.readAddress(".address"));
    }

    function testChaincheck_admin() public view {
        address want = config.readAddress(".admin");
        address got = timelock.admin();

        assertEq(want, got);
    }

    function testChaincheck_pendingAdmin() public view {
        address want = config.readAddress(".pendingAdmin");
        address got = timelock.pendingAdmin();

        assertEq(want, got);
    }

    function testChaincheck_delay() public view {
        uint want = config.readUint(".delay");
        uint got = timelock.delay();

        assertEq(want, got);
    }
}
