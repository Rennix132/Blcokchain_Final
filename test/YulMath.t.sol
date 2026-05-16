// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {YulMath} from "../src/YulMath.sol";

contract YulMathTest is Test {
    YulMath public math;

    function setUp() public {
        math = new YulMath();
    }

    function test_SumSolidity() public view {
        uint256[] memory data = new uint256[](3);
        data[0] = 10;
        data[1] = 20;
        data[2] = 30;
        assertEq(math.sumSolidity(data), 60);
    }

    function test_SumYul() public view {
        uint256[] memory data = new uint256[](3);
        data[0] = 10;
        data[1] = 20;
        data[2] = 30;
        assertEq(math.sumYul(data), 60);
    }

    function testFuzz_SumEquivalence(uint256[] memory data) public view {
        vm.assume(data.length < 50);
        for(uint256 i = 0; i < data.length; i++) {
            data[i] = bound(data[i], 0, type(uint256).max / 50);
        }
        assertEq(math.sumSolidity(data), math.sumYul(data));
    }
}