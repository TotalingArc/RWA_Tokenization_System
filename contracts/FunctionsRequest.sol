// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { IFunctionsRouter } from "./IFunctionsRouter.sol";
import { IFunctionsClient } from "./IFunctionsClient.sol";
import { FunctionsRequest } from "./FunctionsRequest.sol";

abstract contract FunctionsClient is IFunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request;

    IFunctionsRouter internal immutable i_router;

    event RequestSent(bytes32 indexed id);
    event RequestFulfilled(bytes32 indexed id);

    error OnlyRouterCanFulfill();

    constructor(address router) {
        i_router = IFunctionsRouter(router);
    }

    function _sendRequest(
        bytes memory data,
        uint64 subscriptionId,
        uint32 callbackGasLimit,
        bytes32 donId
    ) internal returns (bytes32) {
        bytes32 requestId = i_router.sendRequest(
            subscriptionId,
            data,
            FunctionsRequest.REQUEST_DATA_VERSION,
            callbackGasLimit,
            donId
        );
        emit RequestSent(requestId);
        return requestId;
    }

    function fulfillRequest(bytes32 requestId, bytes memory response, bytes memory err) internal virtual;

    function handleOracleFulfillment(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) external override {
        if (msg.sender != address(i_router)) revert OnlyRouterCanFulfill();
        fulfillRequest(requestId, response, err);
        emit RequestFulfilled(requestId);
    }
}

