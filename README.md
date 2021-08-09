# SpanStrings Library
The *SpanStrings Library* provides convenient functions for performing operations with strings which are missing in the standard Solidity API. These operations are implemented in a gas-efficient way using the abstraction called span which can be easily converted from/to a string.

## High-level design
The *SpanStrings Library* is entirely based on the concept of a **span**. A span consists of a pointer to a memory location (offset) and length. This design, which is used in many other programming langugages as well, provides the possibility of very efficient strings manipulation in terms of gas consumption. This is because most of the operations can be implemented by manipulating the target where the pointer points to and the length property of the span.

## Implementation Details
The structure of a span can be visualized in the following way:

![image](https://user-images.githubusercontent.com/3188163/128618633-dfce60fc-147f-49d9-9746-99b540e13989.png)

1. **toSpan** - returns the span representation of a string. This is done by extracting the string pointer and its length and constructing a span based on them.
2. **toString** - converts the span to string by allocating a new string object and by copying all characters to it to which the span has pointed before.
3. **getSlice** - returns a slice of the span. This is done by moving the pointer to a new location and by modifying the length.
   * _**Gas optimization:**_ This operation doesn't allocate a new underlying string.
4. **copy** - copies the span to a new span
5. **isEmpty** - checks if span is empty (if length is 0)
6. **concat** - concatenates two spans into one.
   * A new underlying string is allocated in order to copy characters from both spans into a contiguous string.
7. **equals** - checks whether two spans are pointing to two memory locations containing the same characters.
8. **startsWith** - checks if a span starts with another span (based on characters they are pointing to).
9. **endsWith** - checks if a span ends with another span (based on characters they are pointing to).
10. **split** - splits a span based on the separator span. The resulting span will contain all the characters before the separator, and the source span will be modified to point to characters after the separator.
    * _**Gas optimization:**_ the source span will be advanced to memory location after the separator to help save gas in cases when you want to split the string multiple times based on the same separator

## Security Considerations
It may seem that exposing a string pointer may pose a security risk, however:
   * the library manipulates memory pointers (offsets) which are valid for the duration of current call only;
   * out of bound checks are implemented where applicable to prevent modification of non-related data.

## Test coverage
The library is completely tested with unit tests. The coverage is 100% as show below

![image](https://user-images.githubusercontent.com/3188163/128653580-3b50e593-ff8c-4c97-9877-aacde615bb38.png)

## Benchmarking/Gas Profiling Information
The best way to assess the performance of this library is to compare the gas consumption of a smart contract which uses this library with the one that doesn't (and uses functions which operate with strings directly) in a real-world scenario. These two smart contracts are shown below and the target benchmarking function will be `getSlice`.

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./strings_lib.sol";

contract StringsClientEfficient {
    using strings for *;
    
    function testIntegrated() public pure returns(string memory) {
        string memory str1Text = "abcdefghijklmnoprst";
        string memory str2Text = "wxyz";
        
        strings.span memory str1Span = str1Text.toSpan();
        strings.span memory str2Span = str2Text.toSpan();
        
        str1Span = str1Span.getSlice(0, 10);
        str1Span = str1Span.getSlice(0, 8);
        str1Span = str1Span.getSlice(0, 6);
        str1Span = str1Span.getSlice(0, 4);
        str1Span = str1Span.getSlice(0, 2);
        strings.span memory result = str1Span.concat(str2Span);
        
        strings.span memory lookupPhrase = "cd".toSpan();
        if (!result.isEmpty() && result.equals(lookupPhrase)) {
            return result.toString();
        } else {
            return "You didn't guess the logic of this function";
        }
    }
}
```

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

contract StringsClientNonEfficient {
    function testIntegrated() public pure returns(string memory) {
        string memory str1Text = "abcdefghijklmnoprst";
        string memory str2Text = "wxyz";
        
        str1Text = getSubstring(str1Text, 0, 10);
        str1Text = getSubstring(str1Text, 0, 8);
        str1Text = getSubstring(str1Text, 0, 6);
        str1Text = getSubstring(str1Text, 0, 4);
        str1Text = getSubstring(str1Text, 0, 2);
        string memory result = append(str1Text, str2Text);
        
        string memory lookupPhrase = "cd";
        if (bytes(result).length != 0 && areEqual(result, lookupPhrase)) {
            return result;
        } else {
            return "You didn't guess the logic of this function";
        }
    }
    
    // NOTE: === Functions below operate directly on strings ===
    function getSubstring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        
        for (uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }
    
    function append(string memory a, string memory b) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }
    
    function areEqual(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}
```

The comparison results of running these two functions are shown below. The two test cases differ only in number of times split of the first string is made. For example:
```
str1Span = str1Span.getSlice(0, 2);
```
as opposed to
```
str1Span = str1Span.getSlice(0, 10);
str1Span = str1Span.getSlice(0, 8);
str1Span = str1Span.getSlice(0, 6);
str1Span = str1Span.getSlice(0, 4);
str1Span = str1Span.getSlice(0, 2);
```
and in the case of smart conctract which doesn't use the library
```
str1Text = getSubstring(str1Text, 0, 2);
```
as opposed to
```
str1Text = getSubstring(str1Text, 0, 10);
str1Text = getSubstring(str1Text, 0, 8);
str1Text = getSubstring(str1Text, 0, 6);
str1Text = getSubstring(str1Text, 0, 4);
str1Text = getSubstring(str1Text, 0, 2);
```

Operation | Efficient (using library) | Non-efficient
------------ | ------------ | -------------
one split | 25741 gas | 25599 gas
five splits | 27700 gas | 41399 gas

As it can be seen from this table, with one split the version which doesn't use SpanStrings library is actually slightly more efficient. However, with larger number of splits made inside the function, the advantages of using spans instead of strings directly become more apparent.

## Future improvements/considerations
In the current library implementation the advantages of using spans over strings are most noticeable in functions like `getSlice` and `split`. Using this solid base implementation other efficient and useful functions can be implemeted.
