// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {CrossChainBurnAndMintERC1155} from "./utils/CrossChainBurnAndMintERC1155.sol";
import {RealEstatePriceDetails} from "./utils/RealEstatePriceDetails.sol";

contract RealEstateToken is CrossChainBurnAndMintERC1155, RealEstatePriceDetails {
    
    constructor(
        address ccipRouterAddress,
        address linkTokenAddress,
        uint64 currentChainSelector,
        address functionsRouterAddress
    )
        CrossChainBurnAndMintERC1155(ccipRouterAddress, linkTokenAddress, currentChainSelector)
        RealEstatePriceDetails(functionsRouterAddress)
    {}
}