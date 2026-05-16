// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {GovernanceToken} from "../src/GovernanceToken.sol";
import {YieldVault} from "../src/YieldVault.sol";
import {PriceOracle} from "../src/PriceOracle.sol";
import {TreasuryV1} from "../src/TreasuryV1.sol";
import {MockV3Aggregator} from "./mocks/MockV3Aggregator.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract MockAsset is ERC20 {
    constructor() ERC20("Asset", "AST") {}
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract TreasuryV2 is TreasuryV1 {
    function getVersion() external pure override returns (uint256) {
        return 2;
    }
}

contract TokensAndVaultTest is Test {
    GovernanceToken public govToken;
    YieldVault public vault;
    MockAsset public asset;
    PriceOracle public oracle;
    MockV3Aggregator public mockAggregator;
    TreasuryV1 public treasury;

    address public owner = address(1);
    address public user = address(2);

    function setUp() public {
        vm.startPrank(owner);
        
        govToken = new GovernanceToken(owner);
        asset = new MockAsset();
        vault = new YieldVault(asset);
        
        TreasuryV1 impl = new TreasuryV1();
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(impl),
            abi.encodeWithSelector(TreasuryV1.initialize.selector, owner)
        );
        treasury = TreasuryV1(address(proxy));

        mockAggregator = new MockV3Aggregator(8, 2000e8);
        oracle = new PriceOracle(address(mockAggregator), 3600);
        
        vm.stopPrank();

        asset.mint(user, 10000e18);
    }

    function test_GovTokenMint() public {
        vm.prank(owner);
        govToken.mint(user, 100e18);
        assertEq(govToken.balanceOf(user), 100e18);
    }

    function test_GovTokenMintRevertNotOwner() public {
        vm.prank(user);
        vm.expectRevert();
        govToken.mint(user, 100e18);
    }

    function test_GovTokenTransferAndNonces() public {
        vm.prank(owner);
        govToken.mint(user, 100e18);
        
        vm.prank(user);
        govToken.transfer(address(3), 50e18);
        
        assertEq(govToken.balanceOf(address(3)), 50e18);
        assertEq(govToken.nonces(user), 0);
    }

    function testFuzz_VaultDepositWithdraw(uint256 amount) public {
        amount = bound(amount, 1e18, 10000e18);
        
        vm.startPrank(user);
        asset.approve(address(vault), amount);
        vault.deposit(amount, user);
        assertEq(vault.balanceOf(user), amount);

        vault.withdraw(amount, user, user);
        assertEq(asset.balanceOf(user), 10000e18);
        vm.stopPrank();
    }

    function test_OracleLatestPrice() public view {
        uint256 price = oracle.getLatestPrice();
        assertEq(price, 2000e8);
    }

    function test_OracleRevertStalePrice() public {
        skip(3601);
        vm.expectRevert(PriceOracle.StalePrice.selector);
        oracle.getLatestPrice();
    }

    function test_OracleRevertInvalidPrice() public {
        mockAggregator.updateAnswer(0);
        vm.expectRevert(PriceOracle.InvalidPrice.selector);
        oracle.getLatestPrice();
    }

    function test_TreasuryInitialization() public view {
        assertEq(treasury.getVersion(), 1);
        assertEq(treasury.baseFee(), 100);
        assertEq(treasury.owner(), owner);
    }

    function test_TreasuryUpgrade() public {
        vm.startPrank(owner);
        TreasuryV2 newImpl = new TreasuryV2();
        
        bytes memory data = "";
        address(treasury).call(abi.encodeWithSignature("upgradeToAndCall(address,bytes)", address(newImpl), data));
        
        assertEq(treasury.getVersion(), 2);
        vm.stopPrank();
    }
}