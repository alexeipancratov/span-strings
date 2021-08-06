// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

/// @title Span Strings Library.
/// @author Alexei Pancratov
/// @notice Provides API to perform various complex operations with strings in a gas efficient way using abstraction called 'span'
/// @dev All function calls are currently implemented without side effects
library SpanStrings {
    struct span {
        uint256 ptr;
        uint256 length;
    }

    /// @notice Returns the span representation of a string
    /// @param str The string to be converted
    /// @return Span representation of the string
    function toSpan(string memory str) internal pure returns (span memory) {
        uint256 ptr;
        assembly {
            // skip string length value (32 bytes)
            ptr := add(str, 0x20)
        }
        return span(ptr, bytes(str).length);
    }

    /// @notice Returns a slice of a span in a form of a new span
    /// @dev This function is memory allocation free
    /// @param str Source span
    /// @param start Start index of the slice
    /// @param length Length of the slice
    /// @return New span representing the slice of the source span
    function getSlice(span memory str, uint256 start, uint256 length) internal pure returns (span memory) {
        uint256 maxLength = str.length - start;
        require(length <= maxLength, "Specified length goes out of bounds");

        uint256 newPointer;
        uint256 oldPointer = str.ptr;
        assembly {
            newPointer := add(oldPointer, start)
        }
        return span(newPointer, length);
    }

    /// @notice Makes a copy of the supplied span
    /// @dev This function is memory allocation free
    /// @param str Span to copy
    /// @return Copy of the source span
    function copy(span memory str) internal pure returns (span memory) {
        return span(str.ptr, str.length);
    }

    /// @notice Checks if span is empty
    /// @param str Span to check
    /// @return True - if span is empty, False - otherwise
    function isEmpty(span memory str) internal pure returns (bool) {
        return str.length == 0;
    }

    /// @notice Concatenates two spans into one
    /// @dev Allocates a new string in memory for the resulting span
    /// @param str1 First span to concatenate
    /// @param str2 Second span to concatenate
    /// @return A new concatenated span
    function concat(span memory str1, span memory str2)
        internal
        pure
        returns (span memory)
    {
        string memory tempStr = new string(str1.length + str2.length);

        // Copy first string
        uint256 srcPtr = str1.ptr;
        uint256 destPtr;
        assembly {
            destPtr := add(tempStr, 0x20)
        }
        copyMemory(srcPtr, destPtr, str1.length);

        // Copy second string
        srcPtr = str2.ptr;
        assembly {
            destPtr := add(tempStr, 0x20)
            let str1Len := mload(add(str1, 0x20))
            destPtr := add(destPtr, str1Len)
        }
        copyMemory(srcPtr, destPtr, str2.length);

        return toSpan(tempStr);
    }

    /// @notice Converts the supplied span to a string representation
    /// @dev Allocates a new string in memory
    /// @param str Span to covert to string
    /// @return String representation of the source span
    function toString(span memory str) internal pure returns (string memory) {
        string memory result = new string(str.length);
        uint256 srcPtr = str.ptr;
        uint256 destPtr;
        assembly {
            destPtr := add(result, 0x20)
        }

        copyMemory(srcPtr, destPtr, str.length);

        return result;
    }
    
    /// @notice Checks whether the two spans are pointing to two memory locations containing the same characters
    /// @param str1 First span
    /// @param str2 Second span
    /// @return True if spans are pointing to memory locations containing the same characters, false otherwise
    function equals(span memory str1, span memory str2) internal pure returns(bool) {
        if (str1.length != str2.length) {
            return false;
        }

        uint256 str1Ptr = str1.ptr;
        uint256 str2Ptr = str2.ptr;

        for (uint256 i = 0; i < str1.length; i++) {
            bytes1 str1Char;
            bytes1 str2Char;
            assembly {
                str1Char := mload(str1Ptr)
                str2Char := mload(str2Ptr)

                str1Ptr := add(str1Ptr, 1)
                str2Ptr := add(str2Ptr, 1)
            }

            if (str1Char != str2Char) {
                return false;
            }
        }

        return true;
    }

    /// @notice Checks if `str1` starts with `str2`
    /// @param str1 Span to search within
    /// @param str2 Span pointing to characters to look for
    /// @return True if the span starts with the provided text, false otherwise
    function startsWith(span memory str1, span memory str2) internal pure returns(bool) {
        uint256 str1Ptr = str1.ptr;
        uint256 str2Ptr = str2.ptr;

        for (uint256 i = 0; i < str2.length; i++) {
            bytes1 str1Char;
            bytes1 str2Char;
            assembly {
                str1Char := mload(str1Ptr)
                str2Char := mload(str2Ptr)

                str1Ptr := add(str1Ptr, 1)
                str2Ptr := add(str2Ptr, 1)
            }

            if (str1Char != str2Char) {
                return false;
            }
        }

        return true;
    }

    /// @notice Checks if `str1` ends with `str2`
    /// @param str1 Span to search within
    /// @param str2 Span pointing to characters to look for
    /// @return True if the span ends with the provided text, false otherwise
    function endsWith(span memory str1, span memory str2) internal pure returns(bool) {
        uint256 str1Ptr = str1.ptr;
        uint256 str2Ptr = str2.ptr;

        assembly {
            let len1 := mload(add(str1, 0x20))
            let len2 := mload(add(str2, 0x20))

            str1Ptr := sub(add(str1Ptr, len1), 1)
            str2Ptr := sub(add(str2Ptr, len2), 1)
        }

        for (uint256 i = 0; i < str2.length; i++) {
            bytes1 str1Char;
            bytes1 str2Char;
            assembly {
                str1Char := mload(str1Ptr)
                str2Char := mload(str2Ptr)

                str1Ptr := sub(str1Ptr, 1)
                str2Ptr := sub(str2Ptr, 1)
            }

            if (str1Char != str2Char) {
                return false;
            }
        }

        return true;
    }

    /// @notice Splits the span string into two subspans based on the `separator`
    /// @dev Modifies the `str` for gas efficiency
    /// @param str Span to split
    /// @param separator Span to use as a separator
    /// @return the subspan after the separator
    function split(span memory str, span memory separator) internal pure returns(span memory) {
        uint256 strPtr = str.ptr;
        uint256 sepPtr = separator.ptr;

        for (uint256 i = 0; i < str.length; i++) {
            bytes1 char1;
            bytes1 char2;

            assembly {
                char1 := mload(add(strPtr, i))
                char2 := mload(add(sepPtr, 0))
            }

            if (char1 == char2) {
                bool allCharsAreEqual = true;
                bytes1 nestedChar1;
                bytes1 nestedChar2;

                // out of bounds check
                if (str.length - i < separator.length) {
                    continue;
                }

                for (uint256 j = 0; j < separator.length; j++) {
                    assembly {
                        nestedChar1 := mload(add(add(strPtr, i), j))
                        nestedChar2 := mload(add(sepPtr, j))
                    }

                    if (nestedChar1 != nestedChar2) {
                        allCharsAreEqual = false;
                    }
                }

                if (allCharsAreEqual) {
                    uint256 returnPtr = str.ptr;
                    uint256 returnLength = i;
                    uint256 sepLength = separator.length;
                    assembly {
                        strPtr := add(add(strPtr, i), sepLength)
                    }
                    str.ptr = strPtr;
                    str.length = str.length - i - separator.length;

                    return span(returnPtr, returnLength);
                }
            }
        }
    }

    function copyMemory(uint256 srcPtr, uint256 destPtr, uint256 length) private pure {
        for (uint256 i = 0; i < length; i++) {
            assembly {
                mstore(destPtr, mload(srcPtr))
                srcPtr := add(srcPtr, 1)
                destPtr := add(destPtr, 1)
            }
        }
    }
}
