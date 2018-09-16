const SaleClockAuction = artifacts.require("SaleClockAuction");
const DopeRaiderCore = artifacts.require("DopeRaiderCore");
const DistrictsCore = artifacts.require("DistrictsCore");
const DopeRaiderCalculations = artifacts.require("DopeRaiderCalculations");
const DopeRaiderAmmoToken = artifacts.require("DopeRaiderAmmoToken");
const DopeRaiderSeedToken = artifacts.require("DopeRaiderSeedToken");
const DopeRaiderChemicalToken = artifacts.require("DopeRaiderChemicalToken");
const DopeRaiderGasToken = artifacts.require("DopeRaiderGasToken");
const DopeRaiderWeedToken = artifacts.require("DopeRaiderWeedToken");
const DopeRaiderCokeToken = artifacts.require("DopeRaiderCokeToken");

module.exports = function(deployer) {
	deployer.deploy(SaleClockAuction);
	deployer.deploy(DopeRaiderCore);
	deployer.deploy(DistrictsCore);
	deployer.deploy(DopeRaiderCalculations);
	deployer.deploy(DopeRaiderAmmoToken);
	deployer.deploy(DopeRaiderSeedToken);
	deployer.deploy(DopeRaiderChemicalToken);
	deployer.deploy(DopeRaiderGasToken);
	deployer.deploy(DopeRaiderWeedToken);
	deployer.deploy(DopeRaiderCokeToken)
	.then(() => {
								console.log("Autowiring the contract addresses");
								var saleAuctionCut = 350; // 10000 basis points
                SaleClockAuction.deployed().then(contract => {contract.configureSaleClockAuction(DopeRaiderCore.address , saleAuctionCut);});
								DopeRaiderCore.deployed().then(contract => {contract.setSaleAuctionAddress(SaleClockAuction.address);});
								DopeRaiderCore.deployed().then(contract => {contract.setDistrictAddress(DistrictsCore.address);});
								DistrictsCore.deployed().then(contract => {contract.setNarcosCoreAddress(DopeRaiderCore.address);});
								DistrictsCore.deployed().then(contract => {contract.seCalculationsContractAddress(DopeRaiderCalculations.address);});
								DopeRaiderAmmoToken.deployed().then(contract => {contract.setDistrictAddress(DistrictsCore.address);});
								DopeRaiderSeedToken.deployed().then(contract => {contract.setDistrictAddress(DistrictsCore.address);});
								DopeRaiderChemicalToken.deployed().then(contract => {contract.setDistrictAddress(DistrictsCore.address);});
								DopeRaiderGasToken.deployed().then(contract => {contract.setDistrictAddress(DistrictsCore.address);});
								DopeRaiderWeedToken.deployed().then(contract => {contract.setDistrictAddress(DistrictsCore.address);});
								DopeRaiderCokeToken.deployed().then(contract => {contract.setDistrictAddress(DistrictsCore.address);});

								var tokenContractAddresses = [
									DopeRaiderAmmoToken.address,
									DopeRaiderSeedToken.address,
									DopeRaiderChemicalToken.address,
									DopeRaiderGasToken.address,
									DopeRaiderWeedToken.address,
									DopeRaiderCokeToken.address
								];

								DistrictsCore.deployed().then(contract => {contract.setTokenAddresses(tokenContractAddresses);});
								console.log("DopeRaiderCore: " + DopeRaiderCore.address);
								console.log("DistrictsCore: " + DopeRaiderCore.address);
								console.log("DopeRaiderCalculations: " + DopeRaiderCalculations.address);
								console.log("DopeRaiderAmmoToken: " + DopeRaiderAmmoToken.address);
								console.log("DopeRaiderSeedToken: " + DopeRaiderSeedToken.address);
								console.log("DopeRaiderChemicalToken: " + DopeRaiderChemicalToken.address);
								console.log("DopeRaiderGasToken: " + DopeRaiderGasToken.address);
								console.log("DopeRaiderWeedToken: " + DopeRaiderWeedToken.address);
								console.log("DopeRaiderCokeToken: " + DopeRaiderCokeToken.address);
            }
        );
};
