/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() {
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>')
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

var HDWalletProvider = require("truffle-hdwallet-provider");

const mnemonic = process.env.MNEMONIC
const infura_apikey = process.env.INFURA_APIKEY

module.exports = {
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 6700000
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, 'https://ropsten.infura.io/' + infura_apikey)
      },
      network_id: 3,
      gas: 6700000,
      gasPrice: 50000000000
    },
    sokol: {
      provider: function() {
        return new HDWalletProvider(mnemonic, 'https://sokol.poa.network/')
      },
      network_id: "77",
      gas: 6700000
    },
    core: {
      provider: function() {
        return new HDWalletProvider(mnemonic, 'https://core.poa.network/')
      },
      network_id: "99",
      gas: 6700000
    }
  }
};
