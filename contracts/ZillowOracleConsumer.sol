


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

    
