const SpanStringsMock = artifacts.require("SpanStringsMock");

module.exports = function(deployer) {
  deployer.deploy(SpanStringsMock);
}
