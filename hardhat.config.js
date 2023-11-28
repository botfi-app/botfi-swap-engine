require("@nomicfoundation/hardhat-toolbox");

//require("@nomiclabs/hardhat-waffle");

require("@nomiclabs/hardhat-ethers");

require('hardhat-contract-sizer', { runOnCompile: true });

require('hardhat-deploy');

require('hardhat-abi-exporter',{ path: 'data/abi', clear: true });

const {
  accounts,
  noderealApiKey,
  buildBearApiKey
} = require("./.secrets")


module.exports = {

  networks: {

    hardhat: {
      accounts: accounts.map( privateKey => ({ 
          privateKey, 
          "balance": "991229544000000000000"
      })),
      forking: {
        url: `https://eth-mainnet.nodereal.io/v1/${noderealApiKey}`,
      },
      chainId: 1337
    },

    goerli: {
      url: `https://ethereum-goerli.publicnode.com`,
      chainId: 5,
      accounts
    },   
    
    bsc_testnet: {
      url: `https://data-seed-prebsc-2-s1.binance.org:8545/`,
      chainId: 97,
      accounts
    },   
    
    bnbchain_mainnet: {
      url:  `https://bsc.publicnode.com`,
      chainId: 56,
      accounts
    },

    bnbchain_fork: {
      url:  `https://rpc.tenderly.co/fork/74914579-a14a-4054-ba3a-7cd616136ef7`,
      chainId: 56,
      accounts
    },

    avax_mainnet: {
      url:  `https://api.avax.network/ext/bc/C/rpc`,
      chainId: 43114,
      accounts
    },

    buildbear_avax: {
      url: `https://rpc.buildbear.io/${buildBearApiKey}`,
      chainId: 12602,
      accounts
    }

  },
  solidity: "0.8.20",
};
