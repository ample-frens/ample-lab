// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {IERC20 as ERC20} from "forge-std/interfaces/IERC20.sol";

import {Ownable} from "../common/Ownable.sol";

/**
 * @notice The fixed-supply WAMPL ERC-20 token
 */
interface WAMPL is ERC20 {
    function underlying() external view returns (address);
    function totalUnderlying() external view returns (uint);
    function balanceOfUnderlying(address owner) external view returns (uint);

    // -- Elastic Token View Functions --
    function scaledTotalSupply() external view returns (uint);
    function scaledBalanceOf(address who) external view returns (uint);
}
