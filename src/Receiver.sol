// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {CCIPReceiver} from "lib/chainlink-local/lib/ccip/contracts/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "lib/chainlink-local/lib/ccip/contracts/src/v0.8/ccip/libraries/Client.sol";

contract Receiver is CCIPReceiver {
    address public router = 0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59; // sepolia router
    bool public working;
    uint256 public priceA;
    uint256 public priceB;
    bytes public wholeCalldata;

    constructor() CCIPReceiver(router) {}

    // add only allowed chains and contracts to call this
    // add only allowed chains and contracts to call this
    // add only allowed chains and contracts to call this
    // add only allowed chains and contracts to call this
    // add only allowed chains and contracts to call this
    function _ccipReceive(
        Client.Any2EVMMessage memory message
    ) internal override {
        wholeCalldata = message.data;
        // (priceA, priceB) = abi.decode(message.data, (uint256, uint256)); weird. this should work since message.data returns the correct info
        (bool success, ) = address(this).call(message.data);
        require(success, "Receiver: call failed");
    }

    function fn(uint256 a, uint256 b) external {
        working = true;
        priceA = a;
        priceB = b;
    }
}
