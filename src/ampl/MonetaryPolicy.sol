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
        uint indexed epoch,
        uint exchangeRate,
        uint cpi,
        int requestedSupplyAdjustment,
        uint timestampSec
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
    function deviationThreshold() external view returns (uint);
    function rebaseLag() external view returns (uint);
    function minRebaseTimeIntervalSec() external view returns (uint);
    function lastRebaseTimestampSec() external view returns (uint);
    function rebaseWindowOffsetSec() external view returns (uint);
    function rebaseWindowLengthSec() external view returns (uint);

    // State
    function epoch() external view returns (uint);
    function globalAmpleforthEpochAndAMPLSupply()
        external
        view
        returns (uint, uint);
    function inRebaseWindow() external view returns (bool);
    function withinDeviationThreshold(uint rate, uint targetRate)
        external
        view;

    // -- onlyOrchestrator Functions --
    function rebase() external;

    // -- onlyOwner Functions --
    function setCpiOracle(address cpiOracle_) external;
    function setMarketOracle(address marketOracle_) external;
    function setOrchestrator(address orchestrator_) external;
    function setDeviationThreshold(uint deviationThreshold_) external;
    function setRebaseLag(uint rebaseLag_) external;
    function setRebaseTimingParameters(
        uint minRebaseTimeIntervalSec_,
        uint rebaseWindowOffsetSec_,
        uint rebaseWindowLengthSec_
    ) external;
}
