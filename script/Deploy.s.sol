// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {GovernanceToken} from "../src/GovernanceToken.sol";
import {DeFiTimelock} from "../src/DeFiTimelock.sol";
import {DeFiGovernor} from "../src/DeFiGovernor.sol";
import {AMMFactory} from "../src/AMMFactory.sol";
import {TreasuryV1} from "../src/TreasuryV1.sol";
import {YieldVault} from "../src/YieldVault.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockAsset is ERC20 {
    constructor() ERC20("Test Deposit Asset", "TDA") {
        _mint(msg.sender, 1000000e18);
    }
}

contract DeployAll is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        GovernanceToken govToken = new GovernanceToken(deployerAddress);

        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](0);
        DeFiTimelock timelock = new DeFiTimelock(172800, proposers, executors, deployerAddress);

        DeFiGovernor governor = new DeFiGovernor(govToken, address(timelock));

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0)); 
        timelock.revokeRole(adminRole, deployerAddress);

        AMMFactory factory = new AMMFactory();

        TreasuryV1 treasuryImpl = new TreasuryV1();
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(treasuryImpl),
            abi.encodeWithSelector(TreasuryV1.initialize.selector, deployerAddress)
        );
        TreasuryV1 treasury = TreasuryV1(address(proxy));

        MockAsset asset = new MockAsset();
        YieldVault vault = new YieldVault(asset);

        vm.stopBroadcast();
    }
}