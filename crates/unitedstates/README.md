<p align="center">
  <b>Security-first, no_std-first Rust crates for U.S. public APIs and public data.</b><br>
  One reviewed crate per source, explicit resource budgets, and small auditable releases.
</p>

<div align="center">
  <a href="https://crates.io/crates/unitedstates">Crates.io</a>
  |
  <a href="https://docs.rs/unitedstates">Docs.rs</a>
  |
  <a href="https://github.com/valkyoth/unitedstates/blob/main/docs/IMPLEMENTATION_PLAN.md">Implementation Plan</a>
  |
  <a href="https://github.com/valkyoth/unitedstates/blob/main/docs/RELEASE_PLAN.md">Release Plan</a>
  |
  <a href="https://github.com/valkyoth/unitedstates/blob/main/docs/threat-model.md">Threat Model</a>
  |
  <a href="https://github.com/valkyoth/unitedstates/blob/main/SECURITY.md">Security</a>
</div>

<br>

<p align="center">
  <a href="https://github.com/valkyoth/unitedstates">
    <img src="https://raw.githubusercontent.com/valkyoth/unitedstates/main/.github/images/unitedstates.webp" alt="United States Rust crate overview">
  </a>
</p>

# United States

`unitedstates` is the facade for a security-first Rust ecosystem for lawful, typed
access to U.S. public APIs and datasets. Shared logic is dependency-free,
`no_std`, and independently publishable. Future source crates remain `no_std`;
future networking is isolated in focused `std` crates and is never enabled by
default.

The repository is at its `0.1.0` foundation. It contains only the two crates
needed now: `unitedstates-core` and the `unitedstates` facade. It does not yet
make real upstream requests, and no source integration has been introduced.

## Install

The default facade exposes only `unitedstates-core`:

```toml
[dependencies]
unitedstates = "0.1.0"
```

Or depend directly on the foundation crate:

```toml
[dependencies]
unitedstates-core = "0.1.0"
```

## Current Status

| Capability | Status | Evidence |
| --- | --- | --- |
| Multi-crate workspace | Available | Two independently packageable crates |
| `no_std` shared core and facade | Available | Default builds contain no `std` import |
| Third-party dependencies | None | Workspace manifests contain first-party path dependencies only |
| Unsafe Rust | Forbidden | Every first-party crate uses `#![forbid(unsafe_code)]` |
| Source integrations | Not introduced | Source crates begin only when their implementation milestone starts |
| HTTP/TLS implementation | Not implemented | The transport crate is deferred until its contract milestone |
| Production readiness | Not ready | Production admission is reserved for `1.0.0` after audit and pentest evidence |

## Workspace

| Crate | Environment | Purpose |
| --- | --- | --- |
| `unitedstates` | `no_std` | Facade and convenience re-exports |
| `unitedstates-core` | `no_std` | Shared IDs, policy metadata, methods, and explicit budgets |

No empty placeholder crate is published. A crate is created and published only
when its implementation begins:

| Planned introduction | Crate |
| --- | --- |
| `0.7.0` | `unitedstates-policy` |
| `0.9.0` | `unitedstates-registry` |
| `0.10.0` | `unitedstates-http` |
| `0.13.0` | `unitedstates-codec-json` |
| `0.19.0` | `unitedstates-testkit` |
| `0.20.0` | `unitedstates-schema` |
| `0.21.0` | `unitedstates-executor`, `unitedstates-conformance` |
| `0.22.0` | `unitedstates-nlr` |
| After `1.0.0` | `unitedstates-openfda`, `unitedstates-nasa`, `unitedstates-census`, `unitedstates-regulations`, `unitedstates-sam`, and `unitedstates-noaa` |

`unitedstates-nlr` targets the National Laboratory of the Rockies (NLR,
formerly NREL) at the current `developer.nlr.gov` origin. The deprecated
`developer.nrel.gov` origin is not an allowed credential target. Its 1.0 scope
is deliberately bounded to JSON GET operations for Alternative Fuel Stations
and monthly, lat/lon PVWatts v8. XML, CSV, GeoJSON document output, route POST,
and PVWatts hourly/`file_id` modes are deferred
rather than shaping the shared core. The built-in limiter and cache are
process-local; the SDK does not claim deployment-wide quota coordination or a
persistent authenticated cache.

