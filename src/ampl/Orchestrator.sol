// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Ownable} from "../common/Ownable.sol";

/**
 * @notice The Orchestrator rebase entrypoint
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
        returns (bool, address, bytes memory);
    function transactionsSize() external view returns (uint);

    // -- Mutating Functions --
    function rebase() external;

    // -- onlyOwner Functions --
    function addTransaction(address destination, bytes memory data) external;
    function removeTransaction(uint index) external;
    function setTransactionEnabled(uint index, bool enabled) external;
}
