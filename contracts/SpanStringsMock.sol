// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./SpanStrings.sol";

contract SpanStringsMock {
    using SpanStrings for *;

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

    function concat(string memory str1, string memory str2)
        public pure returns (string memory)
    {
        SpanStrings.span memory span1 = toSpan(str1);
        SpanStrings.span memory span2 = toSpan(str2);

        return SpanStrings.toString(SpanStrings.concat(span1, span2));
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

    function endsWithTrue() public pure returns (bool) {
        SpanStrings.span memory str1 = SpanStrings.toSpan("hello");
        SpanStrings.span memory str2 = SpanStrings.toSpan("llo");
        
        return SpanStrings.endsWith(str1, str2);
    }

    function endsWithFalse() public pure returns (bool) {
        SpanStrings.span memory str1 = SpanStrings.toSpan("hello");
        SpanStrings.span memory str2 = SpanStrings.toSpan("_llo");
        
        return SpanStrings.endsWith(str1, str2);
    }

    function split_Single_ReturnValue(string memory str, string memory separator) public pure returns(string memory) {
        SpanStrings.span memory uri = str.toSpan();
        SpanStrings.span memory result = uri.split(separator.toSpan());
        
        return result.toString();
    }

    function split_Two_ReturnValue(string memory str, string memory separator) public pure returns(string memory) {
        SpanStrings.span memory uri = str.toSpan();
        SpanStrings.span memory result = uri.split(separator.toSpan());
        result = uri.split(".".toSpan());
        
        return result.toString();
    }

    function split_OriginalStr(string memory str, string memory separator) public pure returns(string memory) {
        SpanStrings.span memory uri = str.toSpan();
        uri.split(separator.toSpan());
        
        return uri.toString();
    }
}
