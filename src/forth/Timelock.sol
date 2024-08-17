// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

/**
 * @notice
 */
interface Timelock {
    // -- View Functions --
    function admin() external view returns (address);
    function pendingAdmin() external view returns (address);

    function delay() external view returns (uint);
    function GRACE_PERIOD() external view returns (uint);
    function MINIMUM_DELAY() external view returns (uint);
    function MAXIMUM_DELAY() external view returns (uint);
}
