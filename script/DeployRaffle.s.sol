// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";
// import {AddConsumer, CreateSubscription, FundSubscription} from "./Interactions.s.sol";

contract DeployRaffle is Script {
    function deployContract() external returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig(); // This comes with our mocks!
        // AddConsumer addConsumer = new AddConsumer();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        // if (config.subscriptionId == 0) {
        //     CreateSubscription createSubscription = new CreateSubscription();
        //     (config.subscriptionId, config.vrfCoordinatorV2_5) =
        //         createSubscription.createSubscription(config.vrfCoordinatorV2_5, config.account);

        //     FundSubscription fundSubscription = new FundSubscription();
        //     fundSubscription.fundSubscription(
        //         config.vrfCoordinatorV2_5, config.subscriptionId, config.link, config.account
        //     );

        //     helperConfig.setConfig(block.chainid, config);
        // }

        /**
             uint256 _entranceFee,
            uint256 _interval,
            address s_vrfCoordinator,
            bytes32 gasLane,
            uint256 subscriptionId,
            uint32 callbackGasLimit
         **/

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            config.raffleEntranceFee,
            config.automationUpdateInterval,
            config.vrfCoordinatorV2_5,
            config.gasLane,
            config.subscriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();

        // We already have a broadcast in here
        // addConsumer.addConsumer(address(raffle), config.vrfCoordinatorV2_5, config.subscriptionId, config.account);
        return (raffle, helperConfig);
    }
}
