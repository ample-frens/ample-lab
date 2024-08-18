// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";

struct Proposal {
    Operation[] operations;
}

struct Operation {
    address target;
    bytes payload;
    uint value;
}

/**
 * @notice Tests proposal 30
 *
 * @custom:references
 *      - [Forum discussion](https://forum.ampleforth.org/t/proposal-to-increase-security-delay-for-pce-cpi-oracle-from-one-day-to-4-weeks/762)
 *      - [Tally vote](https://www.tally.xyz/gov/ampleforth/proposal/30)
 *
 */
contract Proposal_30_IncreaseCPIOracleSecurityDelayTest is StatefulTest {
    Operation[] operations;

    function setUp() public override(StatefulTest) {
        super.setUp();

        // 1: Update CPI oracle's security delay from 1 day to 4 weeks
        operations.push(
            Operation({
                target: address(cpiOracle),
                payload: abi.encodeWithSignature(
                    "setReportDelaySec(uint256)", uint(2419200)
                ),
                value: 0
            })
        );
    }

    function test_execution() public {
        for (uint i; i < operations.length; i++) {
            Operation memory op = operations[i];

            vm.prank(address(timelock));
            bool ok;
            bytes memory data;
            (ok, data) = payable(op.target).call{value: op.value}(op.payload);

            assertTrue(ok);
        }
    }
}
