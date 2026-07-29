# United States Implementation Plan

Status: architecture baseline
Current repository milestone: `v0.1.0`
Next implementation milestone: `v0.2.0`

The per-version authority is [RELEASE_PLAN.md](RELEASE_PLAN.md). The
source-to-architecture trace is
[API_CAPABILITY_MATRIX.md](API_CAPABILITY_MATRIX.md). If a proposed shared
abstraction cannot be traced to that matrix or a security boundary, it does not
enter the pre-1.0 core.

## 1. Product Boundary

`unitedstates` 1.0 is a direct, sans-I/O Rust SDK for a reviewed NLR JSON
slice. It is not a universal government gateway and does not implement HTTP,
TLS, DNS, sockets, a hosted service, or every representation an upstream can
return.

The stable production source scope is:

- NLR Alternative Fuel Stations v1: station-by-ID, all/filtered stations,
  nearest stations, and last-updated;
- NLR PVWatts v8;
- HTTPS origin `developer.nlr.gov`;
- JSON GET responses;
- late `X-Api-Key` injection;
- caller-supplied transport and clocks;
- bounded local retry/rate behavior and optional in-process public cache.

Explicit 1.0 exclusions:

- retired `developer.nrel.gov`;
- NLR XML, CSV, GeoJSON document mode, and route POST;
- generic checkpoint/change-feed support;
- persistent/shared authenticated caches, cache-fill leases, and
  cross-process coalescing;
- deployment-wide quota enforcement;
- credential-dependent data entitlement;
- openFDA, NASA, Census, Regulations.gov, SAM.gov, and NOAA production
  integrations.

Those exclusions are design boundaries, not unfinished hidden requirements.

## 2. Engineering Rules

### 2.1 Rust and dependencies

- Edition 2024, Rust `1.90.0` MSRV through pinned stable.
- No third-party runtime, development, or build dependencies in project
  manifests; first-party workspace dependencies only.
- `#![forbid(unsafe_code)]` everywhere.
- `no_std` by default for facade, core, policy, registry, HTTP, executor,
  codec, conformance, and source crates.
- `alloc` is explicit; `std` is reserved for focused tools and caller adapters.
- If a safe requirement genuinely needs a dependency or unsafe FFI,
  implementation stops for an explicit admission decision.

### 2.2 Modularity

- One agency/upstream platform per source crate.
- Source and conformance crates depend only on the shared structural crates
  they need; never on facade, registry, executor, HTTP, or another source.
- Registry depends one way on admitted source crates behind matching features.
- Executor owns orchestration, not source semantics.
- Facade owns feature alignment and re-exports, not implementations.
- Every first-party code/configuration file, generated or handwritten, stays
  under 500 lines; review splitting starts near 300 lines.
- No empty placeholder crate is created or published.

### 2.3 Bounded behavior

Every operation fixes maxima for applicable:

- request/query/header/body bytes and component counts;
- response wire/decoded bytes, chunks, nesting, strings, tokens, and work;
- allocations, arrays/objects, records/cells, and source-specific collection
  state;
- attempts, redirects, delays, and total elapsed time;
- local cache entries/bytes and diagnostic events.

Configured limits and consumable state are different types. Ledgers are
non-`Copy`, non-`Clone`, charged before work, use checked arithmetic, and are
never refunded by retry, redirect, source transition, pause/resume, or error.
Callers may tighten reviewed limits but not raise them.

There is no unbounded `collect`, response buffering, decompression, recursive
parsing, retry loop, collection loop, or cache scan.

### 2.4 Evidence and release

- Builds never fetch upstream documents.
- A source dossier records exact official references, retrieval time, digest,
  reviewer, expiry, operations, schemas, terms, and exclusions.
- Generated registry code is deterministic and reviewed.
- Every version stops for a maintainer pentest before tag/publication.

## 3. Why These Shared Capabilities Exist

The core is shaped by concrete consumers:

| Capability | 1.0 consumer | Later reuse |
| --- | --- | --- |
| relative path/query request plan | every NLR operation | all selected sources |
| typed late header credential | NLR `X-Api-Key` | SAM/NCEI use different source slots |
| bounded JSON | every NLR response | every initial later read track |
| canonical query encoding | NLR filters/PVWatts | openFDA/Census/SAM source builders |
| geospatial/scientific scalars | nearest stations/PVWatts | NASA/NWS |
| typed JSON model contracts | NLR field presence/enums/month vectors | every later JSON source |
| source policy and provenance | NLR evidence | every later source |
| sans-I/O HTTP/body contracts | NLR direct client | every live source |
| opaque local quota-pool limiter | NLR api.data.gov key | later participating sources sharing that provider |
| in-process public cache | NLR GET results | other public reads when admitted |

The following were considered and rejected as pre-1.0 foundations:

- XML lexer/parser/encoder: selected NLR operations have JSON paths and no XML
  request bodies.
- CSV codec: no stable 1.0 operation requires CSV.
- Credential entitlement partitions and rebinding: NLR’s key affects quota,
  not which public station/PVWatts data the holder may see.
- Distributed quota authority and cache fencing: the 1.0 product is a direct
  SDK, not a coordinated gateway.
- Generic checkpointing: NLR last-updated is only a freshness observation.

## 4. Planned Crates

| Crate | Default tier | Responsibility |
| --- | --- | --- |
| `unitedstates-core` | `no_std` | IDs, versions, bounded scalars/ledgers, request plan, query encoding, geo/scientific and typed model primitives |
| `unitedstates-policy` | `no_std` | source-independent policy types and evaluation |
| `unitedstates-registry` | `no_std` | generated reviewed entries, authorization, provenance |
| `unitedstates-http` | `no_std` | sans-I/O transport and bounded response contracts |
| `unitedstates-codec-json` | `no_std`; optional `alloc` | bounded JSON lexical, structural, borrowed and owned decoding |
| `unitedstates-testkit` | `no_std`/tool support | deterministic mocks, hostile inputs, corpus metadata |
| `unitedstates-schema` | `std` tool | offline dossier/schema compiler and compatibility reports |
| `unitedstates-executor` | `no_std`; optional `alloc` | generic one-use execution and optional local controls |
| `unitedstates-conformance` | `no_std` | synthetic source proving the generic path |
| `unitedstates-nlr` | `no_std`; optional `alloc` | NLR request builders, JSON models, semantic validation |
| `unitedstates` | `no_std` | feature alignment, wiring, and re-exports |

Introduction releases are recorded in `RELEASE_PLAN.md`. There is no
`unitedstates-codec-xml` or `unitedstates-codec-csv` in the 1.0 graph.

Future source crates:

```text
unitedstates-openfda
unitedstates-nasa
unitedstates-census
unitedstates-regulations
unitedstates-sam
unitedstates-noaa
```

They do not exist until their independent tracks begin.

## 5. Dependency Direction

```text
unitedstates-core
 ├─> unitedstates-policy
 ├─> unitedstates-http
 ├─> unitedstates-codec-json
 ├─> unitedstates-nlr
 └─> unitedstates-conformance

unitedstates-core + unitedstates-policy
 + unitedstates-codec-json + selected source
             └─> unitedstates-registry

unitedstates-core + unitedstates-policy + unitedstates-registry
 + unitedstates-http + unitedstates-codec-json
             └─> unitedstates-executor

selected crates ─> unitedstates facade
```

`unitedstates-schema` and `unitedstates-testkit` are tooling/test support and
do not become hidden runtime dependencies.

## 6. Core Request Model

An operation builds:

```text
Operation<Input>
  -> CanonicalPlan<Unauthenticated>
  -> registry authorization
  -> AuthorizedExecution<Result>
  -> executor
```

`CanonicalPlan` contains only:

- reviewed method;
- structured relative path;
- structured query components;
- reviewed representation headers;
- protected credential slots without secret values;
- source-reviewed caller metadata slots;
- replayable/one-shot bounded body plan;
- response and execution limits.

It cannot contain a scheme, authority, arbitrary absolute URL, raw header map,
raw query fragment, credential, or transport framing.

### 6.1 Query encoding

The shared encoder accepts validated components, not source query languages.
It implements deterministic percent encoding and source-selected ordering or
repetition. NLR owns NLR filter names and PVWatts parameters. Later:

