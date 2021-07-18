// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

library strings {
    struct span {
        uint ptr;
        uint length;
    }
    
    function toSpan(string memory str) internal pure returns(span memory) {
        uint ptr;
        assembly {
            // skip string length value (32 bytes)
            ptr := add(str, 0x20)
        }
        return span(ptr, bytes(str).length);
    }
    
    function getSlice(span memory str, uint start, uint end) internal pure returns(span memory) {
        uint newPointer;
        uint oldPointer = str.ptr;
        assembly {
            newPointer := add(oldPointer, start)
        }
        return span(newPointer, end - start + 1);
    }
    
    function toString(span memory str) internal pure returns(string memory) {
        string memory result = new string(str.length);
        uint srcPtr = str.ptr;
        uint destPtr;
        assembly {
            destPtr := add(result, 0x20)
        }
        
        for (uint i = 0; i < str.length; i++) {
            assembly {
                mstore(destPtr, mload(srcPtr))
                srcPtr := add(srcPtr, 1)
                destPtr := add(destPtr, 1)
            }
        }
        
        return result;
    }
}