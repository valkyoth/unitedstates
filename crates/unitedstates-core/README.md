<p align="center">
  <b>Security-first, no_std-first Rust crates for U.S. public APIs and public data.</b><br>
  One reviewed crate per source, explicit resource budgets, and small auditable releases.
</p>

<div align="center">
  <a href="https://crates.io/crates/unitedstates-core">Crates.io</a>
  |
  <a href="https://docs.rs/unitedstates-core">Docs.rs</a>
  |
  <a href="https://github.com/valkyoth/unitedstates/blob/main/docs/RELEASE_PLAN.md">Release Plan</a>
  |
  <a href="https://github.com/valkyoth/unitedstates/blob/main/SECURITY.md">Security</a>
</div>

<br>

<p align="center">
  <a href="https://github.com/valkyoth/unitedstates">
    <img src="https://raw.githubusercontent.com/valkyoth/unitedstates/main/.github/images/unitedstates.webp" alt="United States Rust crate overview">
  </a>
</p>

# unitedstates-core

`unitedstates-core` is the dependency-free, `no_std` foundation shared by every
U.S. source crate. Version `0.1.0` provides only reviewed identifiers,
foundation status metadata, HTTP methods, and explicit response budgets.

It does not perform networking, parse upstream payloads, store credentials, or
claim that any source integration is complete.

Licensed under `MIT OR Apache-2.0`.