- openFDA owns its search AST;
- Census owns variables and geography;
- Regulations.gov owns JSON:API filters;
- SAM owns award filters.

This prevents a supposedly generic query builder from becoming a stringly
escape hatch.

### 6.2 Headers

Closed categories are:

- reviewed static representation headers;
- protected late credential headers;
- executor-selected conditional cache validators if later admitted for an
  exact operation;
- bounded source-reviewed caller metadata, such as NWS `User-Agent` in its
  future source;
- transport-owned framing.

Names and values reject controls/CRLF, hop-by-hop fields, illegal duplicates,
and per-field/aggregate overflow. Credentials and operational diagnostics
never enter canonical identity or provenance.

### 6.3 Origins and redirects

Production origins are generated from dossiers. Caller input supplies no host,
scheme, port, user-info, or credential destination. Production is HTTPS.
Redirect handling is disabled unless the exact operation profile admits it;
credentials are never forwarded across origins or downgrade.

## 7. Policy, Registry, And Provenance

`unitedstates-policy` evaluates structural facts but owns no source membership.
Each operation policy covers:

- access (`PublicOpenData` for NLR 1.0);
- authentication issuer and placement;
- hosted-use status;
- data class and handling;
- cache/freshness;
- attribution and redistribution;
- retry/redirect;
- result-set behavior;
- response media/status;
- a closed local quota-scope recipe and guidance;
- evidence expiry and review requirement.

Unknown, missing, expired, contradictory, or review-required states fail
closed.

`unitedstates-registry` owns generated membership and creates opaque,
non-cloneable `AuthorizedExecution<R>`. The value binds:

- operation and canonical plan;
- environment and exact origin;
- credential/header schema;
- expected status/media profile;
- exact JSON decoder and semantic validator;
- result/provenance type;
- limits and finalization;
- policy/schema/dossier/registry versions and expiry;
- data handling and local cache/retry permissions.

Callers cannot construct it or pair it with another decoder/result type.
Success provenance is created only after complete wire, JSON, and semantic
validation. It records source, operation, schema/policy versions, retrieval
context, transformations, and cache status without response data or secrets.

An optional policy authority may provide current monotonic revocation state.
The direct SDK documents the unavoidable race between its final policy check
and a caller-owned transport call. Offline binaries cannot learn a new
revocation beyond compiled expiry.

## 8. Transport And Body Boundary

The project supplies contracts, not a concrete HTTP/TLS client. A caller
transport is trusted to:

- resolve and connect to the authorized origin;
- validate TLS and certificates;
- preserve method/path/query/header bytes;
- enforce declared deadline/cancellation mode;
- report status and headers accurately;
- deliver body bytes under the defined accounting boundary.

`BodyWireBytes` means content-coded response body bytes after TLS and HTTP
transfer framing are removed, before content decoding. It is not total network
bandwidth and excludes TLS records, protocol frames, headers, retransmission,
and framing.

The body pipeline:

- charges wire and decoded bytes before acceptance;
- caps chunks, carry, allocation, nesting, tokens, and work;
- delivers borrowed events only within synchronous callbacks;
- permits pause only after a complete event;
- treats all streamed values as provisional;
- produces a private completion witness only at valid end-of-input.

Caller transports, clocks, allocators, and event sinks are trust boundaries,
not sandboxes.

## 9. JSON Profile

The first-party JSON codec is required because every selected source has a
JSON path and the project has a zero-third-party rule.

It provides:

- strict UTF-8 and JSON number/string/escape syntax;
- bounded lexical and structural progress;
- decoded-name duplicate detection;
- depth, token, string, number, collection, allocation, and work limits;
- borrowed visitor mode;
- optional bounded owned `alloc` values;
- field projection without accepting structurally invalid skipped data;
- private attempt-bound completion.

Unknown fields are handled by source model policy: generally safely skipped
under normal syntax/work budgets for forward compatibility. Duplicate decoded
names are always rejected.

## 10. Generic Execution

The executor consumes one `AuthorizedExecution<R>` and moves through:

```text
authorize
  -> optional local public-cache lookup
  -> current policy check
  -> local rate admission
  -> late one-use credential materialization
  -> immediate injection
  -> caller transport
  -> status dispatch
  -> bounded body and JSON decode
  -> source semantic validation
  -> provenance finalization
  -> optional local cache insertion
```

Blocking and async paths have the same semantic states. Cancellation and total
deadline are propagated to every external call, but cooperative mode cannot
preempt a transport/provider that refuses to return.

### 10.1 Credentials

For NLR, a credential provider returns one-use key material only after origin,
policy, cache, and local rate decisions. The executor injects it into the
protected `X-Api-Key` slot immediately and retains nothing for retry.

Secret material:

- is not `Copy`, printable, serializable, or cloneable;
- never enters canonical plans, cache keys/values, provenance, fixtures,
  diagnostics, errors, or panic text;
- is reacquired for a permitted retry;
- is dropped on cancellation or mismatch;
- is scrubbed from NLR response fields such as PVWatts `inputs.api_key`.

NLR credentials do not select an entitlement partition. Rotation does not
require cache relookup because the data is public. A future restricted source
must design and admit its own access partition/revalidation behavior.

### 10.2 Rate and retry

The built-in limiter covers only executions sharing that limiter instance.
For api.data.gov, a credential provider supplies an opaque non-secret
`QuotaPoolId` because the documented default pool can span participating APIs
using the same key. NLR now and a later NASA client can therefore share one
local bucket when wired to the same limiter/provider. The ID is not caller
chosen, serialized, logged, or derived by hashing raw key bytes.

This still cannot promise complete enforcement for all uses of a key, egress
IP, organization, or deployment because other processes and applications are
invisible.

Retry requires:

- operation permission;
- replayable request;
- non-ambiguous prior delivery;
- retryable status/transport category;
- remaining attempt, delay, and total deadline budgets;
- fresh policy check and newly materialized credential.

`429` and valid bounded `Retry-After` guidance are handled without refunding
attempt budgets. Deployment-wide enforcement belongs to applications or a
future hosted service.

### 10.3 Local cache

`NoCache` is default. The optional built-in cache is:

- in-process and bounded;
- for finalized public read results only;
- keyed by complete canonical request, representation, environment/origin,
  and schema/policy/registry versions;
- independent of NLR key identity;
- aged with one process-local monotonic clock epoch;
- cleared/invalidated on restart, policy change, expiry, or incompatible
  version;
- unable to preserve authoritative provenance across serialization.

It does not claim persistence, cross-process safety, external store trust,
atomic fill fencing, or request coalescing. Those requirements are reserved
for a later hosted-service architecture.

## 11. NLR Implementation

### 11.1 Dossier and origin

The dossier pins current official NLR documents and treats provider name and
origin separately. Only `developer.nlr.gov` is a credential target.
`developer.nrel.gov` is a denied legacy host, not a redirect alias.

The stable SDK chooses `X-Api-Key` even if upstream also documents query or
Basic placement. One safe stable convenience path reduces leak surfaces.

### 11.2 Alternative Fuel Stations

The implementation sequence is:

1. station-by-ID envelope and common fields;
2. field metadata for presence, nullability, enum openness, and units;
3. typed filter builder;
4. nearest/location query using shared geo scalars;
5. NLR `limit=0..200` and explicit bounded `all` collection behavior;
6. status/error/media profiles;
7. station summary/detail and EV charging slices;
8. collection workflow and stop reasons;
9. last-updated as freshness metadata only.

The stable response profile is JSON. CSV and GeoJSON output are excluded.
Route planning POST is excluded because it adds request-body, replay, and
write-like delivery complexity without being needed for the initial crate.

### 11.3 PVWatts v8

PVWatts uses typed inputs for:

- system capacity and module/array types;
- losses, tilt, azimuth, optional DC/AC ratio and related reviewed fields;
- paired latitude/longitude location;
- reviewed dataset/radius and monthly-array options.

The 1.0 slice excludes address input, `file_id` (and its Solar Dataset Query v2
dependency), hourly output, and JSONP callback.

Numeric values must be finite, range-checked, and encoded canonically. Units
are explicit. Monthly arrays have exactly 12 values where the contract
requires them. Warnings remain distinct from fatal errors.

