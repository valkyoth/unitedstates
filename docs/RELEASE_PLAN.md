# United States Release Plan To 1.0

Status: planning document; `v0.1.0` implementation complete and awaiting its
United States repository pentest; `v0.2.0` begins only after that release gate.

This is the authoritative version sequence. The architecture is derived from
the operation contracts in [API_CAPABILITY_MATRIX.md](API_CAPABILITY_MATRIX.md),
not from another national API ecosystem. Before 1.0, the only production
source is NLR and the admitted wire profile is HTTPS plus JSON. Optional XML,
CSV, GeoJSON document output, bulk files, write operations, restricted data,
and hosted/distributed coordination are not hidden core requirements.

## Required Gate For Every Version

Every version inherits:

```bash
scripts/checks.sh
cargo deny check
cargo audit
```

It also requires affected MSRV/stable/platform/package checks, current source
evidence when source behavior changes, updated claims, green GitHub Actions
and CodeQL, no unresolved high/critical finding, and a versioned maintainer
pentest report with `Status: PASS`.

Official network execution is prohibited through `v0.36.0`. Starting at
`v0.37.0`, live tests are opt-in, use dedicated credentials, obey the reviewed
operation profile, and never claim that a process-local limiter controls other
processes, callers, keys, or IP-wide traffic.

After each implementation:

1. Commit freely during development. When the version and local gates are
   complete, commit the `AWAITING PENTEST` state and ask the maintainer to
   pentest that exact `HEAD`.
2. Record a clean result, or fix findings while keeping the same report
   current and asking the maintainer to retest, until it says `PASS`.
3. Commit the `PASS` report with all current fixes and release metadata.
4. Wait for the maintainer to report the GitHub result.
5. If GitHub has an issue, fix it, update the same report, commit again, and
   wait for the maintainer's next GitHub result.
6. If GitHub is green, tag only after the maintainer explicitly requests it.

The `unitedstates` facade version equals the repository tag. Other crates use
independent versions and are published only when changed, except that every
crate present at `v1.0.0` converges to `1.0.0`.

## Pre-1.0 Capability Traceability

| Shared capability | First real consumer | Reason it is shared |
| --- | --- | --- |
| Validated IDs, versions, limits, ledgers | every source | stable bounded public contracts |
| Canonical relative path/query plan | NLR stations and PVWatts | all selected APIs are request/query driven |
| Closed production origins and late credential slots | NLR `developer.nlr.gov` | prevents SSRF and key leakage |
| Bounded JSON lexer/decoder/owned values | every admitted 1.0 NLR operation | NLR’s stable profile is JSON |
| Percent/query grammar and repeated-value encoding | NLR filters; later openFDA/Census/SAM | source crates need different grammars over one safe encoder |
| Latitude/longitude, dates, units, finite scientific values | NLR; later NASA/NOAA | common validated domain primitives |
| Typed JSON model contracts | NLR optional/null/unknown fields and fixed arrays | every selected JSON source needs exact semantic mapping |
| Source policy, evidence, provenance, status profile | every source | operation truth must be reviewable and executable |
| Sans-I/O transport and bounded response body | every live source | applications choose HTTP/TLS implementation |
| Local retry/rate/cache policy | NLR direct SDK | useful direct-client behavior with honest scope |

The following are explicitly not pre-1.0 shared foundations:

- XML request or response codecs: no admitted NLR operation needs them.
- CSV or GeoJSON document codecs: optional NLR representations are deferred.
- A universal U.S. government API key: the selected sources use different
  issuers, placements, quotas, and anonymous modes.
- Credential-entitlement partitions or rebinding loops: the NLR key controls
  quota, not access to different result entitlements.
- Distributed quota authorities, persistent authenticated caches, fill
  fencing, or cross-process coalescing: those belong to a later hosted or
  restricted-source admission.
- Generic change-feed checkpoints: NLR `last-updated` is a freshness
  observation, not a change feed.

## v0.1.0 - Repository Foundation

Goal: establish a secure, publishable, dependency-free workspace.

Deliverables:

- `unitedstates-core` and the `unitedstates` facade with complete metadata.
- Pinned stable Rust, declared MSRV, dual licensing, CI, policies, and plans.
- Dependency-free `no_std` boundaries and no source/network claims.
- Checksum-locked offline RFC references for source-neutral standards and a
  regression check rejecting copied source-project identities.

Verification:

- Full inherited gate, package dry runs, README/project identity, RFC
  integrity, manifest, cross-platform crate-name, and file-size checks.

Exit criteria:

- Foundation claims match repository evidence.
- `v0.1.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.2.0 - Identifier And Version Primitives

Goal: make source, operation, schema, policy, and upstream versions explicit.

Deliverables:

- Validated bounded IDs, non-zero versions, reviewed generated constants, and
  payload-free validation categories.
- Descriptive IDs grant no execution authority.

Verification:

- Boundary/property tests, compile-fail authority tests, MSRV `no_std` build.

Exit criteria:

- Unvalidated strings cannot become stable identifiers.
- `v0.2.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.3.0 - Bounded Scalar Types

Goal: prevent unbounded or ambiguous scalar input.

Deliverables:

