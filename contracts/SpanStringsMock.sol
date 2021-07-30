// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./SpanStrings.sol";

contract SpanStringsMock {
    function toSpan(string memory str) public pure returns (SpanStrings.span memory)
    {
        return SpanStrings.toSpan(str);
    }

    function getSlice(
        SpanStrings.span memory span,
        uint256 start,
        uint256 length
    ) public pure returns (SpanStrings.span memory)
    {
        return SpanStrings.getSlice(span, start, length);
    }

    function copy(SpanStrings.span memory span) public pure returns (SpanStrings.span memory)
    {
        return SpanStrings.copy(span);
    }

    function isEmpty(SpanStrings.span memory span) public pure returns (bool)
    {
        return SpanStrings.isEmpty(span);
    }

    function concat(SpanStrings.span memory span1, SpanStrings.span memory span2)
        public pure returns (SpanStrings.span memory)
    {
        return SpanStrings.concat(span1, span2);
    }

    function toSpanAndBackToString(string memory str)
        public
        pure
        returns (string memory)
    {
        SpanStrings.span memory span = SpanStrings.toSpan(str);
        return SpanStrings.toString(span);
    }
}
