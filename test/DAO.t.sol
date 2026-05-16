// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {GovernanceToken} from "../src/GovernanceToken.sol";
import {DeFiTimelock} from "../src/DeFiTimelock.sol";
import {DeFiGovernor} from "../src/DeFiGovernor.sol";

contract MockTarget {
    uint256 public value;
    function setValue(uint256 _value) external {
        value = _value;
    }
}

contract DAOTest is Test {
    GovernanceToken public token;
    DeFiTimelock public timelock;
    DeFiGovernor public governor;
    MockTarget public target;

    address public proposer = address(1);
    address public voter = address(2);

    function setUp() public {
        token = new GovernanceToken(address(this));
        token.mint(voter, 1000000e18);

        vm.prank(voter);
        token.delegate(voter);

        address[] memory proposers = new address[](1);
        address[] memory executors = new address[](1);
        proposers[0] = address(0);
        executors[0] = address(0);
        timelock = new DeFiTimelock(172800, proposers, executors, address(this));

        governor = new DeFiGovernor(token, address(timelock));

        target = new MockTarget();

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));
        timelock.revokeRole(adminRole, address(this));
    }

    function test_GovernanceLifecycle() public {
        address[] memory targets = new address[](1);
        targets[0] = address(target);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(MockTarget.setValue.selector, 42);
        string memory description = "Set value to 42";

        vm.startPrank(proposer);
        uint256 proposalId = governor.propose(targets, values, calldatas, description);
        vm.stopPrank();

        vm.roll(block.number + 7200 + 1);

        vm.prank(voter);
        governor.castVote(proposalId, 1);

        vm.roll(block.number + 50400 + 1);

        bytes32 descriptionHash = keccak256(bytes(description));
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + 172800 + 1);

        governor.execute(targets, values, calldatas, descriptionHash);

        assertEq(target.value(), 42);
        
        governor.votingDelay();
        governor.votingPeriod();
        governor.quorum(block.number - 1);
        governor.state(proposalId);
        governor.proposalNeedsQueuing(proposalId);
        governor.proposalThreshold();
    }
}