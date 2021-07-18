// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./StringsLib.sol";

contract StringsClient {
    using strings for *;
    
    function testToSpan() public pure returns(strings.span memory) {
        string memory str = "test123";
        
        return str.toSpan();
    }
    
    function testGetSlice() public pure returns(strings.span memory) {
        string memory str = "abcdef";
        strings.span memory strSpan = str.toSpan();
        
        return strSpan.getSlice(2, 5);
    }
    
    function testToString() public pure returns(string memory) {
        string memory str = "abcdef";
        strings.span memory strSpan = str.toSpan();
        
        return strSpan.toString();
    }
}