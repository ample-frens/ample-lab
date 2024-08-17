# Invariants

Invariants are tested against the current Ethereum mainnet state.

## Ampleforth

CPIOracle:
- Always provides valid data
- Every provider always providers a valid report

MarketOracle:
- Always provides valid data
- Every provider always providers a valid report

MonetaryPolicy:
- Rebased in the last 24 hours

Orchestrator:
- Every transaction is enabled
- Every transaction is executable


## ForthDAO

Timelock:
- Every contract's owner is the Timelock
