# `ample-lab`

This project provides:
- A security focused Solidity environment for analyzing the Ampleforth protocol and ecosystem
- A database of Ampleforth contracts onchain configurations
- Security reviews and incident reports created by `ample-frens`

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

## Continuous Security Monitoring

### Chaincheck

The `chaincheck` test suite verifies the current Ethereum mainnet state against the lab's local
database `db/`. This ensures changes in security configurations are noticed.

Run via:
```bash
$ forge test --mc "Chaincheck"
```

### Healthchecks

The `healthcheck` test suite consists of multiple healthchecks against different parts of the
protocol(s) that are run against the current Ethereum mainnet state.

Run via:
```bash
$ forge test --mc "Healthcheck"
```

#### Ampleforth Healthchecks

- The monetary policy executed a rebase in the last 24 hours
- The CPI oracle provides valid data
- Every CPI oracle provider provides a valid report
- The market oracle provides valid data
- Every market oracle provider provides a valid report
- Every transaction stored in the orchestrator is enabled
- Every orchestrator transaction is executable

#### ForthDAO Healthchecks

- The ForthDAO timelock owns every protocol contract
- A DAO vote can be initiated and executed before a CPI report's activation delay passed

#### SPOT Healthchecks

- Bond issuer has at least three active bonds

### Invariants

The `invariants` test suite verifies different invariants against the current Ethereum mainnet
state.

Run via:
```bash
$ forge test --mc "Invariants"
```

#### Ampleforth Invariants

#### ForthDAO Invariants

#### SPOT Invariants

- Every issued bond is collateralized via AMPL

## Security Reviews

- [2024/08: Oracle Infrastructure](./security-reviews/08_2024_OracleInfrastructure.md)

## Incident Reports

- [2024/08/17: Rebase Failure Due To Invalid CPI Oracle Data](./incident-reviews/2024_08_17_RebaseFailureDueToInvalidCPIOracleData.md)
