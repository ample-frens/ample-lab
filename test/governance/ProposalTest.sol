// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {StatefulTest} from "../StatefulTest.sol";

contract ProposalTest is StatefulTest {
    function setUp() public override(StatefulTest) {
        super.setUp();
    }

    struct Proposal {
        Operation[] operations;
    }

    struct Operation {
        address target;
        bytes payload;
        uint value;
    }

    function execute(Proposal memory proposal) public {}
}
