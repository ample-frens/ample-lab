// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

// TODO: docs, link to OZ version.
/**
 * @notice The Proxy contract
 */
interface Proxy {
    // All function are onlyAdmin.

    function admin() external view returns (address);
    function changeAdmin(address who) external;

    function implementation() external view returns (address);
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes calldata data)
        external
        payable;
}
