const Utils = require("../../../classes/Utils");

const _0x = Utils.zeroAddress;

module.exports = {

    uniswap_v2: {
        router: "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D",
        factory: _0x, // it will be auto fetched
        weth:    _0x, // it will be auto fetched
        adapter: "uni_v2"
    },

    uniswap_v3: {
        router: "0xE592427A0AEce92De3Edee1F18E0157C05861564",
        factory: "0x1F98431c8aD98523631AE4a59f267346ea31F984",
        weth:    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
        adapter: "uni_v3"
    },

    
    pancakeswap_v2: {

        router: "0xEfF92A263d31888d860bD50809A8D171709b7b1c",
        factory: _0x, // it will be auto fetched
        weth:    _0x, // it will be auto fetched
        adapter: "uni_v2"
    },

    pancakeswap_v3: {
        router: "0x1b81D678ffb9C0263b24A97847620C99d213eB14",
        factory: "0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865",
        weth:    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
        adapter: "uni_v3"
    }
}