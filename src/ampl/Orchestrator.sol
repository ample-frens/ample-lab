// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {MonetaryPolicy} from "./MonetaryPolicy.sol";

import {Ownable} from "../common/Ownable.sol";

Vm constant vm = Vm(address(uint160(uint(keccak256("hevm cheat code")))));

/**
 * @notice The orchestrator rebase entrypoint
 *
 * @dev The orchestrator providers the public callable rebase() function
 *      the execute the monetary policy's supply adjustment.
 *
 *      This contract holds a set of transaction that are executed directly, ie
 *      atomically, after the rebase enabling the Forth DAO to coordinate the
 *      supply adjustment with external protocols.
 */
interface Orchestrator is Ownable {
    struct Transaction {
        bool enabled;
        address destination;
        bytes data;
    }

    // -- View Functions --
    function policy() external view returns (address);
    function transactions(uint index)
        external
        view
        returns (Transaction memory);
    function transactionsSize() external view returns (uint);

    // -- Mutating Functions --
    function rebase() external;

    // -- onlyOwner Functions --
    function addTransaction(address destination, bytes memory data) external;
    function removeTransaction(uint index) external;
    function setTransactionEnabled(uint index, bool enabled) external;
}
