# Security Review: Oracle Infrastructure

In August 2024 [merkleplant](https://merkleplant.xyz) from the `ample-frens` project conducted a security review of the CPI and market oracles owned by the ForthDAO and used by the Ampleforth protocol.

Note that this security review is not focused on the oracles' contract code but rather on the configuration and behavior of providers at the time of the review.

Goals of the review are the following:
- Educate the community about Ampleforth's oracle infrastructure internals
- Review the oracles' current security configurations
- Derive invariants and tests to automatically verify as part of a community-lead continuous security monitoring effort

## Disclaimer

Recommendations mentioned is this review must not be seen as final and are only intended to start community discussions.

## Table of Contents

- [Overview](#overview)
- [`MedianOracle.sol`](#medianoraclesol)
    - [Security Parameters](#security-parameters)
    - [Value Selection](#value-selection)
- [Market Oracle](#market-oracle)
    - [Provider: Ampleforth Genesis Team](#provider-ampleforth-genesis-team)
    - [Provider: Chainlink](#provider-chainlink)
    - [Provider: Tellor](#provider-tellor)
    - [Recommendations](#recommendations)
- [CPI Oracle](#cpi-oracle)
    - [Provider: Ampleforth Genesis Team](#provider-ampleforth-genesis-team-1)
    - [Provider: Chainlink](#provider-chainlink-1)
    - [Provider: Tellor](#provider-tellor-1)
    - [Recommendations](#recommendations-1)
- [Future Work](#future-work)
    - [Continuous Security Monitoring](#continuous-security-monitoring)

## Overview

The Ampleforth protocol uses two oracles during its rebase operation, a CPI and a market price oracle.
These oracles are of utmost importance to ensure the protocols rebase operation is be performed with correct data.

For a more in depth technical overview of the rebase operation, see [this post](https://forum.ampleforth.org/t/technical-implementation-of-the-rebase-operation/578/1).

### `MedianOracle.sol`

Both oracles are instantiations of Ampleforth's [`MedianOracle.sol`](https://github.com/ampleforth/ampleforth-contracts/blob/master/contracts/MedianOracle.sol) contract, a contract allowing a set of _providers_ to push values to create _reports_. The oracle's final value is derived from its set of valid reports.

A provider can push a new value that will be stored as a report tuple `(uint data, uint timestamp)`.

A report's integrity is proven via checking the tx's `msg.sender` against the list of providers, meaning a provider is responsible for a) continuously generating the correct data offchain and b) pushing that data onchain. This is in contrast to how most oracle networks operate, which separate the data integrity proof from the transaction relaying.

Each provider owns two report storage slots enabling them to have up to two reports onchain at any point in time. If a provider successfully creates a new report it overwrites the older of the two existing ones.

#### Security Parameters

A `MedianOracle` has the following security parameters:

**`owner`**:
The owner of the contract that can update security parameters.

**`providers`**:
The set of providers that are eligible to push reports.

**`minimumProvidersSize`**:
The minimum number of valid reports that need to be available for the oracle to successfully return data.

**`reportDelay`**:
The time duration after which a report becomes valid.

**`reportExpiration`**:
The time duration after which a report becomes invalid again, ie expired.

#### Value Selection

The value of the oracle is the median of the set of the newer valid report for each provider.

## Market Oracle - `0x99C9775E076FDF99388C029550155032Ba2d8914`

| Configuration     | Value                                                                               |
|-------------------|-------------------------------------------------------------------------------------|
| owner             | [ForthDAO](https://etherscan.io/address/0x223592a191ECfC7FDC38a9256c3BD96E771539A9) |
| delay             | 1 hour                                                                              |
| expiration        | 1 day                                                                               |
| minimum providers | 1                                                                                   |
| providers | [Ampleforth Genesis Team](https://etherscan.io/address/0x8844dfd05AC492D1924Ad27ddD5e690B8E72D694), [Chainlink](https://etherscan.io/address/0xd95AE80B3117Fd410d276F7C276d31B2cbFf773D), [Tellor](https://etherscan.io/address/0xf5b7562791114fB1A8838A9E8025de4b7627Aa79)

### Provider: Ampleforth Genesis Team

Checking the last couple days indicates that the Ampleforth provider pushes a new report exactly once per day at ~00:00 am UTC. Note that the report takes 1 hour to finalize due to the `delay` security parameter, meaning the report is valid roughly 1 hour before the rebase window opens at 02:00 am UTC.

Note that further analysis regarding the data correctness is abdicated for this report but is advised to be performed.

Interestingly, the Ampleforth provider wallet is a multi-signature wallet with a `1/5` configuration, meaning any of the five addresses can push a new report. Reviewing the five addresses behavior indicates they mostly belong to developer wallets.

Note that no documentation as to how the AMPL 24 hour VWAP value is derived was found.

### Provider: Chainlink

The Chainlink provider uses a Chainlink Keeper contract to push a new report every time Chainlink's `AMPL/USD` price feed is updated.

As per [data.chain.link](https://data.chain.link/feeds/ethereum/mainnet/ampl-usd), the `AMPL/USD` price feed has a time expiration of two days and spread expiration of 1,000%. Effectively, this means the price feed is only updated every two days, meaning also the Chainlink provider only pushes a new report every two days.

Note that no documentation as to how the AMPL 24 hour VWAP value is derived was found.

### Provider: Tellor

A simple analysis indicates that Tellor pushes a new report once per day at ~00:15 am UTC. This behavior is in sync with the Ampleforth provider's and ensures existence of a valid report during the rebase.

Note that Tellor uses an optimistic oracle approach, meaning the pushed report can be "disputed". A successfully disputed report will be purged again from the market oracle. Note that this mechanism was not reviewed as part of this review.

Note that no documentation as to how the AMPL 24 hour VWAP value is derived was found.

### Recommendations

There are multiple recommendations for the ForthDAO to increase the market oracle's security, liveliness, and transparency guarantees.

1. Providers should publish their data models

During the process of the review it was not possible to find the data model from even just a single provider. An oracle's data model defines the sources and derivation mechanisms used to derive the value for a report. Without a publicly committed data model it is impossible to distinguish between whether an incorrect report was of malicious nature or due to a weak data model.

Data models may be weak if one of the price sources, eg a centralized exchange, has low liquidity and can be manipulated.

Arguably using a VWAP instead of a TWAP or spot market price decreases chances of manipulation, however, _whether a VWAP is actually used is not verifiable by the ForthDAO_.

2. Chainlink reports are invalid during half the rebases

The Chainlink provider only pushes a new report every two days, eventhough a report expires already after just one day. Therefore, _Chainlink reports are not valid during half of the rebases_.

This lowers the effective security of the market oracle from `2/3` to `1/3`.

It is advised to either reach out to Chainlink to increase their update frequency or lower the market oracle's `expiration` security parameter to two days. However, note that increasing the `expiration` security parameter is a tradeoff between fresher market data or higher resilience against malicious providers.

3. Increase the `minimumProviders` Security Parameter

At the time of writing the market oracle's `minimumProviders` security parameter is set to 1, meaning a single valid report is sufficient for the oracle's `readData()` function to succeed and therefore the rebase to execute.

At the time of writing any developer being part of the Ampleforth Genesis Team multi-signature wallet can monitor the Tellor provider and, if Tellor seems offline and Chainlink once again does not provide a valid report, inject a malicious report.

Note that a one hour delay is not sufficient for the ForthDAO to take any actions to purge the malicious report.

Note that while rebasing with an incorrect market value does not inherently lead to an unfair wealth redistribution, it does decrease AMPL's usefulness as unit-of-account and may lead to unfair debt accounting in external protocols.

Note that while increasing the `minimumProviders` security parameter increases the chances of the market oracle not being able to serve valid data, it can be argued that a failing rebase leads to less market disturbance than a rebase with a malicious market price.

4. Research onchain TWAP Oracles as Potential Provider or Tie Breaker

Multiple AMMs provide an own TWAP oracle based on their local historical prices. These TWAP oracles, while easy to manipulate for short timeframes, are quickly becoming very costly to manipulate for longer timeframes.

These TWAP values could be added as an own provider or tie breaker.


## CPI Oracle - `0x2A18bfb505b49AED12F19F271cC1183F98ff4f71`

| Configuration     | Value                                                                               |
|-------------------|-------------------------------------------------------------------------------------|
| owner             | [ForthDAO](https://etherscan.io/address/0x223592a191ECfC7FDC38a9256c3BD96E771539A9) |
| delay             | 28 days, ie 4 weeks hour                                                                              |
| expiration        | 45 days, ie ~6 weeks day                                                                               |
| minimum providers | 1                                                                                   |
| providers | [Ampleforth Genesis Team](https://etherscan.io/address/0x63A257439D423732F883cfd1d62c94f4EaD7E947), [Chainlink](https://etherscan.io/address/0xab8b9bE60dfAb76FD16621c296B21C61fBf63E91), [Tellor](https://etherscan.io/address/0x569881771f8d591F5a8ec1068d857dB1539AFC96)

> NOTE
>
> This review does not evaluate the `expiration` security parameter.
> The respective discussion is moved to the [Incident 2024/08/17: Rebase failure to due invalid CPI oracle data](../incident-reviews/2024_08_17_RebaseFailureDueToInvalidCPIOracleData.md).

### Provider: Ampleforth Genesis Team

Checking the last couple oracle updates indicates that the Ampleforth provider pushes a new report every 28 days.

The Ampleforth provider wallet is a multi-signature wallet with a `1/4` configuration, meaning any of the four addresses can push a new report. Reviewing the four addresses behavior indicates they mostly belong to developer wallets.

Note that no documentation as to where the CPI data is queried from was found.

### Provider: Chainlink

The Chainlink provider uses a Chainlink Keeper contract to push a new report every time Chainlink's `CPI index` feed is updated.

As per [`data.chain.link`](https://data.chain.link/feeds/ethereum/mainnet/consumer-price-index), the `CPI index` feed has a time expiration of 35 days and spread expiration of 1,000%. Effectively, this means the feed is updated every 35 days, meaning also the Chainlink provider pushes a new report every 35 days.

However, the Chainlink Keeper contract is outdated and pushes reports to a previous version the CPI oracle. Therefore, from the CPI oracle's view this provider is offline at the time of writing!

Note that no documentation as to where the CPI data is queried from was found.

### Provider: Tellor

Checking the last couple oracle updates indicates that the Ampleforth provider pushes a new report every 27 days.

Note that Tellor uses an optimistic oracle approach, meaning the pushed report can be "disputed". A successfully disputed report will be purged again from the market oracle. Note that this mechanism was not reviewed as part of this review.

Note that no documentation as to where the CPI data is queried from was found.

### Recommendations

There are multiple recommendations for the ForthDAO to increase the CPI oracle'markets security, liveliness, and transparency guarantees.

> NOTE
>
> There one important difference between the CPI and market oracle's configuration is the `delay` security parameter.
>
> The CPI oracle's report `delay` gives enough time for the ForthDAO to socially coordinate and, via a governance vote, purge invalid reports. This significantly lowers the severity of any malicious provider attack scenario.

1. Providers should publish their data models

During the process of the review it was not possible to find the data model from even just a single provider. An oracle's data model defines the sources and derivation mechanisms used to derive the value for a report. Without a publicly committed data model it is impossible to distinguish between whether an incorrect report was of malicious nature or due to a weak data model.

Data models may be weak if one of the price sources, eg a centralized exchange, has low liquidity and can be manipulated.

2. Chainlink must update their Keeper contract to the new CPI oracle address

If Chainlink does not push valid reports they should be dropped as provider otherwise to not create a false sense of security.

## Future Work

### Continuous Security Monitoring

There are multiple invariants and tests that can be derived and continuously verified against to ensure a more healthy oracle infrastructure, such as:
- Verify every oracle has at any point in time one valid report per provider
- Verify every oracle at any point in time can be read successfully
- Verify that for every oracle `delay < expiration`

The `ample-frens` project aims to continuously monitor the Ampleforth protocol's health, security, and liveliness, and provide security services for the ForthDAO.
