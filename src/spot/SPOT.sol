// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {IERC20 as ERC20} from "forge-std/interfaces/IERC20.sol";

import {Ownable} from "../common/Ownable.sol";

interface SPOT is ERC20, Ownable {
    // -- Constant
    function underlying() external view returns (address);

    // -- Configuration
    function bondIssuer() external view returns (address);
    function keeper() external view returns (address);
    function vault() external view returns (address);
    function feePolicy() external view returns (address);

    function minTrancheMaturitySec() external view returns (uint);
    function maxTrancheMaturitySec() external view returns (uint);
    function maxSupply() external view returns (uint);
    function maxDepositTrancheValuePerc() external view returns (uint);

    // -- afterStateUpdate --
    // -- Reserve
    function getReserveCount() external returns (uint);
    function getReserveAt(uint index) external returns (address);
    // -- Deposit Bond
    function getDepositBond() external returns (address);
    function getDepositTranche() external returns (address);
    function getDepositTrancheRatio() external returns (uint);

    // -- onlyKeeper
    // TODO: Keeper is a 2/4 safe multisig.
    function pause() external;
    function unpause() external;
    function updateMaxSupply(uint maxSupply_) external;
    function updateMaxDepositTrancheValuePerc(uint maxDepositTrancheValuePerc_)
        external;

    // -- onlyOwner
    function updateVault(address vault_) external;
    function updateKeeper(address keeper_) external;
    function updateBondIssuer(address bondIssuer_) external;
    function updateFeePolicy(address feePolicy_) external;
    function updateTolerableTrancheMaturity(
        uint minTrancheMaturitySec_,
        uint maxTrancheMaturitySec_
    ) external;
    function transferERC20(address token, address to, uint amount) external;
}
