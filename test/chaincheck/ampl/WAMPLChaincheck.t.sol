// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Database} from "src/std/Database.sol";

import {WAMPL} from "src/ampl/WAMPL.sol";

contract WAMPLChaincheck is Test {
    using stdJson for string;

    WAMPL wampl;
    string config;

    function setUp() public {
        // Create mainnet fork from $RPC_URL.
        vm.createSelectFork(vm.envString("RPC_URL"));

        // Read config from database and instantiate contract.
        config = Database.read("./db/ampl/WAMPL.json");
        wampl = WAMPL(config.readAddress(".address"));
    }

    function testChaincheck_underlying() public view {
        address want = config.readAddress(".underlying");
        address got = wampl.underlying();

        assertEq(want, got);
    }
}
