# United States: Initial Architecture Discussion

Document status: historical design rationale updated to match the accepted
U.S.-specific plan on 29 July 2026. The authoritative implementation sequence
is [RELEASE_PLAN.md](RELEASE_PLAN.md); concrete source contracts are in
[API_CAPABILITY_MATRIX.md](API_CAPABILITY_MATRIX.md).

## Product Idea

`unitedstates` is a security-first, `no_std`-first Rust ecosystem for lawful,
typed access to U.S. public APIs and datasets. The root package is a facade;
each upstream platform receives a focused `unitedstates-<source>` crate.

The project starts with a direct SDK rather than a hosted gateway. Shared code
describes requests, validates inputs, bounds responses, decodes JSON, applies
reviewed policy, and attaches provenance. Applications supply HTTP/TLS,
clocks, and credentials explicitly.

## Decisions

### The first production source is NLR

The first stable source crate is `unitedstates-nlr` for the National Laboratory
of the Rockies (formerly NREL). The reviewed production host is
`developer.nlr.gov`; the retired `developer.nrel.gov` host is never a
credential target.

The 1.0 slice contains:

- Alternative Fuel Stations v1 station-by-ID;
- filtered/all station queries;
- nearest-station queries;
- last-updated freshness observation;
- PVWatts v8;
- JSON GET responses;
- late `X-Api-Key` authentication.

It excludes XML, CSV, GeoJSON document output, route POST, and other NLR API
families. These exclusions let the shared core reflect actual stable
operations rather than every optional upstream representation.

### There is no universal government API key

The selected sources differ:

- NLR and selected NASA endpoints use api.data.gov-issued keys;
- openFDA has keyed and unkeyed modes;
- Census uses a Census `key` query parameter;
- Regulations.gov combines api.data.gov keys with separate write activation;
- SAM.gov uses account keys with account-dependent access;
- NWS currently uses an identifying `User-Agent`;
- NCEI CDO uses a separate `token` header.

The architecture therefore shares protected credential slots and redaction,
not a fictional `UnitedStatesApiKey`.

### The core follows wire reality

The shared pre-1.0 primitives are:

- validated source/operation/schema/policy IDs and versions;
- bounded scalars and consumable ledgers;
- canonical relative path and structured query plans;
- closed origins and typed headers;
- source-independent policy/evidence/provenance;
- sans-I/O HTTP and bounded response bodies;
- strict bounded JSON;
- canonical percent/query encoding;
- geospatial, date, unit, and finite scientific scalars;
- typed JSON model contracts for field presence, open enums, and fixed arrays;
- generic one-use execution;
- optional process-local rate/retry and public-response cache.

XML request encoding, XML response parsing, CSV, distributed quota authority,
persistent authenticated cache, request-fill fencing, credential entitlement
rebinding, and generic feed checkpoints are not early foundations because no
admitted 1.0 NLR operation needs them.

### Source semantics remain source-owned

Common wire mechanics do not erase API differences:

- NLR owns station filters, its `limit`/`all` collection behavior, and PVWatts
  units.
- openFDA will own its query AST and medical-use warnings.
- Census will own dataset variables, geography, and 2D header/row mapping.
- Regulations.gov will own JSON:API resources and later comment/upload state.
- SAM will own account access tiers and award/extract rules.
- NWS will own point-to-grid forecast traversal.
- NASA will own APOD and NeoWs models and archived endpoint exclusions.

## Crate Architecture

The stable NLR-era graph grows only as implementation starts:

```text
unitedstates
 ├── unitedstates-core
 ├── unitedstates-policy
 ├── unitedstates-registry
 ├── unitedstates-http
 ├── unitedstates-codec-json
 ├── unitedstates-testkit
 ├── unitedstates-schema
 ├── unitedstates-executor
 ├── unitedstates-conformance
 └── unitedstates-nlr
```

The facade contains wiring and re-exports. Source crates never depend on the
facade, registry, executor, HTTP, or one another. The registry depends one-way
on selected source crates to bind reviewed generated operation truth.

There is no custom TLS crate. Internet transport is application/platform
work. Concrete ecosystem client adapters require their own dependency
admission if the zero-third-party rule is retained.

## Execution Shape

```text
typed source input
  -> credential-free canonical request plan
  -> generated registry authorization
  -> optional local public-cache lookup
  -> current policy and local rate decision
  -> late one-use credential materialization
  -> caller-supplied transport
  -> bounded status/body/JSON processing
  -> source semantic validation
  -> final provenance
  -> optional in-process cache insertion
```

The registry-created authorization binds the exact origin, method/path/query,
header schema, response status/media profile, JSON decoder, semantic validator,
result type, limits, policy/schema evidence, and provenance. Downstream code
cannot swap any of those components.

Streamed values remain provisional until the body, JSON, and semantic layers
all produce their private completion proofs.

## NLR Security Details

- Only `developer.nlr.gov` may receive the key.
- The stable convenience API injects `X-Api-Key`, even if upstream documents
  other placements.
- Secret bytes never enter canonical identity, caches, provenance, fixtures,
  diagnostics, or printable errors.
- PVWatts may echo `api_key` under response `inputs`; that field is
  discarded/redacted before any model or stored result is created.
- Station `all` responses are one stream with total record, byte, allocation,
  and work ceilings; the SDK does not invent offset paging.
- Geospatial and PVWatts numeric values are finite, range checked, and unit
  typed.
- NLR last-updated is not represented as a lossless change-feed checkpoint.
- The NLR key affects quota, not public-data entitlement. Cache identity is
  independent of which valid key fetched a response.

## Local Versus Distributed Controls

The built-in limiter can coordinate only executions sharing one instance.
It cannot observe other processes, hosts, applications, key aliases, or
traffic sharing an egress IP. The optional cache is bounded and in-process,
and loses authoritative freshness across restart.

This is an honest direct-SDK boundary. A future hosted service can add
deployment-wide quota authority, tenant isolation, persistent authenticated
storage, request coalescing/fencing, credential encryption, abuse prevention,
and operational recovery after its own explicit architecture and threat
review. Those systems are not approximated with elaborate unused pre-1.0
types.

## Later Source Order

After the NLR SDK reaches 1.0:

1. `unitedstates-openfda`: selected read-only public search/count endpoints.
2. `unitedstates-nasa`: active APOD and NeoWs.
3. `unitedstates-census`: typed ACS/Decennial JSON queries and 2D rows.
4. `unitedstates-regulations`: read-only v4 resources.
5. `unitedstates-sam`: public/revealed Contract Awards JSON.
6. `unitedstates-noaa`: NWS JSON point-to-grid forecasts.

Each stabilizes independently before the facade exposes it.

Higher-risk capabilities remain later admissions:

- Regulations.gov public comment submission and attachment uploads;
- SAM unrevealed/CUI/role-gated data, async extracts, D&B rights, CSV, and
  legacy FPDS/XML;
- NCEI plus NOAA NetCDF/GRIB/OPeNDAP/radar/oceanographic/bulk formats;
- archived NASA APIs;
- any new codec or archive/decompression layer.

## What “Production Ready” Means

For the documented scope, 1.0 requires:

- closed origin and credential handling;
- current reviewed source evidence;
- bounded query/body/JSON/model/collection behavior;
- exact status/media and semantic validation;
- provenance on complete results;
- honest local rate/cache guarantees;
- no hidden XML/CSV/write/restricted/distributed capability;
- package/feature/MSRV/platform evidence;
- final fuzz, legal/privacy, supply-chain, source-refresh, and maintainer
  pentest gates.

It does not mean every U.S. API is implemented or that a caller-supplied
transport is magically trustworthy.
