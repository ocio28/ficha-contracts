const Ficha = artifacts.require('Ficha');

module.exports = function(deployer) {
  deployer.deploy(Ficha);
}
