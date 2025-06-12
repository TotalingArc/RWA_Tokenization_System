// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract RealEstateNFT is ERC721URIStorage, Ownable {
    constructor() ERC721("RealEstateProperty", "REPROP") Ownable(msg.sender) {}
    uint256 public nextTokenId = 1;

    

    function mintProperty(address to, string calldata tokenURI) external onlyOwner returns (uint256) {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        nextTokenId += 1;
        return tokenId;
    }
}
