// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library FunctionsRequest {
    uint8 internal constant REQUEST_DATA_VERSION = 1;

    struct Request {
        string source;
        string[] args;
    }

    function initializeRequestForInlineJavaScript(Request memory req, string memory sourceCode) internal pure {
        req.source = sourceCode;
    }

    function setArgs(Request memory req, string[] memory args) internal pure {
        req.args = args;
    }

    function encodeCBOR(Request memory req) internal pure returns (bytes memory) {
        return abi.encode(req.source, req.args);
    }
}
