<a href="https://vercel.com" title="Vercel"><img align="right" hspace="4" alt="Vercel" height="28" src="https://cdn.simpleicons.org/vercel/8A92B2"/></a>
<a href="https://thegraph.com" title="The Graph"><img align="right" hspace="4" alt="The Graph" height="28" src="https://cdn.simpleicons.org/thegraph/6747ED"/></a>
<a href="https://graphql.org" title="GraphQL"><img align="right" hspace="4" alt="GraphQL" height="28" src="https://cdn.simpleicons.org/graphql/E10098"/></a>
<a href="https://ethereum.org" title="Ethereum"><img align="right" hspace="4" alt="Ethereum" height="28" src="https://cdn.simpleicons.org/ethereum/8A92B2"/></a>
<a href="https://tailwindcss.com" title="Tailwind CSS"><img align="right" hspace="4" alt="Tailwind" height="28" src="https://cdn.simpleicons.org/tailwindcss/06B6D4"/></a>
<a href="https://www.typescriptlang.org/" title="TypeScript"><img align="right" hspace="4" alt="TypeScript" height="28" src="https://cdn.simpleicons.org/typescript/3178C6"/></a>
<a href="https://nextjs.org" title="Next.js"><img align="right" hspace="4" alt="Next.js" height="28" src="https://cdn.simpleicons.org/nextdotjs/8A92B2"/></a>
<a href="https://react.dev" title="React"><img align="right" hspace="4" alt="React" height="28" src="https://cdn.simpleicons.org/react/61DAFB"/></a>

# tenderdeve

_DeFi frontend engineer — trading UIs, liquidity dashboards, on-chain data viz._

I build the frontends people use to trade, lend, and manage positions in DeFi. React / Next.js + TypeScript + Tailwind, with ethers.js + wagmi + subgraphs underneath. I care about performance, accessibility, and numbers traders trust with real money.

<br clear="all"/>

```text
┌─ now ─────────────────────────────────────────────┐
│  building     perp-trading-ui                     │
│  available    yes — freelance                     │
│  response     ~24h                                │
│  reach        @tenderdeve                         │
└───────────────────────────────────────────────────┘
```

## projects

