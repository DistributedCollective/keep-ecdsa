/**
 * Use this file to configure your truffle project.
 *
 * More information about configuration can be found at:
 * truffleframework.com/docs/advanced/configuration
 *
 */

require("@babel/register")
require("@babel/polyfill")
const HDWalletProvider = require("@truffle/hdwallet-provider")

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. You can ask a truffle command to
   * use a specific network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    // Useful for testing. The `development` name is special - truffle uses it by default
    // if it's defined here and no other network is specified at the command line.
    // You should run a client (like ganache-cli, geth or parity) in a separate terminal
    // tab if you use this network and you must also set the `host`, `port` and `network_id`
    // options below to some value.
    //
    local: {
      host: "127.0.0.1", // Localhost (default: none)
      port: 8546,
      network_id: "*", // Any network (default: none)
      websockets: true,
    },
    sov: {
      provider: function () {
        return new HDWalletProvider(
          ['2d61b31f93df83e90e78b61943019f3d03fd9f31901359a0e065a4c896eee23d',
          '5957857a88b0ab23b4f2ddd2108e99a114bca0bfe94f0fb5e503a22905e6088f',
          '3c53f81b6e3da8a4818a33554bfef1eec57d45c252550c8ac1593de6f0148c46',
          '0ab212d7bae1f220699eaa40ec84e97a032382a6c0e42c73b1931eb9474a0e1e',
          '79861b19d809f940b4d91cc8ce42c804c4591b324352f037d831aa3a1fb223c9'],          
          'wss://testnet.sovryn.app/websocket',
          0, 
          5
        )
      },
      websockets: true,
      gas: 6700000,
      gasPrice: 70000000,
      skipDryRun: false,
      network_id: '*',
      timeoutBlocks: 200,
      deploymentPollingInterval: 4000,
      disableConfirmationListener: true,
    },
    // local: {
    //   provider: function () {
    //     return new HDWalletProvider(
    //       "4526476adb17c8f751fc4e71e23c4f5e7e2013cd62417b63825cb6cde8a42627",
    //       "HTTP://127.0.0.1:8545"
    //     )
    //   },
    //   gas: 6700000,
    //   gasPrice: 80000000,
    //   skipDryRun: false,
    //   network_id: "*",
    //   timeoutBlocks: 50,
    //   deploymentPollingInterval: 1000,
    // },
    keep_dev: {
      provider: function () {
        return new HDWalletProvider(
          process.env.CONTRACT_OWNER_ETH_ACCOUNT_PRIVATE_KEY,
          "http://localhost:8545"
        )
      },
      gas: 6721975,
      network_id: 1101,
    },
    ropsten: {
      provider: function () {
        return new HDWalletProvider(
          process.env.CONTRACT_OWNER_ETH_ACCOUNT_PRIVATE_KEY,
          process.env.ETH_HOSTNAME
        )
      },
      gas: 8000000,
      network_id: 3,
      skipDryRun: true,
    },
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.5.17", // Fetch exact version from solc-bin (default: truffle's version)
    },
  },
}
