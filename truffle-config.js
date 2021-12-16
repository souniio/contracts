require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
    plugins: [
        'truffle-plugin-verify'
    ],
    api_keys: {
        bscscan: process.env.BSCSCAN_APIKEY,
    },
    networks: {
        development: {
            host: "127.0.0.1",     // Localhost (default: none)
            port: 8545,            // Standard Ethereum port (default: none)
            network_id: "*",       // Any network (default: none)
        },
        rinkeby: {
            provider: () => new HDWalletProvider(process.env.RINKEBY_PRIVATE_KEY, "https://rinkeby.infura.io/v3/" + process.env.INFURA_APIKEY),
            network_id: 4,
            skipDryRun: true
        },
        bsc: {
            provider: () => new HDWalletProvider(process.env.PRIVATE_KEY, "https://bsc-dataseed1.defibit.io/"),
            network_id: 56
        },
    },

    // Configure your compilers
    compilers: {
        solc: {
            version: "0.8.10",    // Fetch exact version from solc-bin (default: truffle's version)
            settings: {           // See the solidity docs for advice about optimization and evmVersion
                optimizer: {
                    enabled: true,
                    runs: 200
                },
                //  evmVersion: "byzantium"
            }
        },
    },
};