- Bounded strings, sizes, counts, depths, attempts, records, and work.
- Non-cloneable checked ledgers with pre-charge and child accounting.

Verification:

- Overflow, one-past-limit, exhaustion, no-refund, and arbitrary-value tests.

Exit criteria:

- Every scalar has explicit valid states and checked arithmetic.
- `v0.3.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.4.0 - Error And Redaction Model

Goal: expose actionable failures without retaining secrets or upstream bodies.

Deliverables:

- Stable non-exhaustive categories, safe field paths, retry advice, opaque
  diagnostics, and redacted formatting.

Verification:

- Adversarial formatting, secret-marker snapshots, and panic-free conversion.

Exit criteria:

- Errors cannot disclose protected headers, URLs, credentials, or payloads.
- `v0.4.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.5.0 - Request Plan Core

Goal: represent a bounded request without performing I/O.

Deliverables:

- Credential-free canonical plan with method, relative path, structured query,
  typed headers, optional bounded body, and response/execution limits.
- Replayable versus one-shot body state and typed late credential slots.

Verification:

- Canonicalization and injection corpora covering duplicate keys, controls,
  encoded separators, dot segments, fragments, and forbidden headers.

Exit criteria:

- Caller input cannot choose an origin or protected header value.
- `v0.5.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.6.0 - Closed Origin Registry

Goal: make credential destinations and redirects closed policy choices.

Deliverables:

- Reviewed HTTPS production/test origins, fixed host/port, structured relative
  paths, and same-origin redirect representation.

Verification:

- SSRF corpus for schemes, authorities, user-info, ports, Unicode, encoded
  controls, downgrade, and cross-origin redirect.

Exit criteria:

- Arbitrary URLs cannot enter an authorized plan.
- `v0.6.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.7.0 - Operation Policy Types

Goal: model source rules without embedding source truth in generic code.

Deliverables:

- Publish dependency-free `unitedstates-policy`.
- Closed access/authentication, key placement, cache, retry, redirect,
  result-set, data handling, attribution, and hosted-use vocabulary.
- `PublicOpenData` for the NLR 1.0 access profile; future restricted access is
  admitted by its source, not anticipated with entitlement machinery.
- Closed local/advisory quota-scope recipes, including an opaque
  credential-pool identity that may span participating api.data.gov sources;
  raw secret bytes are never identity material.
- Local scope is separate from future coordinated deployment enforcement.

Verification:

- Exhaustive contradiction and fail-closed unknown-state tests.

Exit criteria:

- Incomplete policy cannot authorize execution.
- `v0.7.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.8.0 - Policy Manifest Format

Goal: store operation rules and evidence as deterministic reviewed data.

Deliverables:

- Bounded canonical manifest with source documents, timestamps, digests,
  reviewer, expiry, operations, exclusions, auth placement, status/media
  profiles, limits, cache/retry/data handling, and local quota guidance.
- Explicit format and capability exclusions.

Verification:

- Malformed/duplicate/unknown/missing-field corpus and deterministic roundtrip.

Exit criteria:

- Expired or incomplete evidence fails closed.
- `v0.8.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.9.0 - Provenance And Execution Capability

Goal: bind reviewed source truth to one exact operation and result.

Deliverables:

- Publish dependency-free `unitedstates-registry`.
- Opaque one-use `AuthorizedExecution<R>` binding plan, origin, credential
  slot, JSON decoder, semantic validator, result type, status profile, limits,
  policy/evidence versions, and provenance.
- Closed success, no-body, redirect, and source-error outcomes.
- Local cache identity vocabulary for public responses; no persistent trust,
  access-entitlement partition, or distributed fill claim.
- Opaque non-secret local quota-pool identity binding, separate from public
  data/cache identity and unable to claim coordination outside one limiter.
- Optional current-policy authority contract with honest offline-expiry limits.

Verification:

- Forgery, substitution, wrong-origin/status/decoder, expiry, rollback,
  kill-switch, and version-skew tests.

Exit criteria:

- Downstream code cannot assemble or alter execution authority.
- `v0.9.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.10.0 - `no_std` Transport Contract

Goal: define the trusted HTTP boundary without implementing HTTP or TLS.

Deliverables:

- Publish `unitedstates-http`.
- Closed request head, normalized response metadata, body-byte definition,
  redirect handoff, and transport capability declaration.

Verification:

- Hostile adapter tests for origins, framing, status, header limits, and
  under-reported body bytes.

Exit criteria:

- Source crates remain independent of a concrete client.
- `v0.10.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.11.0 - Blocking And Async Transport Traits

Goal: support synchronous and asynchronous callers with semantic parity.

Deliverables:

- Sans-I/O blocking/async traits, cooperative versus preemptive deadline
  declarations, cancellation state, and safe adapter error codes.

Verification:

- Compile-tested adapters and deadline/cancellation parity tests.

Exit criteria:

- No runtime, executor, socket, DNS, or TLS dependency is implied.
- `v0.11.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.12.0 - Bounded Body Pipeline

Goal: consume response bytes with exact bounded progress.

Deliverables:

- Wire/decoded byte ledgers, chunk and allocation budgets, pause/resume, and
  provisional-to-complete response state.

Verification:

- Split-point, empty-chunk, stalled-source, cancellation, and over-limit tests.

Exit criteria:

- Partial or over-budget data cannot become a complete result.
- `v0.12.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.13.0 - JSON Lexical Layer

