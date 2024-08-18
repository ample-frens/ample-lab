// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {Database} from "src/std/Database.sol";

// Ampleforth
import {AMPL} from "src/ampl/AMPL.sol";
import {WAMPL} from "src/ampl/WAMPL.sol";
import {MonetaryPolicy} from "src/ampl/MonetaryPolicy.sol";
import {CPIOracle} from "src/ampl/CPIOracle.sol";
import {MarketOracle} from "src/ampl/MarketOracle.sol";
import {Orchestrator} from "src/ampl/Orchestrator.sol";

// Forth DAO
import {FORTH} from "src/forth/FORTH.sol";
import {Timelock} from "src/forth/Timelock.sol";

contract StatefulTest is Test {
    using stdJson for string;

    // forgefmt: disable-start

    // -- Contracts

    // Ampleforth
    AMPL           ampl;
    WAMPL          wampl;
    MonetaryPolicy monetaryPolicy;
    CPIOracle      cpiOracle;
    MarketOracle   marketOracle;
    Orchestrator   orchestrator;

    // Forth DAO
    FORTH    forth;
    Timelock timelock;

    // -- Configs

    // Ampleforth
    string amplConfig;
    string wamplConfig;
    string monetaryPolicyConfig;
    string cpiOracleConfig;
    string marketOracleConfig;
    string orchestratorConfig;

    // Forth DAO
    string forthConfig;
    string timelockConfig;

    function setUp() public virtual {
        // Create mainnet fork from $RPC_URL.
        vm.createSelectFork(vm.envString("RPC_URL"));

        _setUpAmpleforth();
        _setUpForthDAO();
    }

    function _setUpAmpleforth() private {
        amplConfig           = Database.read("./db/ampl/AMPL.json");
        ampl                 = AMPL(amplConfig.readAddress(".address"));
        wamplConfig          = Database.read("./db/ampl/WAMPL.json");
        wampl                = WAMPL(wamplConfig.readAddress(".address"));
        monetaryPolicyConfig = Database.read("./db/ampl/MonetaryPolicy.json");
        monetaryPolicy       = MonetaryPolicy(monetaryPolicyConfig.readAddress(".address"));
        cpiOracleConfig      = Database.read("./db/ampl/CPIOracle.json");
        cpiOracle            = CPIOracle(cpiOracleConfig.readAddress(".address"));
        marketOracleConfig   = Database.read("./db/ampl/MarketOracle.json");
        marketOracle         = MarketOracle(marketOracleConfig.readAddress(".address"));
        orchestratorConfig   = Database.read("./db/ampl/Orchestrator.json");
        orchestrator         = Orchestrator(orchestratorConfig.readAddress(".address"));

        vm.label(address(ampl),           "AMPL");
        vm.label(address(wampl),          "WAMPL");
        vm.label(address(monetaryPolicy), "MonetaryPolicy");
        vm.label(address(cpiOracle),      "CPIOracle");
        vm.label(address(marketOracle),   "MarketOracle");
        vm.label(address(orchestrator),   "Orchestrator");
    }

    function _setUpForthDAO() private {
        forthConfig    = Database.read("./db/forth/FORTH.json");
        forth          = FORTH(forthConfig.readAddress(".address"));
        timelockConfig = Database.read("./db/forth/Timelock.json");
        timelock       = Timelock(timelockConfig.readAddress(".address"));

        vm.label(address(forth),    "FORTH");
        vm.label(address(timelock), "Timelock");
    }

    // forgefmt: disable-end
}
