# Changelog

All notable changes to United States are documented here. The project follows
Semantic Versioning for each independently published crate.

## Unreleased

## 0.1.0 - Unreleased

### Added

- Dependency-free Rust workspace with two independently publishable crates:
  `unitedstates-core` and `unitedstates`.
- `no_std` facade and shared-core boundary.
- Phased crate-introduction policy that avoids publishing empty placeholders.
- Eth-style selective crate publisher with independent subcrate versions,
  facade/tag alignment, dependency ordering, and mandatory `1.0.0`
  convergence.
- Security, contribution, dependency, CI, modularity, toolchain, and release
  policies.
- Detailed implementation and release plans through the serious `1.0.0`
  production gate.
- Locked, checksum-verified RFC Editor references for the URI, date/time, JSON,
  HTTP, caching, and status standards used by the pre-1.0 architecture.
- Identity regression checks preventing copied source-project names from
  returning in workflows or documentation.

### Security

- Unsafe Rust is forbidden.
- Project crates have no third-party dependencies.
- No agency or transport crate is present, so no source or network capability is
  claimed.
- Response sizes require explicit budgets.
- Source descriptors reject a stable status paired with unreviewed access and
  expose metadata only through invariant-preserving construction and accessors.
- Cross-platform CI invokes the United States packages on FreeBSD, NetBSD,
  Android, and iOS targets.
