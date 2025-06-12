



contract Vault is ReentrancyGuard, Ownable {
    constructor(address _nft, address _token, address _porFeed) Ownable(msg.sender) {
        collateralNFT = IERC721(_nft);
        houseDAI = HouseDAI(_token);
        porFeed = PoRFeed(_porFeed);
    }
    IERC721 public collateralNFT;
    HouseDAI public houseDAI;
    PoRFeed public porFeed;

    mapping(uint256 => address) public depositor;
    mapping(uint256 => bool) public isLocked;

    

    function depositAndMint(uint256 tokenId) external nonReentrant {
        require(porFeed.isConfirmed(tokenId), "PoR not verified");
        uint256 value = porFeed.getValue(tokenId);
        require(value > 0, "Invalid valuation");

        collateralNFT.transferFrom(msg.sender, address(this), tokenId);
        isLocked[tokenId] = true;
        depositor[tokenId] = msg.sender;

        houseDAI.mint(msg.sender, value * 1e18);
    }

    function redeem(uint256 tokenId) external nonReentrant {
        require(isLocked[tokenId], "Not deposited");
        require(depositor[tokenId] == msg.sender, "Not depositor");

        uint256 value = porFeed.getValue(tokenId);
        houseDAI.burnFrom(msg.sender, value * 1e18);

        collateralNFT.transferFrom(address(this), msg.sender, tokenId);
        isLocked[tokenId] = false;
        depositor[tokenId] = address(0);
    }
}

