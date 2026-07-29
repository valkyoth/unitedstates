# United States 0.1.0 Release Notes

Status: implementation complete; pentest passed

## Scope

This release initializes the dependency-free United States workspace, its two
immediately required public crates, dual licensing, security policies, CI,
documentation, and release-planning baseline.

## Crates

- `unitedstates-core`
- `unitedstates`

Both crates are intended for crates.io. Future crates are created and published
only when their implementation milestone begins.

The `unitedstates` facade follows the repository tag. Subcrates advance and publish
only when required; the release helper validates version policy and publishes
selected crates in dependency order. At `1.0.0`, all then-current crates
converge to `1.0.0`.

## Security

- No third-party project dependencies.
- Unsafe Rust is forbidden.
- No agency or transport crate is present in this release.
- No network, TLS, credential, parser, cache, or hosted relay implementation.
- Explicit response-budget validation is present in `unitedstates-core`.
- Publishing requires an exact tag check when invoked with `--require-tag`.
- Source descriptors prevent contradictory stable/unreviewed metadata and use
  private, forward-compatible fields.
- Cross-platform CI names the United States crates explicitly.
- Locked RFC Editor sources provide checksum-verified offline references for
  URI, date/time, JSON, HTTP, caching, and 429 behavior.
- A repository identity check rejects copied source-project names.
- Shell validation respects declared POSIX shell and Bash interpreters, and
  policy gates require no optional ripgrep installation on clean CI runners.
- RFC integrity uses exact checksums rather than non-portable read-only
  filesystem modes; writable fresh checkouts and tampered bytes are both
  regression-tested.

## Verification Required

```bash
scripts/checks.sh
scripts/release_0_1_gate.sh
cargo deny check
cargo audit
```

The local implementation gate passes. The maintainer assessment reported two
low-severity hardening findings: unclear downstream scope for workspace release
profiles and a source-template timezone in Dependabot. Both are remediated,
regression-checked, and recorded in the permanent `Status: PASS` report.
GitHub Actions and CodeQL default setup must now be green before the maintainer
requests tagging.

## Known Limitations

No real U.S. API operation is implemented. This release is not suitable for
production API access and does not make upstream compatibility claims.
