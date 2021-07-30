const SpanStringsMock = artifacts.require('SpanStringsMock');

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
    });
  });

  describe("getSlice", () => {
    it("should return slice with correct length", async () => {
      const inputSpan = await spanStringsInstance.toSpan("abcdef");
      const startIndex = 2;
      const endIndex = 5;
      const expectedSliceLength = endIndex - startIndex + 1;

      const result = await spanStringsInstance.getSlice(inputSpan, startIndex, endIndex);

      assert.equal(result._length, expectedSliceLength);
    });
  });
});