The [U.S. API capability matrix](https://github.com/valkyoth/unitedstates/blob/main/docs/API_CAPABILITY_MATRIX.md)
traces every shared pre-1.0 primitive to NLR or another selected source. It
also records why openFDA, Census, Regulations.gov, SAM.gov, NWS, and NCEI do
not share one universal government API-key abstraction. NASA scope uses active
APOD and NeoWs operations, not archived Mars Rover or Earth APIs.

Every Rust crate introduced by this project is published to crates.io. Source
and conformance crates use the shared core, policy, and codec crates they
require, never the root facade, registry, executor, HTTP, or another source
crate. `unitedstates-registry` owns generated source-specific authorization bindings;
generic execution belongs to `unitedstates-executor`; the facade aligns features,
wiring, and re-exports only.

## Crate Versioning And Publication

The `unitedstates` facade always equals the repository tag and is published for every
release. Subcrates use independent versions and are published only when their
code, bugfixes, dependency requirements, or immutable package metadata change.
Unchanged subcrates keep their last crates.io version.

At `v1.0.0`, every crate then present in the workspace converges to `1.0.0` and
is published. The exact per-crate state is tracked in
[the crate version matrix](https://github.com/valkyoth/unitedstates/blob/main/docs/CRATE_VERSION_MATRIX.md)
and enforced by `scripts/release_crates.py`.

## Rust Compatibility

Rust `1.97.1` is the pinned development and release toolchain. The public
crates support every stable Rust release from `1.90.0` through `1.97.1`.

| Rust toolchain | Support | Release-gate treatment |
| --- | --- | --- |
| `1.90.0` | Supported MSRV | Full workspace check |
| `1.91.0`, `1.91.1` | Supported | Compatibility check |
| `1.92.0` | Supported | Compatibility check |
| `1.93.0`, `1.93.1` | Supported | Compatibility check |
| `1.94.0`, `1.94.1` | Supported | Compatibility check |
| `1.95.0` | Supported | Compatibility check |
| `1.96.0`, `1.96.1` | Supported | Compatibility check |
| `1.97.0` | Supported | Compatibility check |
| `1.97.1` | Current development release | Full checks, Clippy, tests, docs, and packaging |

The latest-stable pin and Cargo tool versions are checked by
`scripts/check_latest_tools.sh` before a release.

## Platform Direction

Pure library crates are designed from day one for Linux, Windows, macOS,
FreeBSD, NetBSD, Android, and iOS. Platform-independent code does not assume Unix paths,
sockets, clocks, or environment variables. A future Aesynx transport can be
added behind the same transport contracts without changing source crates.

`no_std` support does not claim that TLS, DNS, or sockets are platform
independent. Applications provide those facilities through an explicit
transport implementation.

## Security

The repository starts fail-closed:

- no third-party project dependencies;
- no default networking, TLS, credentials, filesystem, clock, or telemetry;
- no arbitrary host or generic proxy surface;
- no unsafe Rust;
- explicit response budgets;
- source integrations stay `Foundation` until their policy, fixtures, tests,
  upstream review, security review, and pentest gates pass;
- CodeQL uses GitHub default setup rather than an advanced workflow;
- generated and handwritten first-party code/configuration files over 500
  lines fail the local gate.

Report vulnerabilities privately as described in the
[security policy](https://github.com/valkyoth/unitedstates/blob/main/SECURITY.md).

## Development

Run the normal local gate:

```bash
scripts/checks.sh
```

Run the networked freshness and release gate only when preparing a release:

```bash
scripts/release_0_1_gate.sh
```

No tag is created when implementation finishes. Every version stops for the
maintainer's pentest. Findings, fixes, retests, and later GitHub CI fixes stay
current in the same versioned repository report. Development commits are
allowed. Once a version is complete and locally green, its
`AWAITING PENTEST` state is committed and that exact `HEAD` is pentested. After
a clean result or completed remediation and retest, the current version and
`PASS` report are committed. GitHub failures reported by the maintainer are
fixed, documented, and committed in another cycle. Tagging happens only after
the maintainer reports that GitHub is green and explicitly requests the tag.

After that requested tag exists at `HEAD`, publish only the planned crates in
dependency order:

```bash
scripts/release_crates.py --check
scripts/release_crates.py --version 0.1.0 --require-tag
```

## Documentation

- [Implementation plan](https://github.com/valkyoth/unitedstates/blob/main/docs/IMPLEMENTATION_PLAN.md)
- [Release plan](https://github.com/valkyoth/unitedstates/blob/main/docs/RELEASE_PLAN.md)
- [U.S. API capability matrix](https://github.com/valkyoth/unitedstates/blob/main/docs/API_CAPABILITY_MATRIX.md)
- [Standards source policy](https://github.com/valkyoth/unitedstates/blob/main/docs/standards-source-policy.md)
- [Crate version matrix](https://github.com/valkyoth/unitedstates/blob/main/docs/CRATE_VERSION_MATRIX.md)
- [Initial architecture discussion](https://github.com/valkyoth/unitedstates/blob/main/docs/initial-idea.md)
- [Modularity policy](https://github.com/valkyoth/unitedstates/blob/main/docs/modularity-policy.md)
- [Toolchain policy](https://github.com/valkyoth/unitedstates/blob/main/docs/toolchain-policy.md)
- [Threat model](https://github.com/valkyoth/unitedstates/blob/main/docs/threat-model.md)
- [Security controls](https://github.com/valkyoth/unitedstates/blob/main/docs/security-controls.md)
- [Supply-chain security](https://github.com/valkyoth/unitedstates/blob/main/docs/supply-chain-security.md)
- [Unsafe policy](https://github.com/valkyoth/unitedstates/blob/main/docs/unsafe-policy.md)

## License

Licensed under either the Apache License, Version 2.0 or the MIT license, at
your option.
