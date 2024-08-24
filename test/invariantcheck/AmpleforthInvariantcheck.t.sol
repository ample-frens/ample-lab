// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {console2 as console} from "forge-std/console2.sol";

// Ampleforth
import {CPIOracle} from "src/ampl/CPIOracle.sol";
import {MarketOracle} from "src/ampl/MarketOracle.sol";
import {Orchestrator} from "src/ampl/Orchestrator.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract AmpleforthInvariantcheck is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }
}
