




contract PoRFeed is Ownable {
    constructor() Ownable(msg.sender) {}
    mapping(uint256 => uint256) public values;
    mapping(uint256 => bool) public confirmed;
    address public oracle;

    modifier onlyOracle() {
        require(msg.sender == oracle, "Not oracle");
        _;
    }

    function setOracle(address _oracle) external onlyOwner {
        oracle = _oracle;
    }

    function confirmValue(uint256 tokenId, uint256 value) external onlyOracle {
        values[tokenId] = value;
        confirmed[tokenId] = true;
    }

    function isConfirmed(uint256 tokenId) external view returns (bool) {
        return confirmed[tokenId];
    }

    function getValue(uint256 tokenId) external view returns (uint256) {
        return values[tokenId];
    }
}
