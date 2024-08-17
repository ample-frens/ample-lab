// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {IOwnable} from "../interfaces/IOwnable.sol";

/**
 * @notice The monetary policy governing AMPLs supply adjustments
 */
interface IMonetaryPolicy is IOwnable {
    event LogRebase(
        uint256 indexed epoch, uint256 exchangeRate, uint256 cpi, int256 requestedSupplyAdjustment, uint256 timestampSec
    );

    // -- View Functions --

    // AMPL
    function uFrags() external view returns (address);

    // Oracles
    function cpiOracle() external view returns (address);
    function marketOracle() external view returns (address);

    // Orchestrator
    function orchestrator() external view returns (address);

    // Rebase parameters
    function deviationThreshold() external view returns (uint256);
    function rebaseLag() external view returns (uint256);
    function minRebaseTimeIntervalSec() external view returns (uint256);
    function lastRebaseTimestampSec() external view returns (uint256);
    function rebaseWindowOffsetSec() external view returns (uint256);
    function rebaseWindowLengthSec() external view returns (uint256);

    // State
    function epoch() external view returns (uint256);
    function globalAmpleforthEpochAndAMPLSupply() external view returns (uint256, uint256);
    function inRebaseWindow() external view returns (bool);
    function withinDeviationThreshold(uint256 rate, uint256 targetRate) external view;

    // -- onlyOrchestrator Functions --
    function rebase() external;

    // -- onlyOwner Functions --
    function setCpiOracle(address cpiOracle_) external;
    function setMarketOracle(address marketOracle_) external;
    function setOrchestrator(address orchestrator_) external;
    function setDeviationThreshold(uint256 deviationThreshold_) external;
    function setRebaseLag(uint256 rebaseLag_) external;
    function setRebaseTimingParameters(
        uint256 minRebaseTimeIntervalSec_,
        uint256 rebaseWindowOffsetSec_,
        uint256 rebaseWindowLengthSec_
    ) external;
}