Goal: tokenize the admitted JSON profile incrementally and strictly.

Deliverables:

- Publish `unitedstates-codec-json`.
- UTF-8, string/escape, number, token, depth, and work limits.

Verification:

- Every byte split, malformed UTF-8/escape/number, and exhaustion corpus.

Exit criteria:

- Lexer progress is bounded and deterministic.
- `v0.13.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.14.0 - JSON Structural Layer

Goal: turn tokens into bounded borrowed events.

Deliverables:

- Object/array state, decoded-name duplicate rejection, event visitor,
  pause/resume, and private completion witness.

Verification:

- Nested, duplicate, chunked, early-stop, and witness-substitution tests.

Exit criteria:

- Only complete valid JSON can reach semantic validation.
- `v0.14.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.15.0 - JSON Owned Values

Goal: provide an optional bounded `alloc` representation.

Deliverables:

- Owned strings, numbers, arrays, objects, projections, and explicit allocation
  accounting; borrowed mode remains allocation-free.

Verification:

- Allocation, collection, projection, and borrowed/owned equivalence tests.

Exit criteria:

- Owned decoding cannot bypass wire, decoded, work, or allocation budgets.
- `v0.15.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.16.0 - Canonical Query Encoding

Goal: safely encode the query shapes used by U.S. APIs.

Deliverables:

- Percent encoding over structured name/value components, ordered/repeated
  values, booleans, dates, numbers, and source-owned parameter names.
- No raw query fragment or pre-encoded escape hatch.

Verification:

- RFC edge cases, spaces, plus signs, percent signs, Unicode, duplicates,
  ordering, and roundtrip goldens from NLR plus future source shapes.

Exit criteria:

- NLR filters and PVWatts parameters are representable without string-built
  URLs, while openFDA/Census grammars can later layer source types over it.
- `v0.16.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.17.0 - Geospatial And Scientific Scalars

Goal: make shared location and scientific inputs unambiguous.

Deliverables:

- Latitude, longitude, radius/distance, finite decimal, unit, ZIP code, date,
  and fixed-month-vector primitives.
- Source-specific meanings remain in source crates.

Verification:

- Poles, antimeridian, negative zero, non-finite, precision, unit, date, and
  serialization goldens.

Exit criteria:

- NLR inputs cannot carry non-finite or out-of-domain values.
- `v0.17.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.18.0 - Typed JSON Model Contracts

Goal: map valid JSON into exact source models without conflating syntax and
semantics.

Deliverables:

- Reusable bounded field-presence (`Absent`/`Null`/`Value`), open-enum,
  fixed-array, projection, field-path, and semantic-validation contracts.
- Source crates still own field names, meanings, units, and accepted
  combinations.

Verification:

- Missing/null/value, unknown field/enum, fixed-length, projection, and
  semantic-error-path tests.

Exit criteria:

- NLR models can express upstream drift and exact invariants without raw JSON
  or source semantics entering the codec.
- `v0.18.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.19.0 - Deterministic Testkit

Goal: provide safe offline evidence and adversarial test utilities.

Deliverables:

- Publish `unitedstates-testkit`.
- Synthetic response builders, split streams, hostile transports, deterministic
  clocks, quota/header fixtures, and retention-aware corpus metadata.

Verification:

- Testkit cannot mint registry authority or record credentials.

Exit criteria:

- All pre-live behavior is reproducible offline.
- `v0.19.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.20.0 - Source Onboarding Compiler

Goal: compile reviewed manifests and schemas into deterministic Rust.

Deliverables:

- Publish `unitedstates-schema`.
- Offline parser/generator, reproducible output, origin/operation inventory,
  compatibility report, and generated-file splitting.

Verification:

- Hostile manifest/schema corpus, reproducibility, and no-network build.

Exit criteria:

- Source truth enters the registry only through reviewed deterministic output.
- `v0.20.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.21.0 - Synthetic Conformance Source

Goal: prove the complete generic path before contacting an official API.

Deliverables:

- Publish `unitedstates-executor` and `unitedstates-conformance`.
- One-use execution from authorization through local quota check, late
  credential materialization, transport, body/JSON decode, semantic validation,
  final provenance, and optional in-process cache.
- No official host or credential accepted by the conformance source.

Verification:

- Full blocking/async state matrix, forged witness attacks, cancellation,
  ambiguous delivery, cache hit/miss, and secret snapshots.

Exit criteria:

- Generic code contains no NLR semantics and performs no official request.
- `v0.21.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.22.0 - NLR Source Dossier

Goal: freeze evidence for the first production source.

Deliverables:

- Publish `unitedstates-nlr`.
- Current `developer.nlr.gov` origins and evidence for Alternative Fuel
  Stations v1 and PVWatts v8.
- Stable JSON/GET scope and explicit exclusions: old NREL host; XML, CSV,
  GeoJSON document mode; route POST; electric-networks; CSV-only
  ev-charging-units; Canada/all-country modes; PVWatts hourly, `file_id`, and
  JSONP; and unreviewed API families.

Verification:

- Manual evidence review, digest/expiry checks, and operation inventory match
  [API_CAPABILITY_MATRIX.md](API_CAPABILITY_MATRIX.md).

Exit criteria:

- Every planned NLR operation has current official evidence and a bounded JSON
  contract.
- `v0.22.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.23.0 - NLR Origin And Credential Plan