PVWatts may echo the API key in its returned `inputs`; the decoder must
recognize and discard/redact that field before an owned model, diagnostic,
fixture, provenance value, or cache entry can be created.

### 11.4 Completeness

An executable matrix maps every admitted operation to:

- method/path/query fields;
- auth slot;
- success/error status and media;
- wire/decoded/work/allocation/record limits;
- decoder and semantic validator;
- result type and provenance;
- cache/retry behavior;
- evidence and expiry;
- explicitly unsupported operations/formats/fields.

No official network request occurs until this matrix, the limiter/retry
implementation, credential path, and live-test safeguards are complete.

## 12. Future Source Architecture

Future work reuses only truly shared primitives.

### openFDA

- Source-owned AST for `search`, `sort`, `count`, `limit`, and `skip`.
- Keyed/unkeyed modes and quotas.
- Read-only public data first.
- Upstream medical warning preserved; no “drug interaction” truth claim.

### NASA

- Active APOD and NeoWs only.
- APOD media URLs remain untrusted data, never automatic fetch destinations.
- Archived Mars Rover and Earth endpoints excluded.

### Census

- Census-specific key query parameter.
- Dataset/variable/geography discovery and typed builders.
- Checked 2D JSON rows: first row headers, every later row exact-width.
- 50-variable and total cell budgets.

### Regulations.gov

- Read-only JSON:API documents/dockets/comments first.
- Comment POST is separate: current activation/terms, public-action warning,
  JSON:API payload, PII, idempotency, delivery ambiguity, submission keys, and
  presigned attachment uploads.

### SAM.gov

- Public/revealed Contract Awards JSON first.
- Account-dependent key/quota/access and synchronous record-window rules.
- Unrevealed/CUI/role-gated data, D&B field rights, async extracts, CSV, and
  legacy FPDS/XML each require later review.

### NOAA

- NWS JSON point-to-grid traversal first, with reviewed identifying
  `User-Agent`.
- Grid mappings can change, so the point lookup is part of the workflow rather
  than permanent configuration.
- NCEI CDO has its own token/quota and is a later feature.
- NetCDF, GRIB, OPeNDAP, radar, oceanographic, archives, and bulk products are
  independent parser/resource/legal admissions.

## 13. Security Verification

Mandatory adversarial classes:

- SSRF, downgrade, redirect and credential forwarding;
- CRLF/header/query injection and Unicode/percent ambiguity;
- key leakage through formatting, PVWatts echoes, errors, cache, fixtures, and
  diagnostics;
- malformed UTF-8/JSON, deep nesting, huge strings/numbers/collections, and
  duplicate decoded names;
- status/media/error substitution and incomplete-body finalization;
- numeric overflow/non-finite values, unit confusion, poles/antimeridian, and
  malformed dates;
- huge/inconsistent collections and record/cell exhaustion;
- retry storms, `429`, cancellation, ambiguous delivery, and dishonest clocks;
- cache collision, stale/version mismatch, restart, eviction, and secret
  contamination;
- forged registry authority, wrong decoder/validator/result, evidence rollback,
  expiry, and offline revocation limits;
- hostile transport/provider/cache/sink behavior.

Fuzzing before 1.0 targets JSON, query encoding, HTTP metadata, policy
manifests, NLR envelopes/models/collections, geospatial/scientific scalars, and
typed JSON mapping.
There are no mandatory XML or CSV fuzz campaigns because those codecs do not
ship in the frozen scope.

## 14. Completion Definition

The 1.0 plan is complete only when:

- all stable crates are independently packageable and converge to `1.0.0`;
- every NLR operation and model is in the executable completeness matrix;
- all production I/O is closed-origin, evidence-bound, bounded, and
  provenance-producing;
- key placement and PVWatts echo redaction have adversarial evidence;
- local limiter/cache guarantees are described with their actual process
  scope;
- JSON/query/geo/model/collection final fuzz campaigns pass;
- excluded formats, writes, restricted data, post-1.0 sources, concrete
  transports, and hosted/distributed systems are absent from 1.0 claims;
- legal/privacy/source evidence is current;
- every release gate and final pentest passes.
