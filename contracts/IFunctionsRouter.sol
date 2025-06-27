// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IFunctionsRouter {
    function sendRequest(
        uint64 subscriptionId,
        bytes calldata data,
        uint8 dataVersion,
        uint32 callbackGasLimit,
        bytes32 donId
    ) external returns (bytes32);
}