Goal: bind NLR requests to the correct host and api.data.gov key behavior.

Deliverables:

- `developer.nlr.gov` production origin, late `X-Api-Key` injection, explicit
  `DEMO_KEY` test policy, and secret-free canonical identity.
- Public-data cache identity independent of key identity; the provider supplies
  an opaque non-secret api.data.gov quota-pool identity for local accounting
  without hashing or exposing the key.

Verification:

- Old-host, redirect, query-key, Basic-auth, log, cache-key, and error leakage
  attacks; rotation does not alter data access class.

Exit criteria:

- A key reaches only the reviewed NLR origin and never provenance/cache output.
- `v0.23.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.24.0 - NLR Station-By-ID Operation

Goal: implement the smallest Alternative Fuel Stations JSON operation.

Deliverables:

- Validated station ID request and strictly typed response envelope.

Verification:

- Official-shape fixtures, absent/null/unknown field behavior, errors, limits.

Exit criteria:

- One real NLR operation is complete offline.
- `v0.24.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.25.0 - NLR Station Field Metadata

Goal: classify the station fields used by the stable slice.

Deliverables:

- Field presence/nullability/type/unit metadata and forward-compatible unknown
  field policy.

Verification:

- Schema drift, optionality, enum, and unit fixtures.

Exit criteria:

- Model claims do not exceed official evidence.
- `v0.25.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.26.0 - NLR Station Filter Builder

Goal: provide typed all-stations filtering without raw query strings.

Deliverables:

- Reviewed fuel, state, status, access, network, date, and result-limit filters
  supported by the admitted endpoint.

Verification:

- Combination, repeated-value, canonical order, unsupported-filter, and budget
  tests.

Exit criteria:

- The supported filter subset is expressive and injection resistant.
- `v0.26.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.27.0 - NLR Location And Nearest-Station Queries

Goal: support location lookup with explicit geometry.

Deliverables:

- Nearest request using validated coordinate/location/radius inputs and
  distance-bearing results.

Verification:

- Pole, antimeridian, ZIP/location, radius, units, and deterministic encoding.

Exit criteria:

- Geospatial inputs and outputs have documented units and bounds.
- `v0.27.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.28.0 - NLR Result Set And Collection Budgets

Goal: bound the single-response collection behavior NLR actually exposes.

Deliverables:

- Typed `limit=0..200` mode and explicit opt-in `all` mode.
- `all` is streamed under caller-visible total record, wire/decoded byte,
  allocation, and work ceilings; it is not represented as pagination and has
  no resume token.

Verification:

- Zero/maximum/one-past limit, empty/short/exact/over-budget collection,
  cancellation, count mismatch, and huge `all` response fixtures.

Exit criteria:

- A potentially large NLR response remains bounded without inventing offset
  or continuation semantics.
- `v0.28.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.29.0 - NLR Response Profiles

Goal: bind status and error behavior to each NLR operation.

Deliverables:

- Accepted media type, success envelope, no-body behavior, redirects, and
  bounded source-error decoding.

Verification:

- Every relevant status/media mismatch and malicious error payload.

Exit criteria:

- Unknown outcomes cannot select a success decoder.
- `v0.29.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.30.0 - NLR Documentation Snapshot Tooling

Goal: make upstream review reproducible without build-time network.

Deliverables:

- Explicit fetch/update tool, digests, retrieval metadata, semantic diff, and
  review workflow for selected documentation/schema inputs.

Verification:

- Offline build, changed/partial/rollback snapshot tests, retention checks.

Exit criteria:

- Generated code never depends on an implicit live document.
- `v0.30.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.31.0 - NLR Station Summary And Detail Slice

Goal: complete common station identification and location models.

Deliverables:

- Stable summary/detail structs with provenance and unknown-field policy.

Verification:

- Sparse/full/forward-added field fixtures and public API examples.

Exit criteria:

- The common station model is usable without exposing raw JSON.
- `v0.31.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.32.0 - NLR EV Charging Detail Slice

Goal: add the useful electric-charging subset.

Deliverables:

- Connector, charging level, network, port/count, availability/status, and
  reviewed related fields.

Verification:

- Unknown enums, inconsistent counts, nullability, and unit/domain tests.

Exit criteria:

- EV detail is typed without claiming real-time availability beyond evidence.
- `v0.32.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.33.0 - NLR Nearest And Filtered Collection Slice

Goal: stabilize collection-level station workflows.

Deliverables:

- Streaming/owned collection drivers, summaries, completion/truncation
  outcomes, and per-record provenance.

Verification:

- Total-record/body/work budgets, cancellation, partial-result, ordering, and
  duplicate record scenarios.

Exit criteria:

- Collection convenience cannot hide truncation or resource exhaustion.
- `v0.33.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.34.0 - NLR PVWatts v8 Slice

Goal: implement the reviewed PVWatts v8 JSON calculator.

Deliverables:

- Typed system/latitude-longitude/loss inputs, canonical GET query,
  monthly-only output/errors, units, warnings, and 12-month arrays.
- Explicit exclusion of `file_id` (which couples to Solar Dataset Query v2),
  hourly output, address input, and JSONP callback.
- Redaction of the response `inputs.api_key` echo.

Verification:

- Required/conditional fields, lat/lon pairing, ranges, non-finite values,
  monthly lengths, rejected hourly/`file_id`/callback parameters,
  warning/error envelopes, and secret echo snapshots.

Exit criteria:

- PVWatts JSON results are typed and cannot leak the API key through echoed
  input data.
- `v0.34.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.35.0 - NLR Stable Slice Completeness Audit

Goal: reconcile code, dossier, fixtures, and documentation.

Deliverables:

- Operation/field/status/limit matrix, exclusion list, and unsupported API for
  every NLR stable-slice omission.

Verification:

- Matrix-to-registry/schema/docs automated checks.

Exit criteria:

- No implemented or documented NLR capability is untracked.
- `v0.35.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.36.0 - NLR Freshness Observation

Goal: model NLR update metadata honestly.

Deliverables:

- Typed `last-updated` request/result and freshness provenance.
- Explicit statement that it is not a change feed, cursor, or resume token.

Verification:

- Missing/malformed/future time and false-checkpoint API tests.

Exit criteria:

- Freshness metadata cannot be used as a lossless incremental-ingestion claim.
- `v0.36.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.37.0 - Rate Limit And Retry Enforcement

Goal: admit opt-in live NLR execution with honest direct-client controls.

Deliverables:

- Process-local source-reviewed quota-pool limiter, api.data.gov documented
  rolling/default and demo-key limits,
  caller tightening, `429`/`Retry-After`, bounded backoff/jitter, deadline, and
  retry classification.
- Documentation that enforcement covers only executions sharing that limiter.

Verification:

- Deterministic clock tests, concurrent local clients, cancellation, retry
  exhaustion, and a gated low-volume live smoke test.

Exit criteria:

- The SDK may share an opaque api.data.gov key-pool bucket across source
  clients using one limiter, but never describes it as complete key-, IP-, or
  deployment-wide accounting.
- `v0.37.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.38.0 - Local Cache And Freshness Contracts

Goal: provide useful caching proportionate to public NLR reads.

Deliverables:

- Explicit `NoCache` default and optional bounded in-process public-response
  cache with canonical identity, policy ceiling, monotonic age, eviction,
  invalidation, and complete-result-only insertion.
- Persistent/shared/authenticated caches and request coalescing remain
  post-1.0 capabilities.

Verification:

- Hit/miss/stale/expiry/collision/eviction/restart/secret-exclusion tests.

Exit criteria:

- Cache use cannot broaden policy or claim cross-process durability.
- `v0.38.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.39.0 - Public API Ergonomics Review

Goal: make safe NLR use concise without weakening explicitness.

Deliverables:

- Builders, examples, errors, collection completion/truncation outcomes,
  feature names, and
  compile-tested common workflows.

Verification:

- Fresh-user review and compile tests for minimal/default/alloc configurations.

Exit criteria:

- Normal users do not need raw URL, JSON, or header manipulation.
- `v0.39.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.40.0 - Cross-Platform Baseline

Goal: verify portable library boundaries.

Deliverables:

- Linux, Windows, macOS, BSD, Android, and iOS compile matrix where supported;
  no implicit environment/filesystem/socket/clock assumptions.

Verification:

- Target checks and feature-isolation builds.

Exit criteria:

- Platform claims are limited to tested library behavior.
- `v0.40.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.41.0 - Performance And Memory Budgets

Goal: establish measurable resource envelopes.

Deliverables:

- Benchmarks for request encoding, JSON, NLR models, large collection
  streaming, executor, and
  local cache with declared input sizes.

Verification:

- Regression thresholds and constrained-memory runs.

Exit criteria:

- Performance claims identify configuration, dataset, and budget.
- `v0.41.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.42.0 - Parser Fuzz And Mutation Baseline

Goal: continuously attack admitted parsers and models.

Deliverables:

- JSON, query, HTTP metadata, NLR envelope/model/collection, and manifest
  targets with seed provenance and retention metadata.

Verification:

- Time-bounded campaigns, minimized regressions, sanitizer runs where
  supported.

Exit criteria:

- Every admitted input boundary has an adversarial target.
- `v0.42.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.43.0 - Documentation And Source Evidence Audit

Goal: align public claims with current contracts.

Deliverables:

- Link/digest/expiry review, capability matrix reconciliation, examples, and
  explicit limitations.

Verification:

- Documentation links, snippets, manifest claims, and API inventory checks.

Exit criteria:

- No stale NREL hostname or unadmitted format/operation claim remains.
- `v0.43.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.44.0 - Independent Package Boundary Audit

Goal: prove the crate graph and feature graph remain modular.

Deliverables:

- Dependency/DAG audit, isolated package builds, facade-only wiring proof, and
  generated/handwritten file-size enforcement.

Verification:

- Every crate packaged alone under every supported tier.

Exit criteria:

- Source crates do not depend on executor, registry, facade, or one another.
- `v0.44.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.45.0 - Executor Authority Integration Audit

