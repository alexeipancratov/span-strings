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

    function concat(SpanStrings.span memory str1, SpanStrings.span memory str2)
        public pure returns (SpanStrings.span memory)
    {
        return SpanStrings.concat(str1, str2);
    }

    function toSpanAndBackToString(string memory str)
        public
        pure
        returns (string memory)
    {
        SpanStrings.span memory span = SpanStrings.toSpan(str);
        return SpanStrings.toString(span);
    }

    function equalsTrue() public pure returns (bool) {
        SpanStrings.span memory str1 = SpanStrings.toSpan("hello");
        SpanStrings.span memory str2 = SpanStrings.toSpan("hello");
        
        return SpanStrings.equals(str1, str2);
    }

    function equalsFalse_1() public pure returns (bool) {
        SpanStrings.span memory str1 = SpanStrings.toSpan("hello");
        SpanStrings.span memory str2 = SpanStrings.toSpan("hellO");
        
        return SpanStrings.equals(str1, str2);
    }

    function equalsFalse_2() public pure returns (bool) {
        SpanStrings.span memory str1 = SpanStrings.toSpan("hello");
        SpanStrings.span memory str2 = SpanStrings.toSpan("hello123");
        
        return SpanStrings.equals(str1, str2);
    }

    function startsWithTrue() public pure returns (bool) {
        SpanStrings.span memory str1 = SpanStrings.toSpan("hello");
        SpanStrings.span memory str2 = SpanStrings.toSpan("he");
        
        return SpanStrings.startsWith(str1, str2);
    }

    function startsWithFalse() public pure returns (bool) {
        SpanStrings.span memory str1 = SpanStrings.toSpan("hello");
        SpanStrings.span memory str2 = SpanStrings.toSpan("he_");
        
        return SpanStrings.startsWith(str1, str2);
    }
}
