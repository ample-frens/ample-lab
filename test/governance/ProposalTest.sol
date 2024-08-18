// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";

struct Proposal {
    uint executionBlock;
    Operation[] operations;
}

struct Operation {
    address target;
    bytes payload;
    uint value;
}

contract ProposalTest is StatefulTest {
    Proposal proposal;

    function setUp() public virtual override(StatefulTest) {
        super.setUp();
    }

    function setUpExecutedProposal()
        public
        returns (bool[] memory, bytes[] memory)
    {
        // Create mainnet fork from $RPC_URL at proposal's execution block.
        vm.createSelectFork(vm.envString("RPC_URL"), proposal.executionBlock);

        // Execute proposal's operations.
        uint len = proposal.operations.length;
        bool[] memory oks = new bool[](len);
        bytes[] memory datas = new bytes[](len);
        for (uint i; i < proposal.operations.length; i++) {
            Operation memory op = proposal.operations[i];

            vm.prank(address(timelock));
            (oks[i], datas[i]) =
                payable(op.target).call{value: op.value}(op.payload);
        }

        return (oks, datas);
    }
}
