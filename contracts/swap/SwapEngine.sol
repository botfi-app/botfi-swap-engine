// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ContractBase.sol";
import "../base/TransferHelper.sol";

contract SwapEngine is TransferHelper, ContractBase {

    event Swap(
        bytes32 routerId, 
        uint256 amount,
        address tokenA,
        uint    feeBps,
        address account  
    );

    using Address for address;
    using Address for address payable;

    bool initialized;

    receive() external payable{}
    fallback() external payable{}

    function addRouter(
        bytes32             id,
        bytes32             adapter, // uni_v2, uni_v3, 1inch, ...                  
        address  payable    route, 
        address             factory,
        address             weth,
        bool                enabled
    ) 
        public 
        onlyOwner 
    {

        require(route != address(0), "BotFi: ZERO_ROUTER_ADDRESS");

        bool isNew = (routers[id].createdAt == 0);
        uint createdAt = (isNew) ? block.timestamp : routers[id].createdAt;

        routers[id] = RouterParams(
            id,
            adapter, 
            route,
            factory,
            weth,
            createdAt,
            enabled
        );

        if(isNew) routersIds.push(id);
    }


    /**
     * @dev perform a swap
     * @param routerId the identifier of the router to use
     * @param amount the total amount including the protocol fee for the swap
     * @param tokenA the token to swap into another token (tokenB)
     * @param payload the encoded swap data to foward to the router
     */ 
    function swap(
        bytes32 routerId,
        uint256 amount, 
        address tokenA, 
        bytes calldata payload
    ) 
        external 
        payable
        nonReentrant()
    {   

        require(routers[routerId].createdAt > 0, "BotFi#Swap: UNSUPPORTED_DEX");
        require(payload.length > 0, "BotFi#Swap: DATA_ARG_REQUIRED");
        require(tokenA != address(0), "BotFi#Swap: ZERO_TOKENA_ADDR");

        if(tokenA == NATIVE_TOKEN) {
            //validate native token input
            require(msg.value == amount, "BotFi#Swap: INSUFFICIENT_BALANCE");
        } else {
            
            // lets transfer the tokens from the user
            transferAsset(tokenA, _msgSender(), address(this), amount);
        }

        //get fee amt
        uint feeAmt = amount - calPercentage(amount, PROTOCOL_FEE);

        // lets perform fee transfer 
        transferAsset(tokenA, _msgSender(), FEE_WALLET, feeAmt);

        address route = routers[routerId].route;
        uint256 swapAmt = amount - feeAmt;

        if(tokenA == NATIVE_TOKEN){
            route.functionCallWithValue(payload, swapAmt);
        } else {

            require(IERC20(tokenA).approve(route, swapAmt), "BotFi#Swap: TOKENA_APPROVAL_FAILED");

            route.functionCallWithValue(payload, msg.value);
        }

        emit Swap(routerId, amount, tokenA, PROTOCOL_FEE, _msgSender());
    }
    
    /**
     * @dev withdraw any stucked tokens in the contract
     * @param token the token address to withdraw
     * @param amount the amount to move out
     */
    function withdraw(address token, uint256 amount) 
        external 
        onlyOwner 
    {
        transferAsset(token, address(this), _msgSender(), amount);
    }

}   