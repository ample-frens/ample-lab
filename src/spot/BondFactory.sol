// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

// From Buttonwood
interface BondFactory {
    // -- Immutable Configuration --
    function target() external view returns (address);
    function trancheFactory() external view returns (address);
}

