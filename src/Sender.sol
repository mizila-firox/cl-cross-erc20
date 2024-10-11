// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IRouterClient} from "lib/chainlink-local/lib/ccip/contracts/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "lib/chainlink-local/lib/ccip/contracts/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "lib/forge-std/src/interfaces/IERC20.sol";

contract Sender {
    IRouterClient router =
        IRouterClient(0xF694E193200268f9a4868e4Aa017A0118C9a8177); // fuji router
    uint64 destionationChain = 16015286601757825753;
    IERC20 linkToken = IERC20(0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846);
    IERC20 usdcToken = IERC20(0x5425890298aed601595a70AB815c96711a31Bc65); // usdc b&m

    function sendMessage(
        address _contractDestinatary,
        uint256 _usdcAmount
    ) external returns (bytes32 receiptId) {
        Client.EVMTokenAmount[]
            memory tokenAmounts = new Client.EVMTokenAmount[](1);

        tokenAmounts[0] = Client.EVMTokenAmount({
            token: address(usdcToken), // usdc b&m
            amount: 1e6 // 1 usdc
        });

        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(_contractDestinatary),
            data: abi.encodeWithSignature("fn(uint256,uint256)", 111, 222),
            tokenAmounts: tokenAmounts,
            feeToken: address(linkToken),
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 800_000})
            )
        });

        uint256 ccipFee = router.getFee(destionationChain, message);

        if (ccipFee > linkToken.balanceOf(address(this))) {
            revert("Insufficient fee token amount");
        }

        linkToken.approve(address(router), ccipFee);
        usdcToken.approve(address(router), _usdcAmount);

        receiptId = router.ccipSend(destionationChain, message);
    }
}
