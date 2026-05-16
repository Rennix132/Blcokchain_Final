// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract YulMath {
    function sumSolidity(uint256[] memory data) public pure returns (uint256) {
        uint256 total = 0;
        for(uint256 i = 0; i < data.length; i++) {
            total += data[i];
        }
        return total;
    }

    function sumYul(uint256[] memory data) public pure returns (uint256 total) {
        assembly {
            let len := mload(data)
            let ptr := add(data, 0x20)
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                total := add(total, mload(ptr))
                ptr := add(ptr, 0x20)
            }
        }
    }
}