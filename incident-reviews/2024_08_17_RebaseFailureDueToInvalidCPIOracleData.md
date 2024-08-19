# Incident 2024/08/17: Rebase Failure Due To Invalid CPI Oracle Data

> [!NOTE]
>
> This incident report was posted and is discussed [on the Ampleforth forum](https://forum.ampleforth.org/t/incident-report-rebase-failure-due-to-invalid-cpi-oracle-data/767).

This document analyses the failing rebase operation from Aug 17 2024.

## Summary

On Aug 17 2024 two rebase txs initiated during the rebase window failed during execution and no rebase was executed.

Investigating the txs indicated a CPI oracle failure, ie the CPI oracle was unable to return a valid CPI value.

Note that the CPI oracle's configuration got updated just a couple of hours before to increase the `reportDelaySec` value from 1 day to 4 weeks.

## Important Links

- [Failing rebase tx 1](https://dashboard.tenderly.co/tx/mainnet/0x065d82e2441cf18487565f3525fe4c275411d194a7284a0804d4f097ea07cca7?trace=0.1.2.16)
- [Failing rebase tx 2](https://dashboard.tenderly.co/tx/mainnet/0x74a66b2436a94dd5611d41e55e1aa3d0c67878bc053dc65e2607ec62d36df308)
- [CPI oracle](https://etherscan.io/address/0x2A18bfb505b49AED12F19F271cC1183F98ff4f71)
- [CPI oracle config update tx](https://dashboard.tenderly.co/tx/mainnet/0x3899b875b42db1538bbd48228a1893eba72eadd3f2594063c79c7716fc8cdc70)
- [CPI oracle config update proposal](https://forum.ampleforth.org/t/proposal-to-increase-security-delay-for-pce-cpi-oracle-from-one-day-to-4-weeks/762)

## Analysis

> [!TIP]
>
> For a reminder on how the oracles work internally, see [this post](https://forum.ampleforth.org/t/technical-implementation-of-the-rebase-operation/578#h-3-the-monetarypolicy-fetches-the-target-and-market-rate-from-the-oracles-5).

> [!NOTE]
>
> The analysis was performed with the following tools and environment:
> - `cast` and `anvil`, both tools from the [foundry toolkit](https://getfoundry.sh/)
> - [Alchemy](https://www.alchemy.com/) Ethereum RPC URL stored stored in the `$rpc` environment variable
> - CPI oracle address stored in the `$cpi` environment variable

The analysis is performed via forking the Ethereum chain at the block of the rebase tx:
```bash
anvil --fork-block-number 20545222 --rpc-url $rpc
```

First check the minimum amount of valid reports the oracle needs in order to provide valid data:
```bash
$ cast call $cpi "minimumProviders()(uint)"
> 1
```

As one valid report is enough for the oracle to serve data, it indicates the oracle does not hold a single valid report at current block number.

Therefore, analyze how many providers the oracle has:
```bash
$ cast call $cpi "providersSize()(uint)"
> 3
```

The oracle depends on three different providers pushing data onchain. These providers are:
- The Ampleforth Genesis Team
- Chainlink
- Tellor

Next question to answer is whether the providers did not push any reports recently, or the oracle does not deem those reports valid.

Therefore, analyze each provider's reports. Note that each provider is only allowed to have up to two reports onchain at any point in time. Pushing a third report overwrites the older of the two existing reports.

Get each provider's address:
```bash
$ cast call $cpi "providers(uint)(address)" 0
> 0x63A257439D423732F883cfd1d62c94f4EaD7E947

$ cast call $cpi "providers(uint)(address)" 1
> 0x569881771f8d591F5a8ec1068d857dB1539AFC96

$ cast call $cpi "providers(uint)(address)" 2
> 0xab8b9bE60dfAb76FD16621c296B21C61fBf63E91
```

Get each provider's reports:
```bash
# Provider = 0x63A257439D423732F883cfd1d62c94f4EaD7E947
$ cast call $cpi "providerReports(address,uint)(uint,uint)" 0x63A257439D423732F883cfd1d62c94f4EaD7E947 0
> (1719601211, 122994666666666660152)
$ cast call $cpi "providerReports(address,uint)(uint,uint)" 0x63A257439D423732F883cfd1d62c94f4EaD7E947 1
> (1722020411, 123165999999999996816)

# Provider = 0x569881771f8d591F5a8ec1068d857dB1539AFC96
$ cast call $cpi "providerReports(address,uint)(uint,uint)" 0x569881771f8d591F5a8ec1068d857dB1539AFC96 0
> (1722169391, 123165999999999996817)
$ cast call $cpi "providerReports(address,uint)(uint,uint)" 0x569881771f8d591F5a8ec1068d857dB1539AFC96 1
> (1719789347, 122994666666667001209)

# Provider = 0xab8b9bE60dfAb76FD16621c296B21C61fBf63E91
$ cast call $cpi "providerReports(address,uint)(uint,uint)" 0xab8b9bE60dfAb76FD16621c296B21C61fBf63E91 0
> (1, 0) # Note that 1 indicates address is provider
$ cast call $cpi "providerReports(address,uint)(uint,uint)" 0xab8b9bE60dfAb76FD16621c296B21C61fBf63E91 1
> (0, 0)
```

Multiple points are interesting about the reports:
1. The third provider does not seem to have ever pushed a valid report onchain? Or recently purged all their reports?
2. The other two providers seem to have pushed reports onchain, indicating the oracle itself does not deem them valid.

As a reminder, Ampleforth's oracles have two values creating a time window during which a report is valid:
- `reportDelaySec` - Defines how many seconds after the report is pushed onchain it is deemed valid. This variable is intended to give providers ample time to purge invalid reports if necessary.
- `reportExpirationTimeSec` - Defines after how many seconds after a report is pushed onchain the report is deemed invalid, ie expired.

At current block time, the variables are set as:
```bash
$ cast call $cpi "reportDelaySec()(uint)"
> 2419200 # 28 days

$ cast call $cpi "reportExpirationTimeSec()(uint)"
> 3888000 # 45 days
```

Therefore, a report is valid 28 days after its been pushed onchain, and becomes invalid again 45 days after its been pushed. Therefore, a report is valid for a total of 17 days.

Analyzing the reports the oracle holds indeed indicates that none is valid:
```
Reports 0x63A257439D423732F883cfd1d62c94f4EaD7E947:
    0: timestamp = 1719601211 = Fri Jun 28 19:00:11 2024 UTC
    1: timestamp = 1722020411 = Fri Jul 26 19:00:11 2024 UTC

=> 0: INVALID - Became valid at Jul 26, became invalid at Aug 12
=> 1: INVALID - Becomes valid only at Aug 23

Reports 0x569881771f8d591F5a8ec1068d857dB1539AFC96
    0: timestamp = 1722169391 = Sun Jul 28 12:23:11 2024 UTC
    1: timestamp = 1719789347 = Sun Jun 30 23:15:47 2024 UTC

=> 0: INVALID - Becomes valid only at Aug 27
=> 1: INVALID - Became valid at Jul 26, became invalid at Aug 12

Reports 0xab8b9bE60dfAb76FD16621c296B21C61fBf63E91
    0: timestamp = 1 # No report pushed
    1: timestamp = 0 # No report pushed

=> 0: INVALID
=> 1: INVALID
```

Note that the Forth DAO updated the CPI oracle's `reportDelaySec` from 1 day to 4 weeks __just hours before the failing rebase__. The proposal was posted on the [Ampleforth's governance forum](https://forum.ampleforth.org/t/proposal-to-increase-security-delay-for-pce-cpi-oracle-from-one-day-to-4-weeks/762), [approved](https://www.tally.xyz/gov/ampleforth/proposal/30) by Forth token holders, and [executed](https://dashboard.tenderly.co/tx/mainnet/0x3899b875b42db1538bbd48228a1893eba72eadd3f2594063c79c7716fc8cdc70?trace=0.2.7.0.1.0.1.18.7) via Chainlink Keepers.

Without this configuration change, multiple reports would have been valid:
```
Reports 0x63A257439D423732F883cfd1d62c94f4EaD7E947:
    0: timestamp = 1719601211 = Fri Jun 28 19:00:11 2024 UTC
    1: timestamp = 1722020411 = Fri Jul 26 19:00:11 2024 UTC

=> 0: INVALID - Became valid at Jun 29, became invalid at Aug 12
=> 1: VALID   - Became valid at Jul 27

Reports 0x569881771f8d591F5a8ec1068d857dB1539AFC96
    0: timestamp = 1722169391 = Sun Jul 28 12:23:11 2024 UTC
    1: timestamp = 1719789347 = Sun Jun 30 23:15:47 2024 UTC

=> 0: VALID   - Became valid at Jul 29
=> 1: INVALID - Became valid at Jul 1, became invalid at Aug 12

Note: Omitting non-existing reports from 0xab8b9bE60dfAb76FD16621c296B21C61fBf63E91
```

## Results

This incident report proves that the recent configuration change lead to the CPI oracle failure. Furthermore, it is shown that the CPI oracle does not serve data until Aug 23, meaning up until then no rebase operation will be possible.
