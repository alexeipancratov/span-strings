const { assert } = require("chai");
const truffleAssert = require("truffle-assertions");
const SpanStringsMock = artifacts.require("SpanStringsMock");

contract("SpanStringsMock", () => {
  let spanStringsInstance;

  beforeEach(async () => {
    spanStringsInstance = await SpanStringsMock.deployed();
  });

  describe("toSpan", () => {
    it("should return a span with correct length", async () => {
      const inputString = "abcdef";

      const result = await spanStringsInstance.toSpan(inputString);

      assert.equal(result._length, inputString.length);
      assert.notEqual(result.ptr, undefined);
      assert.notEqual(result.ptr, null);
    });
  });

  describe("getSlice", () => {
    it("should return slice with correct length", async () => {
      const inputSpan = await spanStringsInstance.toSpan("abcdef");
      const startIndex = 2;
      const sliceLength = 4;

      const result = await spanStringsInstance.getSlice(
        inputSpan,
        startIndex,
        sliceLength
      );

      assert.equal(result._length, sliceLength);
    });

    it("should return a slice with 0 length, given 0 length", async () => {
      const inputSpan = await spanStringsInstance.toSpan("abcdef");
      const startIndex = 1;
      const sliceLength = 0;

      const result = await spanStringsInstance.getSlice(
        inputSpan,
        startIndex,
        sliceLength
      );

      assert.equal(result._length, sliceLength);
    });

    it("should throw an error given a length that goes out of bounds", async () => {
      const inputSpan = await spanStringsInstance.toSpan("abcdef");
      const startIndex = 5;
      const sliceLength = 10;

      await truffleAssert.reverts(
        spanStringsInstance.getSlice(inputSpan, startIndex, sliceLength),
        "Specified length goes out of bounds"
      );
    });
  });

  describe("copy", () => {
    it("should correctly copy length and pointer to a new span", async () => {
      const inputString = "abcdef";
      const inputSpan = await spanStringsInstance.toSpan(inputString);

      const result = await spanStringsInstance.copy(inputSpan);

      assert.equal(result._length, inputString.length);
      assert.equal(result.ptr, inputSpan.ptr);
    });
  });

  describe("isEmpty", () => {
    it("should return true for empty span", async () => {
      const inputString = "";
      const inputSpan = await spanStringsInstance.toSpan(inputString);

      const result = await spanStringsInstance.isEmpty(inputSpan);

      assert.isTrue(result);
    });

    it("should return false for non-empty span", async () => {
      const inputString = "abc";
      const inputSpan = await spanStringsInstance.toSpan(inputString);

      const result = await spanStringsInstance.isEmpty(inputSpan);

      assert.isFalse(result);
    });
  });

  describe("concat", () => {
    it("should return new concatenated span, given two strings with identical lengths", async () => {
      const str1 = "abc";
      const str2 = "def";

      const result = await spanStringsInstance.concat(str1, str2);

      assert.equal(result, "abcdef");
    });

    it("should return new concatenated span, given two strings with different lengths", async () => {
      const str1 = "cde";
      const str2 = "wxyz";

      const result = await spanStringsInstance.concat(str1, str2);

      assert.equal(result, "cdewxyz");
    });
  });

  describe("toString", () => {
    it("should return a correct string representation", async () => {
      const inputString = "abc";

      const result = await spanStringsInstance.toSpanAndBackToString(
        inputString
      );

      assert.equal(result, inputString);
    });
  });

  describe("equals", () => {
    it("should return True for strings containing the same characters", async () => {
      const result = await spanStringsInstance.equalsTrue();

      assert.isTrue(result);
    });

    it("should return False for strings containing at least one different character", async () => {
      const result = await spanStringsInstance.equalsFalse_1();

      assert.isFalse(result);
    });

    it("should return False when at least one of the strings has more characters than the other one", async () => {
      const result = await spanStringsInstance.equalsFalse_2();

      assert.isFalse(result);
    });
  });

  describe("startsWith", () => {
    it("should return True if span starts with the provided text", async () => {
      const result = await spanStringsInstance.startsWithTrue();

      assert.isTrue(result);
    });

    it("should return False if span doesn't start with the provided text and provided text is shorter", async () => {
      const result = await spanStringsInstance.startsWithFalse_ShorterString();

      assert.isFalse(result);
    });

    it("should return False if span doesn't start with the provided text and provided text is longer", async () => {
      const result = await spanStringsInstance.startsWithFalse_LongerString();

      assert.isFalse(result);
    });
  });

  describe("endsWith", () => {
    it("should return True if span ends with the provided text", async () => {
      const result = await spanStringsInstance.endsWithTrue();

      assert.isTrue(result);
    });

    it("should return False if span doesn't end with the provided text which is shorter", async () => {
      const result = await spanStringsInstance.endsWithFalse_ShorterString();

      assert.isFalse(result);
    });

    it("should return False if span doesn't end with the provided text which is longer", async () => {
      const result = await spanStringsInstance.endsWithFalse_LongerString();

      assert.isFalse(result);
    });
  });

  describe("split", () => {
    it("should return correct subspan after single split", async () => {
      const result = await spanStringsInstance.split_Single_ReturnValue(
        "www.google.com",
        "."
      );

      assert.equal(result, "www");
    });

    it("should return correct subspan after two splits", async () => {
      const result = await spanStringsInstance.split_Two_ReturnValue(
        "www.google.com",
        "."
      );

      assert.equal(result, "google");
    });

    it("should modify the original span after split", async () => {
      const modifiedInputStr = await spanStringsInstance.split_InputValue(
        "www.google.com",
        "."
      );

      assert.equal(modifiedInputStr, "google.com");
    });

    it("should return entire span if separator is not found", async () => {
      const inputString = "www.google.com";

      const result = await spanStringsInstance.split_ReturnValue(
        inputString,
        "com.ca"
      );

      assert.equal(result, inputString);
    });

    it("should make the input span empty if separator is not found", async () => {
      const modifiedInput = await spanStringsInstance.split_InputValue(
        "www.google.com",
        "ca"
      );

      assert.equal(modifiedInput, "");
    });
  });
});
