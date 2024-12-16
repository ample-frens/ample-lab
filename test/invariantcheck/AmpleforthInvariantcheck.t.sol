// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

// Ampleforth
import {CPIOracle} from "src/ampl/CPIOracle.sol";
import {MarketOracle} from "src/ampl/MarketOracle.sol";
import {Orchestrator} from "src/ampl/Orchestrator.sol";

// Common
import {ProxyAdmin} from "src/common/ProxyAdmin.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract AmpleforthInvariantcheck is StatefulTest {
    using stdJson for string;

    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    /// @dev The AMPL token's proxy admin is address zero.
    function test_ampl_isNonUpgradeable() public view {
        ProxyAdmin proxyAdmin = ProxyAdmin(amplConfig.readAddress(".proxy.admin.address"));

        assertEq(proxyAdmin.owner(), address(0));
    }
}
