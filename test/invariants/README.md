# Invariants

Invariants are tested against the current Ethereum mainnet state.

## `ampl`

CPIOracle:
- Always provides valid data
- Every provider always providers a valid report


## `forth`

Timelock:
- Every contract's owner is the Timelock
- Every contract's pending owner is zero
