// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {console2 as console} from "forge-std/console2.sol";

library Database {
    Vm private constant vm =
        Vm(address(uint160(uint(keccak256("hevm cheat code")))));

    function read(string memory path) internal view returns (string memory) {
        try vm.readFile(path) returns (string memory json) {
            return json;
        } catch {
            revert(
                string.concat("Json::read: could not read json: path=", path)
            );
        }
    }
}
