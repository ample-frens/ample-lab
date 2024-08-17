// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {IERC20} from "forge-std/interfaces/IERC20.sol";

import {IOwnable} from "../interfaces/IOwnable.sol";

/**
 * @notice Ampleforth's Market oracle
 *
 * @dev An oracle derives its value via medianizing the newest valid report from
 *      each provider, if any.
 */
interface IMarketOracle is IOwnable {
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
