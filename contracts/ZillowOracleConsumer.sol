


contract ZillowOracleConsumer is FunctionsClient, Ownable {
    constructor(address router, address _porFeed) FunctionsClient(router) Ownable(msg.sender) {
        porFeed = PoRFeed(_porFeed);
    }
    using FunctionsRequest for FunctionsRequest.Request;

    string public sourceCode;
    string public lastZillowURL;
    string[] public args = new string[](1);

    bytes32 public latestRequestId;
    string public donId;
    uint64 public subscriptionId;
    uint32 public gasLimit = 300000;

    PoRFeed public porFeed;
    uint256 public tokenId; // Temp token ID to assign value to

    
 function updateConfig(string calldata _source, string calldata _donId, uint64 _subId, uint32 _gasLimit) external onlyOwner {
        sourceCode = _source;
        donId = _donId;
        subscriptionId = _subId;
        gasLimit = _gasLimit;
    }

    function sendZestimateRequest(string calldata zillowURL, uint256 _tokenId) external onlyOwner {
        args[0] = zillowURL;
        lastZillowURL = zillowURL;
        tokenId = _tokenId;

        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(sourceCode);
        req.setArgs(args);
        bytes memory encodedReq = req.encodeCBOR();

        latestRequestId = _sendRequest(encodedReq, subscriptionId, gasLimit, bytes32(bytes(donId)));
    }

    function fulfillRequest(bytes32, bytes memory response, bytes memory err) internal override {
        require(err.length == 0, "Oracle error");
        uint256 zestimate = abi.decode(response, (uint256));
        porFeed.confirmValue(tokenId, zestimate);
    }
}
