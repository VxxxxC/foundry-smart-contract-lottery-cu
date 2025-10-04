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

abstract contract Raffle is VRFConsumerBaseV2Plus {
    /* Erros */
    error SendMoreEthToRaffle();

    uint256 private immutable i_entranceFee;
    /* @dev The duration of lottery in seconds */
    uint256 private immutable i_interval;
    uint256 private s_lasTimeStamp;
    address payable[] private s_players;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;

    /* Events */
    event RaffleEntered(address indexed player, uint256 amount);

    constructor(
        uint256 _entranceFee,
        uint256 _interval,
        address s_vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) {
        /* @dev Inheritance Chainlink VRF library, also need to inheritance the library constructor */
        VRFConsumerBaseV2Plus(s_vrfCoordinator);

        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        i_entranceFee = _entranceFee;
        i_interval = _interval;
        s_lasTimeStamp = block.timestamp;

    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert SendMoreEthToRaffle();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender, msg.value);
    }

    function pickWinner() external {
        // Check to see if enough time has passed
        if ((block.timestamp - s_lasTimeStamp) > i_interval) {
            revert();
        }

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyHash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: false
                    })
                )
            });

            uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    /* Getter Functions */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
