// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/** 
 * @title A simple raffle contract
 * @author VxxxxC
 * @notice This contract is for creating a simple raffle contract
 * @dev This implements the Chainlink VRF v2.5 Chainlink
 */

contract Raffle {
    /* Erros */
    error SendMoreEthToRaffle();

    uint256 private immutable i_entranceFee;
    /* @dev The duration of lottery in seconds */
    uint256 private immutable i_interval;
    uint256 private lasTimeStamp;
    address payable[] private s_players;

    /* Events */
    event RaffleEntered(address indexed player, uint256 amount);

    constructor(uint256 _entranceFee, uint256 _interval) {
        i_entranceFee = _entranceFee;
        i_interval = _interval;
        lasTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        if(msg.value < i_entranceFee){
            revert SendMoreEthToRaffle();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender, msg.value);
        
    }

    function pickWinner() external {
        // Check to see if enough time has passed
       if((block.timestamp - lasTimeStamp) > i_interval){
        revert();
       }

       requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: enableNativePayment
                    })
                )
            })
        );

    }

    /* Getter Functions */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

}