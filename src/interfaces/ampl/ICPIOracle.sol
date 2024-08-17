// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {IOwnable} from "../IOwnable.sol";

/**
 * @notice Ampleforth's CPI oracle
 *
 * @dev An oracle derives its value via medianizing the newest valid report from
 *      each provider, if any.
 */
interface ICPIOracle is IOwnable {
    struct Report {
        uint256 timestamp;
        uint256 payload;
    }

    event ProviderAdded(address provider);
    event ProviderRemoved(address provider);
    event ReportTimestampOutOfRange(address provider);
    event ProviderReportPushed(address indexed provider, uint256 payload, uint256 timestamp);

    // -- View Functions --
    function providerReports(address provider_) external view returns (Report[2] memory);

    function minimumProviders() external view returns (uint256);
    function providers(uint256 index) external view returns (address);
    function providersSize() external view returns (uint256);

    function reportExpirationTimeSec() external view returns (uint256);
    function reportDelaySec() external view returns (uint256);

    function scalar() external view returns (uint256);

    // -- Read Function --
    function getData() external returns (uint256, bool);

    // -- onlyProvider --
    function pushReport(uint256 payload) external;
    function purgeReports() external;

    // -- onlyOwner Functions --
    function addProvider(address provider_) external;
    function removeProvider(address provider_) external;
}
