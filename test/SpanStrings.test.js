const { assert } = require("chai");
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
      const sliceLength = 5;

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
    it("should return new span with combined length and new pointer", async () => {
      const str1 = "abc";
      const str2 = "def";
      const span1 = await spanStringsInstance.toSpan(str1);
      const span2 = await spanStringsInstance.toSpan(str2);

      const result = await spanStringsInstance.concat(span1, span2);

      assert.equal(result._length, str1.length + str2.length);
      assert.notEqual(result.ptr, span1.ptr);
      assert.notEqual(result.ptr, span2.ptr);
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

    it("should return False if span doesn't start with the provided text", async () => {
      const result = await spanStringsInstance.startsWithFalse();

      assert.isFalse(result);
    });
  });

  describe("endsWith", () => {
    it("should return True if span ends with the provided text", async () => {
      const result = await spanStringsInstance.endsWithTrue();

      assert.isTrue(result);
    });

    it("should return False if span doesn't ends with the provided text", async () => {
      const result = await spanStringsInstance.endsWithFalse();

      assert.isFalse(result);
    });
  });
});
