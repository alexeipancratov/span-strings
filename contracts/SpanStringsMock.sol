// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./SpanStrings.sol";

contract SpanStringsMock {
    function toSpan(string memory str)
        public
        pure
        returns (SpanStrings.span memory)
    {
        return SpanStrings.toSpan(str);
    }

    function getSlice(
        SpanStrings.span memory str,
        uint256 start,
        uint256 end
    ) public pure returns (SpanStrings.span memory) {
        return SpanStrings.getSlice(str, start, end);
    }
}