Goal: attack the one-use authorization and completion chain.

Deliverables:

- Review exact plan/origin/header/status/decoder/validator/output binding,
  attempt identity, cancellation, and final provenance ownership.

Verification:

- Hostile downstream crates and cross-operation/cross-attempt substitution
  compile/runtime tests.

Exit criteria:

- Generic execution cannot be paired with caller-selected semantics.
- `v0.45.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.46.0 - Credential Lifecycle Audit

Goal: minimize NLR API-key lifetime and disclosure.

Deliverables:

- Late one-use materialization, immediate header injection, rotation, retry
  reacquisition, cancellation, and redaction review.
- No entitlement partition or protected-cache reauthorization state machine.

Verification:

- Leak snapshots across errors, debug, provenance, query, cache, fixtures, and
  PVWatts echoed inputs.

Exit criteria:

- Secret bytes exist only at the provider-to-transport handoff.
- `v0.46.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.47.0 - Body Replay Redirect And Retry State Machine

Goal: make resubmission decisions explicit.

Deliverables:

- Replayability, ambiguous-send, same-origin redirect, retry budget, and
  credential reinjection rules for the admitted GET-only NLR scope.

Verification:

- Redirect loops/downgrade/cross-origin, partial send, timeout, and status
  matrix.

Exit criteria:

- No ambiguous or cross-origin request is silently replayed with a key.
- `v0.47.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.48.0 - Local Quota Cache And Kill-Switch Integration

Goal: verify ordering among direct-client controls.

Deliverables:

- Cache-before-local-quota behavior, policy recheck before I/O and after waits,
  kill switch, retry charging, and cancellation.

Verification:

- Deterministic interleavings and unavailable clock/provider/cache tests.

Exit criteria:

- Cache hits spend no request quota and waits cannot bypass current policy.
- `v0.48.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.49.0 - Payload-Free SDK Diagnostics

Goal: make production diagnosis useful without retaining data or secrets.

Deliverables:

- Closed event codes, opaque correlation IDs, counts/timings, opt-in sink, and
  source/operation classification.

Verification:

- Marker snapshots and hostile sink behavior.

Exit criteria:

- Diagnostics contain neither response fields nor credential material.
- `v0.49.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.50.0 - Security Architecture Review

Goal: independently review the complete pre-1.0 design.

Deliverables:

- Threat/control traceability, unsafe/dependency review, source-specific
  attack surface, residual risk, and remediation plan.

Verification:

- Independent review plus maintainer pentest of representative end-to-end
  paths.

Exit criteria:

- No high/critical issue and no architecture claim exceeds implementation.
- `v0.50.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.51.0 - Alternate Media And Bulk Admission Boundary

Goal: prove that unused formats did not leak into the 1.0 core.

Deliverables:

- Decision record deferring NLR XML, CSV, GeoJSON document output, route POST,
  archives, and bulk files.
- Reusable checklist for a later named operation to admit a codec/format crate.

Verification:

- Feature, dependency, docs, registry, and fuzz-target audit for hidden format
  support or claims.

Exit criteria:

- Only JSON is a mandatory 1.0 response codec.
- `v0.51.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.52.0 - Consumable Resource Ledger Audit

Goal: verify all attacker-controlled work is bounded.

Deliverables:

- Wire/decoded bytes, allocations, work, depth, headers, query components,
  records, attempts, redirects, cache entries, and diagnostic budgets.

Verification:

- Exhaustion precedence, checked arithmetic, cancellation, and no-refund tests.

Exit criteria:

- No admitted path has an unbounded collect, parse, retry, record, or cache
  loop.
- `v0.52.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.53.0 - External Boundary Trust And Conformance Audit

Goal: state and test what caller-supplied components can invalidate.

Deliverables:

- Trust matrix for transport, clock, credential provider, local cache,
  allocator, event sink, and policy authority.

Verification:

- Lying, stalling, panicking, malformed, and cancellation-hostile doubles.

Exit criteria:

- Traits are not presented as sandboxes or remote coordination guarantees.
- `v0.53.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.54.0 - Evidence-Bound Capability Stabilization Audit

Goal: stabilize registry authority and provenance.

Deliverables:

- Evidence expiry/rollback, kill switch, exact operation binding, capability
  non-forgeability, and result provenance review.

Verification:

- Stale/offline/version-skew and hostile downstream scenarios.

Exit criteria:

- Every production result is traceable to one current reviewed operation.
- `v0.54.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.55.0 - Capability-Tier Isolation

Goal: prove default, `alloc`, `std`, transport, live-test, and NLR tiers.

Deliverables:

- Explicit feature matrix and additive feature rules; no silent network,
  credential, filesystem, clock, telemetry, or cache activation.

Verification:

- Powerset/representative feature builds and package metadata inspection.

Exit criteria:

