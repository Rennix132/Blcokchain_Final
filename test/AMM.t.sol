// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {AMMPair} from "../src/AMMPair.sol";
import {AMMFactory} from "../src/AMMFactory.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract AMMTest is Test {
    AMMFactory public factory;
    AMMPair public pair;
    MockToken public token0;
    MockToken public token1;

    address public user = address(1);

    function setUp() public {
        factory = new AMMFactory();
        MockToken tA = new MockToken("Token A", "TKNA");
        MockToken tB = new MockToken("Token B", "TKNB");
        
        if (address(tA) < address(tB)) {
            token0 = tA;
            token1 = tB;
        } else {
            token0 = tB;
            token1 = tA;
        }

        address pairAddr = factory.createPairWithCreate(address(token0), address(token1));
        pair = AMMPair(pairAddr);

        token0.mint(user, 1000000e18);
        token1.mint(user, 1000000e18);
    }

    function test_AddLiquidity() public {
        vm.startPrank(user);
        token0.approve(address(pair), 1000e18);
        token1.approve(address(pair), 1000e18);
        pair.addLiquidity(1000e18, 1000e18, 0);
        vm.stopPrank();

        assertGt(pair.balanceOf(user), 0);
        assertEq(pair.reserve0(), 1000e18);
        assertEq(pair.reserve1(), 1000e18);
    }

    function testFuzz_Swap(uint256 amountIn) public {
        amountIn = bound(amountIn, 1e18, 5000e18);

        vm.startPrank(user);
        token0.approve(address(pair), 20000e18);
        token1.approve(address(pair), 20000e18);
        pair.addLiquidity(10000e18, 10000e18, 0);

        uint256 balBefore = token1.balanceOf(user);
        pair.swap(address(token0), amountIn, 0);
        uint256 balAfter = token1.balanceOf(user);
        vm.stopPrank();

        assertGt(balAfter, balBefore);
    }

    function test_RevertIfInsufficientAmount() public {
        vm.startPrank(user);
        vm.expectRevert(AMMPair.InsufficientAmount.selector);
        pair.swap(address(token0), 0, 0);
        vm.stopPrank();
    }

    function test_RevertIfInvalidPath() public {
        vm.startPrank(user);
        vm.expectRevert(AMMPair.InvalidPath.selector);
        pair.swap(address(0x123), 100e18, 0);
        vm.stopPrank();
    }

    function test_InvariantKNeverDecreases() public {
        vm.startPrank(user);
        token0.approve(address(pair), 20000e18);
        token1.approve(address(pair), 20000e18);
        pair.addLiquidity(10000e18, 10000e18, 0);

        uint256 kBefore = uint256(pair.reserve0()) * uint256(pair.reserve1());
        
        pair.swap(address(token0), 1000e18, 0);
        
        uint256 kAfter = uint256(pair.reserve0()) * uint256(pair.reserve1());
        assertGe(kAfter, kBefore);
        vm.stopPrank();
    }

    function test_FactoryGettersAndReverts() public {
        address pairAddr = factory.getPair(address(token0), address(token1));
        assertEq(pairAddr, address(pair));

        assertEq(factory.allPairsLength(), 1);
        assertEq(factory.allPairs(0), address(pair));

        vm.expectRevert();
        factory.createPairWithCreate(address(token0), address(token1));
    }
}