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

contract('DistrictsCore', (accounts) => {

  it("should verify that the contracts are wired properly", async () => {
    const districtsContract = await DistrictsCore.deployed()
    const coreContract = await DopeRaiderCore.deployed()
    const saleClockAuctionContract = await SaleClockAuction.deployed()
    const calculationsContract = await DopeRaiderCalculations.deployed()
    const ammoContract = await DopeRaiderAmmoToken.deployed()
    const seedContract = await DopeRaiderSeedToken.deployed()
    const chemicalContract = await DopeRaiderChemicalToken.deployed()
    const gasContract = await DopeRaiderGasToken.deployed()
    const weedContract = await DopeRaiderWeedToken.deployed()
    const cokeContract = await DopeRaiderCokeToken.deployed()

    //SaleClockAuction.deployed().then(contract => {contract.configureSaleClockAuction(DopeRaiderCore.address , saleAuctionCut);});
    const wire1 = await saleClockAuctionContract.nonFungibleContract.call()
    assert.equal(DopeRaiderCore.address, wire1,
      "Narcos not wired to sale auction address")

    //DopeRaiderCore.deployed().then(contract => {contract.setSaleAuctionAddress(SaleClockAuction.address);});
    const wire2 = await coreContract.saleAuction.call()
    assert.equal(saleClockAuctionContract.address, wire2,
      "Auction not wired to sale Narcos address")

    //DopeRaiderCore.deployed().then(contract => {contract.setDistrictAddress(DistrictsCore.address);});
    const wire3 = await coreContract.districtContractAddress.call()
    assert.equal(DistrictsCore.address, wire3,
      "Districts not wired to narcos address")

    //DistrictsCore.deployed().then(contract => {contract.setNarcosCoreAddress(DopeRaiderCore.address);});
    const wire4 = await districtsContract.coreAddress.call()
    assert.equal(DopeRaiderCore.address, wire4,
      "Narcos not wired to districts address")

    //DistrictsCore.deployed().then(contract => {contract.seCalculationsContractAddress(DopeRaiderCalculations.address);});
    /*	const wire5 = await districtsContract.getCalculationsAddress.call()
    		assert.equal(calculationsContract.address,wire5,
    			"Calculations not wired to districts address")*/

    const wire6 = await districtsContract.tokenContractAddresses.call(0)
    assert.equal(ammoContract.address, wire6,
      "Ammo contract not wired to districts.")

    const wire7 = await districtsContract.tokenContractAddresses.call(1)
    assert.equal(seedContract.address, wire7,
      "Seed contract not wired to districts.")

    const wire8 = await districtsContract.tokenContractAddresses.call(2)
    assert.equal(chemicalContract.address, wire8,
      "Chemical contract not wired to districts.")

    const wire9 = await districtsContract.tokenContractAddresses.call(3)
    assert.equal(gasContract.address, wire9,
      "Gas contract not wired to districts.")

    const wire10 = await districtsContract.tokenContractAddresses.call(4)
    assert.equal(weedContract.address, wire10,
      "Weed contract not wired to districts.")

    const wire11 = await districtsContract.tokenContractAddresses.call(5)
    assert.equal(cokeContract.address, wire11,
      "Coke contract not wired to districts.")

		const wire12 = await ammoContract.districtContractAddress.call();
		assert.equal(wire12, DistrictsCore.address, "Districts not wired to ammo contract")

		const wire13 = await seedContract.districtContractAddress.call();
		assert.equal(wire13, DistrictsCore.address, "Districts not wired to seed contract")

		const wire14 = await chemicalContract.districtContractAddress.call();
		assert.equal(wire14, DistrictsCore.address, "Districts not wired to chemical contract")

		const wire15 = await gasContract.districtContractAddress.call();
		assert.equal(wire15, DistrictsCore.address, "Districts not wired to gas contract")

		const wire16 = await weedContract.districtContractAddress.call();
		assert.equal(wire16, DistrictsCore.address, "Districts not wired to weed contract")

		const wire17 = await cokeContract.districtContractAddress.call();
		assert.equal(wire17, DistrictsCore.address, "Districts not wired to coke contract")

  })

})
