// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./SpanStrings.sol";

contract StringsClient {
    using SpanStrings for *;

    function testToSpan() public pure returns (SpanStrings.span memory) {
        string memory str = "test123";

        return str.toSpan();
    }

    function testGetSlice() public pure returns (SpanStrings.span memory) {
        string memory str = "abcdef";
        SpanStrings.span memory strSpan = str.toSpan();

        return strSpan.getSlice(2, 5);
    }

    function testToString() public pure returns (string memory) {
        string memory str = "abcdef";
        SpanStrings.span memory strSpan = str.toSpan();

        return strSpan.toString();
    }

    function testConcat() public pure returns (string memory) {
        SpanStrings.span memory str1 = "hello, ".toSpan();
        SpanStrings.span memory str2 = "world!".toSpan();

        SpanStrings.span memory concatenated = str1.concat(str2);

        return concatenated.toString();
    }
}
