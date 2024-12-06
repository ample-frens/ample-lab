// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Ownable} from "./Ownable.sol";
import {Proxy} from "./Proxy.sol";

/**
 * @notice Commonly used ProxyAdmin contract
 */
interface ProxyAdmin is Ownable {
    function getProxyAdmin(Proxy proxy) external view returns (address);
    function changeProxyAdmin(Proxy proxy, address newAdmin) external;

    function getProxyImplementation(Proxy proxy)
        external
        view
        returns (address);
    function upgrade(Proxy proxy, address impl) external;
    function upgradeAndCall(Proxy proxy, address impl, bytes memory data)
        external
        payable;
}
