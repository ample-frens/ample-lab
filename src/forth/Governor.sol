// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

struct Proposal {
    Operation[] operations;
}

struct Operation {
    address target;
    bytes payload;
    uint value;
}

/**
 * @notice
 */
interface Governor {
    function admin() external view returns (address);
    function pendingAdmin() external view returns (address);

    function implementation() external view returns (address);
    function timelock() external view returns (address);
    function forth() external view returns (address);

    function proposalThreshold() external view returns (uint);
    function quorumVotes() external view returns (uint);

    function votingDelay() external view returns (uint);
    function votingPeriod() external view returns (uint);

    function proposalMaxOperations() external view returns (uint);
}
