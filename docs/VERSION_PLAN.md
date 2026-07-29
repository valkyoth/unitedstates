# United States Version Plan

The canonical milestone details are in
[RELEASE_PLAN.md](RELEASE_PLAN.md). Architectural work must trace to
[API_CAPABILITY_MATRIX.md](API_CAPABILITY_MATRIX.md).

## Phases

| Versions | Phase |
| --- | --- |
| `0.1.0` | dependency-free two-crate repository foundation |
| `0.2.0..=0.9.0` | IDs, limits, request/origin/policy, evidence, registry authority, provenance |
| `0.10.0..=0.12.0` | sans-I/O HTTP and bounded response body |
| `0.13.0..=0.15.0` | bounded JSON |
| `0.16.0..=0.18.0` | canonical query, geo/scientific scalars, typed JSON model contracts |
| `0.19.0..=0.21.0` | deterministic testkit, source compiler, generic executor, synthetic conformance |
| `0.22.0..=0.36.0` | offline NLR dossier, Alternative Fuel Stations, PVWatts v8 JSON, freshness |
| `0.37.0..=0.44.0` | live direct-client rate/retry, local cache, ergonomics, platforms, performance, fuzzing, evidence, packaging |
| `0.45.0..=0.50.0` | authority, credential, replay, local-control, diagnostics, and security audits |
| `0.51.0..=0.59.0` | alternate-media deferral, resource/trust/capability/tier/admission/completeness audits |
| `0.60.0` | legal and privacy readiness |
| `0.70.0` | direct-SDK reliability and recovery |
| `0.80.0` | limited public beta |
| `0.90.0..=0.99.0` | freeze, topology honesty, final JSON/query/model fuzzing, platform/supply-chain/source/acceptance gates |
| `1.0.0-rc.1` | exact production candidate |
| `1.0.0` | serious production release for the documented NLR JSON slice |

## Architecture Trace

| Concern | Established | Final proof |
| --- | --- | --- |
| validated IDs, bounded scalars and consumable ledgers | `0.2.0..=0.3.0` | `0.52.0`, `0.94.0` |
| secret-safe errors and typed request/header plan | `0.4.0..=0.5.0` | `0.46.0`, `0.49.0` |
| closed origins and redirect boundary | `0.6.0` | `0.47.0`, `0.50.0` |
| source-independent policy and deterministic manifests | `0.7.0..=0.8.0` | `0.43.0`, `0.54.0`, `0.97.0` |
| opaque operation authority and provenance | `0.9.0` | `0.45.0`, `0.54.0`, `0.98.0` |
| sans-I/O trusted transport boundary | `0.10.0..=0.12.0` | `0.53.0`, `0.58.0` |
| strict bounded JSON and duplicate-name rejection | `0.13.0..=0.15.0` | `0.42.0`, `0.92.0` |
| structured query without raw-fragment escape | `0.16.0` | `0.42.0`, `0.93.0` |
| geospatial/scientific value safety | `0.17.0` | `0.34.0`, `0.93.0` |
| typed JSON field-presence/enums/fixed-array mapping | `0.18.0` | `0.25.0`, `0.34.0`, `0.93.0` |
| deterministic offline source onboarding | `0.19.0..=0.20.0` | `0.43.0`, `0.96.0` |
| complete generic path proven synthetically | `0.21.0` | `0.45.0`, `0.53.0` |
| current NLR host/key/operation evidence | `0.22.0..=0.23.0` | `0.43.0`, `0.97.0` |
| stations and typed filter/location/bounded collection models | `0.24.0..=0.33.0` | `0.35.0`, `0.59.0` |
| PVWatts v8 JSON, units, arrays, key-echo redaction | `0.34.0` | `0.46.0`, `0.93.0` |
| last-updated represented only as freshness | `0.36.0` | `0.43.0`, `0.98.0` |
| honest process-local rate/retry behavior | `0.37.0` | `0.48.0`, `0.91.0` |
| optional bounded in-process public cache | `0.38.0` | `0.48.0`, `0.53.0`, `0.70.0` |
| no hidden XML/CSV/GeoJSON/bulk requirement | `0.51.0` | `0.58.0`, `0.93.0`, `0.98.0` |
| direct-SDK versus distributed-system boundary | throughout | `0.53.0`, `0.58.0`, `0.91.0` |

## Crate Introductions

Crates enter only when implementation begins:

| Version | Crate |
| --- | --- |
| `0.1.0` | `unitedstates-core`, `unitedstates` |
| `0.7.0` | `unitedstates-policy` |
| `0.9.0` | `unitedstates-registry` |
| `0.10.0` | `unitedstates-http` |
| `0.13.0` | `unitedstates-codec-json` |
| `0.19.0` | `unitedstates-testkit` |
| `0.20.0` | `unitedstates-schema` |
| `0.21.0` | `unitedstates-executor`, `unitedstates-conformance` |
| `0.22.0` | `unitedstates-nlr` |

There is no pre-1.0 XML or CSV codec crate. A future named operation must
justify and independently admit each representation/format.

Post-1.0 source order:

| Facade | Source |
| --- | --- |
| `1.1.0` | `unitedstates-openfda` read-only selected endpoints |
| `1.2.0` | `unitedstates-nasa` APOD and NeoWs |
| `1.3.0` | `unitedstates-census` typed ACS/Decennial JSON |
| `1.4.0` | `unitedstates-regulations` read-only v4 |
| `1.5.0` | `unitedstates-sam` public/revealed Contract Awards JSON |
| `1.6.0` | `unitedstates-noaa` NWS JSON point-to-grid forecasts |

Authentication is source-specific. NLR/NASA selected APIs, openFDA,
Census, Regulations.gov, SAM.gov, NWS, and NCEI must not be put behind one
fictional government-key abstraction.

Separate admission is required for:

- Regulations.gov comment submission and attachments;
- SAM restricted/CUI data, async extracts, D&B field rights, CSV, legacy XML;
- NCEI and NOAA scientific/bulk formats;
- archived NASA endpoints;
- hosted services, deployment quota coordination, persistent authenticated
  caches, and cross-process request coalescing.

The repository tag is always the facade version. Subcrates otherwise advance
independently as recorded in
[CRATE_VERSION_MATRIX.md](CRATE_VERSION_MATRIX.md), with all present crates
converging to `1.0.0` for the first stable release.
