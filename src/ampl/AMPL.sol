// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {IERC20 as ERC20} from "forge-std/interfaces/IERC20.sol";

import {Ownable} from "../common/Ownable.sol";

/**
 * @notice The AMPL ERC-20 unit-of-account token
 */
interface AMPL is Ownable, ERC20 {
    event LogRebase(uint indexed epoch, uint totalSupply);
    event LogMonetaryPolicyUpdated(address monetaryPolicy);

    // -- View Functions --
    function monetaryPolicy() external view returns (address);

    // -- Elastic Token View Functions --
    function scaledTotalSupply() external view returns (uint);
    function scaledBalanceOf(address who) external view returns (uint);

    // -- onlyMonetaryPolicy --
    function rebase() external;
}