- Enabling one tier cannot silently activate another.
- `v0.55.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.56.0 - Sans-I/O And Low-Bandwidth Qualification

Goal: validate streaming and caller-controlled I/O on constrained systems.

Deliverables:

- Small-buffer examples, pause/resume, bounded owned alternatives, partial
  collection and cancellation guidance.

Verification:

- Tiny chunk/buffer tests and compile checks without `std`.

Exit criteria:

- Usability does not require collecting an entire response.
- `v0.56.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.57.0 - Orchestration Ergonomics

Goal: simplify client assembly while preserving explicit authority.

Deliverables:

- Typed builders for transport, clock, credentials, optional limiter/cache,
  policy authority, and limits with actionable configuration errors.

Verification:

- Compile tests for common and intentionally invalid configurations.

Exit criteria:

- Convenience cannot construct a less constrained execution.
- `v0.57.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.58.0 - Adapter And Binding Admission Boundary

Goal: freeze what 1.0 does not implement.

Deliverables:

- Documented transport/TLS trust requirements and explicit deferral of
  third-party adapters, unsafe FFI, environment credential loading, and hosted
  services unless separately admitted.

Verification:

- Dependency, unsafe, feature, docs, and examples audit.

Exit criteria:

- The facade does not imply batteries-included networking.
- `v0.58.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.59.0 - Pre-Legal Completeness Gate

Goal: prove all planned technical work is represented.

Deliverables:

- Crate/API/operation/model/status/limit/feature/test/document inventory.

Verification:

- Automated matrix checks and unresolved-item review.

Exit criteria:

- No technical “later” item remains inside the frozen 1.0 scope.
- `v0.59.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.60.0 - Legal And Privacy Readiness

Goal: validate lawful handling for the exact public NLR slice.

Deliverables:

- Terms/licence/attribution/redistribution/retention review, data
  classification, fixture legality, privacy notices, and responsible-use text.

Verification:

- Counsel/maintainer checklist and data-flow trace.

Exit criteria:

- Every project-owned data path follows the reviewed handling profile.
- `v0.60.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.70.0 - Reliability And Recovery

Goal: verify deterministic recovery for the direct SDK.

Deliverables:

- Process restart, cache loss, clock reset, provider rotation, collection
  interruption, and upstream outage behavior.

Verification:

- Fault injection and restart tests without persistent-authority claims.

Exit criteria:

- Recovery either safely resumes from caller-owned inputs or fails explicitly.
- `v0.70.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.80.0 - Limited Public Beta

Goal: gather bounded real-world feedback without expanding scope.

Deliverables:

- Beta support policy, opt-in telemetry-free feedback, known limitations, and
  compatibility tracking.

Verification:

- Live NLR smoke matrix and issue triage.

Exit criteria:

- Beta findings are resolved or explicitly release-blocking.
- `v0.80.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.90.0 - Release Candidate One

Goal: freeze the intended 1.0 behavior.

Deliverables:

- API/schema/feature/operation freeze, migration notes, and complete release
  evidence.

Verification:

- Clean-room consumer builds and full end-to-end gates.

Exit criteria:

- Only release-blocking corrections may change the surface.
- `v0.90.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.91.0 - Deployment Topology Honesty Audit

Goal: verify direct-SDK guarantees remain honest across deployments.

Deliverables:

- Tests and docs for independent processes, independent keys, shared keys,
  shared egress IPs, restarts, and clock differences.
- Explicit absence of cross-process quota/cache coordination.

Verification:

- Multi-process simulations show local limits do not claim global enforcement.

Exit criteria:

- Deployment-wide controls are clearly assigned to the application or future
  hosted-service layer.
- `v0.91.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.92.0 - Final JSON Fuzz Campaign

Goal: independently harden the frozen JSON path.

Deliverables:

- Final lexer, structure, owned, projection, NLR envelope, and error-model
  corpora with retained regression cases.

Verification:

- Extended sanitizer/fuzzer campaigns on supported platforms.

Exit criteria:

- No unresolved crash, panic, hang, over-budget acceptance, or semantic bypass.
- `v0.92.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.93.0 - Final Query Geospatial And Model Fuzz Campaign

Goal: harden the non-JSON data boundaries actually shipped.

Deliverables:

- Query percent encoding, structured grammar, geospatial/scientific scalars,
  typed JSON mapping, HTTP metadata, and NLR model/collection targets.

Verification:

- Mutation/property campaigns including Unicode, numeric extremes, poles,
  antimeridian, repeated values, fixed arrays, huge collections, and secret
  markers.

Exit criteria:

- Frozen request/model surfaces have no unresolved adversarial defect.
- `v0.93.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.94.0 - Cross-Platform Resource Qualification

Goal: confirm frozen resource behavior on supported targets.

Deliverables:

- Stack/heap/code-size/latency evidence across representative desktop, mobile,
  embedded-like, and `no_std` builds.

Verification:

- Repeatable constrained-resource matrix.

Exit criteria:

- Platform and resource claims match measured configurations.
- `v0.94.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.95.0 - Release Candidate Remediation

Goal: close findings from independent assessment and RC use.

Deliverables:

- Minimal fixes, regression tests, compatibility analysis, and updated reports.

Verification:

- Full gate plus assessor/maintainer retest.

Exit criteria:

- No unresolved release blocker.
- `v0.95.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.96.0 - Supply-Chain And Release Provenance Audit

