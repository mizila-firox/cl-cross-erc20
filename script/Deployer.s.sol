// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Sender} from "../src/Sender.sol";
import {Receiver} from "../src/Receiver.sol";
import {IERC20} from "lib/forge-std/src/interfaces/IERC20.sol";

// fuji -> sepolia
contract DeployerScript is Script {
    //
    IERC20 usdcTokenFuji = IERC20(0x5425890298aed601595a70AB815c96711a31Bc65); // usdc b&m
    IERC20 usdckTokenSepolia =
        IERC20(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238);
    IERC20 linkTokenFuji = IERC20(0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846);

    address private fuji = 0xA28B84Bdb9166CB54aB10e70A445D43275bCBb73;
    address private sepolia = 0x93ea719a9665d1d8f1eAAB7E03458Cf018bcee92;

    function run() external {
        vm.startBroadcast();

        // Receiver receiver = new Receiver();
        // console.log("Receiver address: ", address(receiver));

        // Sender sender = new Sender();
        // console.log("Sender address: ", address(sender));

        // //////////////////////////////
        // INTERACTING WITH THE CONTRACTS
        // Sender sender = Sender(fuji);

        // // send link and usdc to the sender contract
        // linkTokenFuji.transfer(address(sender), 2e18);
        // usdcTokenFuji.transfer(address(sender), 1e6);

        // bytes32 messageId = sender.sendMessage(sepolia, 1e6);
        // console.logBytes32(messageId);

        Receiver receiver = Receiver(sepolia);

        console.log("working: ", receiver.working());
        console.log("priceA: ", receiver.priceA());
        console.log("priceB: ", receiver.priceB());
        console.log("=====================================");
        console.logBytes(receiver.wholeCalldata());

        console.log(usdckTokenSepolia.balanceOf(address(receiver)));
    }
}
