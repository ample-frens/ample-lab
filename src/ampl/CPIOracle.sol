// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {IERC20} from "forge-std/interfaces/IERC20.sol";

import {Database} from "../std/Database.sol";

struct CPIOracle {
    string config;
}

library LibCPIOracle {
    function create() internal view returns (CPIOracle memory) {
        string memory config = Database.read("./db/ampl/CPIOracle.json");

        return CPIOracle(config);
    }
}
