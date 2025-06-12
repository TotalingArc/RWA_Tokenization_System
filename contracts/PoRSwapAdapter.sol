// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";




contract PoRSwapAdapter is ReentrancyGuard, Ownable {
    constructor(address _houseDAI, address _usdc, address _porFeed, address _liquidityWallet) Ownable(msg.sender) {
        houseDAI = HouseDAI(_houseDAI);
        usdc = IERC20(_usdc);
        porFeed = PoRFeed(_porFeed);
        liquidityWallet = _liquidityWallet;
    }
    using SafeERC20 for IERC20;

    HouseDAI public houseDAI;
    IERC20 public usdc;
    PoRFeed public porFeed;

    address public liquidityWallet;

    

    function swapToUSDC(uint256 amount, uint256 tokenId) external nonReentrant {
        require(porFeed.isConfirmed(tokenId), "PoR not confirmed");

        houseDAI.transferFrom(msg.sender, address(this), amount);
        houseDAI.burn(amount);

        usdc.safeTransferFrom(liquidityWallet, msg.sender, amount);
    }
}