Goal: prove release inputs and artifacts are controlled.

Deliverables:

- Pinned tool/action review, dependency-free verification, reproducible
  packages, SBOM/provenance, and publication rehearsal.

Verification:

- Clean-environment rebuild and artifact comparison.

Exit criteria:

- Every published artifact traces to reviewed source and tooling.
- `v0.96.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.97.0 - Final Source Legal And Privacy Refresh

Goal: refresh volatile NLR facts immediately before freeze.

Deliverables:

- Re-review host, API-key rules, quotas, operations, schemas, terms, licence,
  attribution, data classification, and exclusions.

Verification:

- Official-source evidence and manifest diff.

Exit criteria:

- No expired or materially changed source fact remains unresolved.
- `v0.97.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.98.0 - Public Surface And Scope Freeze

Goal: freeze the exact 1.0 package/API/capability set.

Deliverables:

- Public item, feature, crate, operation, format, MSRV, and guarantee inventory.
- Confirm XML/CSV/GeoJSON document mode, writes, restricted data, distributed
  coordination, and post-1.0 sources are absent.

Verification:

- Semver/API diff and capability-matrix comparison.

Exit criteria:

- Every public item is intentional, documented, tested, and supported.
- `v0.98.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v0.99.0 - Final Acceptance

Goal: obtain final technical, security, legal, and operational acceptance.

Deliverables:

- Signed checklist, current reports, green CI, publication plan, rollback and
  disclosure readiness.

Verification:

- Full gate from clean checkout and release rehearsal.

Exit criteria:

- All owners accept the exact release candidate.
- `v0.99.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v1.0.0-rc.1 - Exact Production Candidate

Goal: exercise artifacts versioned exactly as 1.0.

Deliverables:

- Exact `1.0.0` crate versions in candidate packaging, immutable evidence, and
  no planned API changes.

Verification:

- Consumer installation, docs.rs/package simulation, live smoke, and full
  release gate.

Exit criteria:

- Only release-blocking remediation may follow.
- `v1.0.0-rc.1 implementation stop reached. Run the maintainer pentest and update the repository report.`

## v1.0.0 - Serious Production Release

Goal: release a production-ready direct Rust SDK for the documented NLR scope.

Deliverables:

- Stable `unitedstates-core`, `unitedstates-policy`, `unitedstates-registry`,
  `unitedstates-http`, `unitedstates-codec-json`, `unitedstates-testkit`,
  `unitedstates-schema`, `unitedstates-executor`,
  `unitedstates-conformance`, `unitedstates-nlr`, and facade.
- JSON-only Alternative Fuel Stations and PVWatts v8 operation/model matrix.
- Current policy, evidence, provenance, local rate/retry/cache behavior,
  documentation, release evidence, and migration policy.

Verification:

- Exact equivalence to the accepted candidate, source status review, package
  rehearsal, full inherited gate, and final pentest.

Exit criteria:

- Every production guarantee is evidence-backed and no blocker exists.
- `v1.0.0 implementation stop reached. Run the maintainer pentest and update the repository report.`

## Post-1.0 Source Tracks

Each source first stabilizes on its own `unitedstates-<source>` `0.x` line. The
facade adds it only after that crate reaches its documented stable scope.

| Facade | Source crate | Initial stable scope |
| --- | --- | --- |
| `1.1.0` | `unitedstates-openfda` | read-only recall/adverse-event/device/food search and count over the documented query grammar |
| `1.2.0` | `unitedstates-nasa` | active APOD and NeoWs; archived Mars Rover/Earth excluded |
| `1.3.0` | `unitedstates-census` | discovery plus typed ACS/Decennial variables/geographies and checked 2D JSON rows |
| `1.4.0` | `unitedstates-regulations` | read-only documents, dockets, and comments |
| `1.5.0` | `unitedstates-sam` | public/revealed Contract Awards JSON search within account and record-window constraints |
| `1.6.0` | `unitedstates-noaa` | NWS point-to-grid JSON forecast resolution |

The authentication model is source-specific:

- NLR and NASA use api.data.gov-issued keys for selected endpoints.
- openFDA has keyed and unkeyed modes with different quotas.
- Census uses its own `key` query parameter.
- Regulations.gov uses an api.data.gov key and separate comment-activation
  rules.
- SAM.gov uses a SAM.gov account key and account-dependent access.
- NWS currently requires an identifying `User-Agent`; NCEI CDO uses its own
  `token` header.

Separate later admissions are mandatory for Regulations.gov comment
submission and file uploads; SAM unrevealed/CUI/role-gated data, async extracts,
and legacy FPDS/XML; NOAA NCEI, NetCDF, GRIB, OPeNDAP, radar, oceanographic, or
bulk data; archived NASA APIs; and every new media codec. A write admission
must add idempotency, delivery ambiguity, PII, terms/activation, and audit
controls. A restricted-data admission may add entitlement isolation then,
rather than forcing it into the public NLR core.

Hosted service work also begins only after an explicit post-1.0 admission. Its
own crates and threat model must cover tenant isolation, deployment-wide
quota authority, persistent authenticated storage, request coalescing/fencing,
credential encryption, abuse controls, and operational recovery.
