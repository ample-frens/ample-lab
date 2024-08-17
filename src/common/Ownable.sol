// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/**
 * @notice The Ownable contract from OpenZeppelin used throughout the Ampleforth
 *         ecosystem
 */
interface Ownable {
    function owner() external view returns (address);
    function isOwner() external view returns (bool);

    // -- onlyOwner Functions --
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
}
