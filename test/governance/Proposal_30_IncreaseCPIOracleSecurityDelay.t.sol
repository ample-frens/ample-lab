// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {stdJson} from "forge-std/StdJson.sol";

import {ProposalTest, Proposal, Operation} from "./ProposalTest.sol";

/**
 * @notice Tests proposal 30
 *
 * @custom:references
 *      - [Forum discussion](https://forum.ampleforth.org/t/proposal-to-increase-security-delay-for-pce-cpi-oracle-from-one-day-to-4-weeks/762)
 *      - [Tally vote](https://www.tally.xyz/gov/ampleforth/proposal/30)
 *
 */
contract Proposal_30_IncreaseCPIOracleSecurityDelayTest is ProposalTest {
    function setUp() public override(ProposalTest) {
        super.setUp();

        proposal.executionBlock = 20544791;

        // 1: Update CPI oracle's security delay from 1 day to 4 weeks
        proposal.operations.push(
            Operation({
                target: address(cpiOracle),
                payload: abi.encodeWithSignature(
                    "setReportDelaySec(uint256)", uint(2419200)
                ),
                value: 0
            })
        );
    }

    function test_execute() public {
        bool[] memory oks;
        (oks, /*datas*/ ) = setUpExecutedProposal();

        for (uint i; i < oks.length; i++) {
            assertTrue(oks[i]);
        }
    }

    function test_oracleAvailability() public {
        setUpExecutedProposal();

        uint delaySec = cpiOracle.reportDelaySec();
        uint delayDay = delaySec / 60 / 60 / 24;

        for (uint i; i < delayDay; i++) {
            vm.warp(block.timestamp + (i * 24 hours));

            bool ok;
            ( /*data*/ , ok) = cpiOracle.getData();
            assertTrue(ok);
        }
    }
}
