
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HouseDAI is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("HouseDAI", "HDAI") Ownable(msg.sender) {}
    

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burnFrom(address account, uint256 amount) public override onlyOwner {
        _burn(account, amount);
    }
}