|   | repo | what it does | stack |
|---|------|--------------|-------|
| ◐ | **[perp-trading-ui](https://github.com/tenderdeve/perp-trading-ui)** | perpetual futures DEX UI — leverage, order book, live PnL | React · TS · Tailwind |
| ◐ | **[defi-dashboard](https://github.com/tenderdeve/defi-dashboard)** | real-time portfolio tracker — token charts, LP positions, P&L | Next.js · wagmi · recharts |
| ◐ | **[amm-swap-interface](https://github.com/tenderdeve/amm-swap-interface)** | AMM swap + LP management — slippage, price impact, tx history | Next.js · GraphQL · ethers |
| ● | **[subgraph-query-kit](https://github.com/tenderdeve/subgraph-query-kit)** | pre-built DeFi subgraph queries for Uniswap / Aave / Compound | TypeScript · Apollo |
| ● | **[web3-auth-kit](https://github.com/tenderdeve/web3-auth-kit)** | drop-in React components for Web3 auth + EIP-712 signing | React · wagmi · viem |
| ● | **[react-performance-patterns](https://github.com/tenderdeve/react-performance-patterns)** | documented React perf patterns with before/after benchmarks | React · Next.js |

<sub>◐ building &nbsp; · &nbsp; ● shipped</sub>

<sub>also using: `ethers.js` · `viem` · `wagmi` · `Apollo` · `React Query`</sub>

## open source contributions

<!-- START:ecosystem -->
<details open>
<summary><b><a href="https://github.com/daaoai/dex">daaoai/dex</a></b> &middot; 5 PRs &middot; <a href="https://github.com/daaoai/dex/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#7`](https://github.com/daaoai/dex/pull/7) — fix: eslint any bypass
- [`#6`](https://github.com/daaoai/dex/pull/6) — Feat/minor features
- [`#5`](https://github.com/daaoai/dex/pull/5) — Chore/refactor code
- [`#4`](https://github.com/daaoai/dex/pull/4) — Feat/swap UI
- [`#2`](https://github.com/daaoai/dex/pull/2) — Feat/graph UI

</details>

<details open>
<summary><b><a href="https://github.com/NomicFoundation/hardhat">NomicFoundation/hardhat</a></b> &middot; 2 PRs &middot; <a href="https://github.com/NomicFoundation/hardhat/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#8201`](https://github.com/NomicFoundation/hardhat/pull/8201) — perf: lazy-load heavy dependencies in hardhat-utils
- [`#8200`](https://github.com/NomicFoundation/hardhat/pull/8200) — chore: drop beta references from init process and templates

</details>

<details open>
<summary><b><a href="https://github.com/family/connectkit">family/connectkit</a></b> &middot; 2 PRs &middot; <a href="https://github.com/family/connectkit/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#508`](https://github.com/family/connectkit/pull/508) — fix: add Base to default chains so its icon renders out of the box
- [`#507`](https://github.com/family/connectkit/pull/507) — fix: deduplicate injected connector when EIP-6963 wallet is detected

</details>

<details open>
<summary><b><a href="https://github.com/near/near-sdk-js">near/near-sdk-js</a></b> &middot; 2 PRs &middot; <a href="https://github.com/near/near-sdk-js/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#428`](https://github.com/near/near-sdk-js/pull/428) — fix: add missing ft_metadata view function to fungible token example
- [`#427`](https://github.com/near/near-sdk-js/pull/427) — docs: add CLI usage example for building and deploying contracts

</details>

<details open>
<summary><b><a href="https://github.com/wevm/viem">wevm/viem</a></b> &middot; 2 PRs &middot; <a href="https://github.com/wevm/viem/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#4554`](https://github.com/wevm/viem/pull/4554) — feat: support anonymous events in encodeEventTopics
- [`#4553`](https://github.com/wevm/viem/pull/4553) — fix: clean up listenersCache and cleanupCache when last observer unsubscribes

</details>

<details open>
<summary><b><a href="https://github.com/MetaMask/metamask-extension">MetaMask/metamask-extension</a></b> &middot; 1 PR &middot; <a href="https://github.com/MetaMask/metamask-extension/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#42188`](https://github.com/MetaMask/metamask-extension/pull/42188) — docs: replace outdated IRC link with Mozilla Matrix channel

</details>

<details open>
<summary><b><a href="https://github.com/OffchainLabs/nitro">OffchainLabs/nitro</a></b> &middot; 1 PR &middot; <a href="https://github.com/OffchainLabs/nitro/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#4677`](https://github.com/OffchainLabs/nitro/pull/4677) — fix: add forge version check to check-build.sh

</details>

<details open>
<summary><b><a href="https://github.com/ensdomains/ens-app-v3">ensdomains/ens-app-v3</a></b> &middot; 1 PR &middot; <a href="https://github.com/ensdomains/ens-app-v3/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#1125`](https://github.com/ensdomains/ens-app-v3/pull/1125) — fix: use calendar-aware year calculation in renew modal to prevent infinite loop

</details>

<details open>
<summary><b><a href="https://github.com/ethers-io/ethers.js">ethers-io/ethers.js</a></b> &middot; 1 PR &middot; <a href="https://github.com/ethers-io/ethers.js/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#5132`](https://github.com/ethers-io/ethers.js/pull/5132) — fix: defer subscriber teardown in emit to prevent WebSocket subscription loss

</details>

<details open>
<summary><b><a href="https://github.com/ponder-sh/ponder">ponder-sh/ponder</a></b> &middot; 1 PR &middot; <a href="https://github.com/ponder-sh/ponder/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#2299`](https://github.com/ponder-sh/ponder/pull/2299) — fix: include public schema in PGLite search_path for raw SQL queries

</details>

<details open>
<summary><b><a href="https://github.com/remix-project-org/remix-project">remix-project-org/remix-project</a></b> &middot; 1 PR &middot; <a href="https://github.com/remix-project-org/remix-project/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#7147`](https://github.com/remix-project-org/remix-project/pull/7147) — fix: default deployed contract functions to expanded state

</details>

<details open>
<summary><b><a href="https://github.com/solana-foundation/anchor">solana-foundation/anchor</a></b> &middot; 1 PR &middot; <a href="https://github.com/solana-foundation/anchor/pulls?q=author%3Atenderdeve+is%3Apr">all →</a></summary>

- [`#4479`](https://github.com/solana-foundation/anchor/pull/4479) — docs: add surfpool configuration reference to Anchor.toml docs

</details>
<!-- END:ecosystem -->

<details>
<summary><b>activity</b> &nbsp;<sub><i>(unique commits, all branches, public + private — auto-refreshed twice daily)</i></sub></summary>

<!-- START:activity -->
| window | commits |
| --- | --- |
| rolling 365d | **49** |
| 2026 ytd | **26** |
<!-- END:activity -->

</details>

## reach

[github](https://github.com/tenderdeve) &nbsp;·&nbsp; [x](https://x.com/tenderdeve) &nbsp;·&nbsp; [linkedin](https://www.linkedin.com/in/tenderdeve) &nbsp;·&nbsp; [email](mailto:tenderdeve@proton.me) &nbsp;·&nbsp; [sponsor](https://github.com/sponsors/tenderdeve)

<sub>open to freelance — DeFi frontend infra, trading UIs, on-chain data viz.</sub>
