const BadgeLookup = artifacts.require("BadgeLookup");
const SynthBadge = artifacts.require("SynthBadge");

module.exports = function(deployer) {
    deployer.deploy(BadgeLookup).then(function() {
        return deployer.deploy(SynthBadge, BadgeLookup.address);
    });
};
