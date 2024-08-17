// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {IERC20 as ERC20} from "forge-std/interfaces/IERC20.sol";

import {Ownable} from "../common/Ownable.sol";

/**
 * @notice The FORTH ERC-20 token governing Ampleforth
 */
interface FORTH is ERC20 {
    // -- View Functions --
    function minter() external view returns (address);
    function minimumTimeBetweenMints() external view returns (uint);
    function mintCap() external view returns (uint);
}
