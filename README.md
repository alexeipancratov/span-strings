# SpanStrings Library
The *SpanStrings Library* provides convenient functions for performing operations with strings which are missing in the standard Solidity API. These operations are implemented in a gas-efficient way using the abstraction called span which can be easily converted from/to a string.

## High-level desing
The *SpanStrings Library* is entirely based on the concept of a **span**. A span consists of a pointer to a memory location and length. This design, which is used in many other programming langugages as well, provides the possibility of very efficient strings manipulation in terms of gas consumption. This is because most of the operations can be implemented by manipulating the target where the pointer points to and the length property of the span.

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
   * out of bound checks are implemented where applicable.
