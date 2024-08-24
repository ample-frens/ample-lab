// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Ownable} from "../common/Ownable.sol";

interface BondIssuer is Ownable {
    // -- State Variables --
    function bondFactory() external view returns (address);
    function collateral() external view returns (address);
    function maxMaturityDuration() external view returns (uint);
    function trancheRatios(uint index) external view returns (uint);
    function minIssueTimeIntervalSec() external view returns (uint);
    function issueWindowOffsetSec() external view returns (uint);
    function lastIssueWindowTimestamp() external view returns (uint);

    // -- View Functions --
    function isInstance(address bond) external view returns (bool);
    function issuedCount() external view returns (uint);
    function issuedBondAt(uint index) external view returns (address);
    function activeCount() external view returns (uint);
    function activeBondAt(uint index) external view returns (address);

    // -- Mutating Functions --
    function getLatestBond() external returns (address);
    function matureActive() external;
    function issue() external;

    // -- onlyOwner --
    function updateMaxMaturityDuration(uint maxMaturityDuration_) external;
    function updateTrancheRatios(uint[] memory trancheRatios_) external;
    function updateIssuanceTimingConfig(
        uint minIssueTimeIntervalSec_,
        uint issueWindowOffsetSec_
    ) external;
}
