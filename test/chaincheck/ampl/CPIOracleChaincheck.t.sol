// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console2 as console} from "forge-std/console2.sol";

import {Database} from "src/std/Database.sol";

import {CPIOracle} from "src/ampl/CPIOracle.sol";

contract CPIOracleChaincheck is Test {
    using stdJson for string;

    CPIOracle oracle;
    string config;

    function setUp() public {
        // Create mainnet fork from $RPC_URL.
        vm.createSelectFork(vm.envString("RPC_URL"));

        // Read config from database and instantiate oracle.
        config = Database.read("./db/ampl/CPIOracle.json");
        oracle = CPIOracle(config.readAddress(".address"));
    }

    function testChaincheck_ownable() public view {
        address want = config.readAddress(".owner");
        address got = oracle.owner();

        assertEq(want, got);
    }

    function testChaincheck_minimumProviders() public view {
        uint want = config.readUint(".minimumProviders");
        uint got = oracle.minimumProviders();

        assertEq(want, got);
    }

    function testChaincheck_providers() public view {
        address[] memory providers = config.readAddressArray(".providers");

        // Verify providers size.
        assertEq(providers.length, oracle.providersSize());

        // Verify each provider.
        for (uint i; i < providers.length; i++) {
            address got = oracle.providers(i);
            assertEq(providers[i], got);
        }
    }

    function testChaincheck_reportExpirationTimeSec() public view {
        uint want = config.readUint(".reportExpirationTimeSec");
        uint got = oracle.reportExpirationTimeSec();

        assertEq(want, got);
    }

    function testChaincheck_reportDelaySec() public view {
        uint want = config.readUint(".reportDelaySec");
        uint got = oracle.reportDelaySec();

        assertEq(want, got);
    }

    function testChaincheck_scalar() public view {
        uint want = config.readUint(".scalar");
        uint got = oracle.scalar();

        assertEq(want, got);
    }
}
