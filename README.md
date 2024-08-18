# Lab

> A Solidity lab for the Ampleforth ecosystem

## Setup

- Set `RPC_URL` in `.env` to Ethereum mainnet node and `source .env`


## Chaincheck

The `chaincheck` test suite verifies the lab's database against the current Ethereum mainnet state.


## Invariants

The `invariants` test suite verifies invariants against the current Ethereum mainnet state.

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
