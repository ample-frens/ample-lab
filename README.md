# Lab

This project provides a security focused Solidity environment for analyzing the Ampleforth protocol
and ecosystem.

It provides multiple test suites to execute against the Ethereum mainnet state. These test suites
are run periodically to monitor the protocol.

This repository also contains a database of Ampleforth contracts and onchain configurations inside
the `db/` directory. This database is checked periodically against the mainnet state.


## Installation and Setup

To install as foundry module:
```bash
$ forge install ample-frens/lab
```

To install as git repository:
```bash
$ git clone https://github.com/ample-frens/lab
```

Set the `RPC_URL` variable inside `.env` to an Ethereum rpc node and source `.env`:
```bash
$ source .env
```


## Chaincheck

The `chaincheck` test suite verifies the current Ethereum mainnet state against the lab's local
database `db/`. This ensures changes in security configurations are noticed.

Run via:
```bash
$ forge test --mc "Chaincheck"
```

## Invariants

The `invariants` test suite verifies different invariants against the current Ethereum mainnet
state. Note that some invariants may be considered optional.

Run via:
```bash
$ forge test --mc "Invariants"
```

### Ampleforth Invariants

1. The monetary policy executed a rebase in the last 24 hours
2. The CPI oracle provides valid data
3. Every CPI oracle provider provides a valid report
4. The market oracle provides valid data
5. Every market oracle provider provides a valid report
6. Every transaction stored in the orchestrator is enabled
7. Every orchestrator transaction is executable

### ForthDAO Invariants

1. The timelock owns every contract except itself
2. A DAO vote can be initiated and executed before a CPI report's activation delay passed

