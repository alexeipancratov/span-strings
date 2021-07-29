// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

library strings {
    struct span {
        uint256 ptr;
        uint256 length;
    }

    function toSpan(string memory str) internal pure returns (span memory) {
        uint256 ptr;
        assembly {
            // skip string length value (32 bytes)
            ptr := add(str, 0x20)
        }
        return span(ptr, bytes(str).length);
    }

    function getSlice(
        span memory str,
        uint256 start,
        uint256 end
    ) internal pure returns (span memory) {
        uint256 newPointer;
        uint256 oldPointer = str.ptr;
        assembly {
            newPointer := add(oldPointer, start)
        }
        return span(newPointer, end - start + 1);
    }

    function copy(span memory str) internal pure returns (span memory) {
        return span(str.ptr, str.length);
    }

    function isEmpty(span memory str) internal pure returns (bool) {
        return str.length == 0;
    }

    function concat(span memory str1, span memory str2)
        internal
        pure
        returns (span memory)
    {
        string memory tempStr = new string(str1.length + str2.length);
        uint256 srcPtr = str1.ptr;
        uint256 destPtr;
        assembly {
            destPtr := add(tempStr, 0x20)
        }

        for (uint256 i = 0; i < str1.length; i++) {
            assembly {
                mstore(destPtr, mload(srcPtr))
                srcPtr := add(srcPtr, 1)
                destPtr := add(destPtr, 1)
            }
        }

        srcPtr = str2.ptr;

        for (uint256 i = 0; i < str2.length; i++) {
            assembly {
                mstore(destPtr, mload(srcPtr))
                srcPtr := add(srcPtr, 1)
                destPtr := add(destPtr, 1)
            }
        }

        return toSpan(tempStr);
    }

    function toString(span memory str) internal pure returns (string memory) {
        string memory result = new string(str.length);
        uint256 srcPtr = str.ptr;
        uint256 destPtr;
        assembly {
            destPtr := add(result, 0x20)
        }

        for (uint256 i = 0; i < str.length; i++) {
            assembly {
                mstore(destPtr, mload(srcPtr))
                srcPtr := add(srcPtr, 1)
                destPtr := add(destPtr, 1)
            }
        }

        return result;
    }
}
