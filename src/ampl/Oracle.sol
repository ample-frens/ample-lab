// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {Ownable} from "../common/Ownable.sol";

/**
 * @notice Generic oracle used for Ampleforth's CPI and market oracle
 *
 * @dev An oracle derives its value via medianizing the newest valid report from
 *      each provider, if any.
 */
interface Oracle is Ownable {
    struct Report {
        uint timestamp;
        uint payload;
    }

    event ProviderAdded(address provider);
    event ProviderRemoved(address provider);
    event ReportTimestampOutOfRange(address provider);
    event ProviderReportPushed(
        address indexed provider, uint payload, uint timestamp
    );

    // -- View Functions --
    function providerReports(address provider_)
        external
        view
        returns (Report[2] memory);

    function minimumProviders() external view returns (uint);
    function providers(uint index) external view returns (address);
    function providersSize() external view returns (uint);

    function reportExpirationTimeSec() external view returns (uint);
    function reportDelaySec() external view returns (uint);

    // -- Read Function --
    function getData() external returns (uint, bool);

    // -- onlyProvider --
    function pushReport(uint payload) external;
    function purgeReports() external;

    // -- onlyOwner Functions --
    function addProvider(address provider_) external;
    function removeProvider(address provider_) external;
}

/**
 * @title CPIOracle
 *
 * @notice The CPI oracle is an Oracle with the addition of `scalar()(uint)`
 */
interface CPIOracle is Oracle {
    function scalar() external view returns (uint);
}
