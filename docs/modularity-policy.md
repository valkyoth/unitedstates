# United States Modularity Policy

The project is a set of focused crates, not a monolithic facade.

## Ownership

- `unitedstates` owns feature alignment, convenience wiring, and re-exports.
- `unitedstates-core` owns source-neutral IDs, bounds/ledgers, request/query
  structure, and shared geo/scientific/typed-model value mechanics.
- `unitedstates-policy` owns source-neutral policy vocabulary/evaluation, not
  source membership or generated operation truth.
- `unitedstates-registry` owns reviewed generated operation membership,
  authorization, and provenance.
- `unitedstates-http` owns sans-I/O HTTP/body contracts, not sockets or TLS.
- `unitedstates-codec-json` owns bounded JSON syntax and its completion proof.
- `unitedstates-executor` owns generic orchestration, local limiter/cache
  integration, late credentials, and finalization, not agency semantics.
- `unitedstates-conformance` owns synthetic semantics used to prove the path.
- Each source crate owns its request builders, source query grammar, response
  models, status/error interpretation, semantic validation, and operation
  inventory.
- `unitedstates-schema` owns offline generation; generated artifacts still
  belong to their target crate.

Dependency direction is one-way. Source and conformance crates may depend only
on the focused structural/policy/codec crates they require. They never depend
on the facade, registry, executor, HTTP, or one another. Registry may depend on
a selected source behind the same feature; the source never depends back.

## Shared-Abstraction Test

A capability becomes shared only when
[API_CAPABILITY_MATRIX.md](API_CAPABILITY_MATRIX.md) names a consumer and:

1. another named source needs the same semantics;
2. it is a source-independent security boundary; or
3. source-local implementation would duplicate a fully specified wire
   primitive.

This admits bounded JSON, canonical query encoding, geo/scientific scalars,
typed JSON model contracts, closed origins, policy/provenance, and sans-I/O
HTTP. It does not admit XML/CSV merely because optional upstream responses
exist, nor a universal API key, generic search language, generic checkpoint,
credential-entitlement rebind state, distributed quota authority, persistent
authenticated cache, or cross-process fill fencing.

## Source Isolation

- NLR owns Alternative Fuel Stations and PVWatts semantics.
- openFDA will own its search AST and medical-use warnings.
- Census will own dataset variables, geographies, and 2D row mapping.
- Regulations.gov will own JSON:API resources and any later write/upload state.
- SAM will own account access tiers and contract-award/extract semantics.
- NOAA will own NWS point-to-grid traversal and each later data family.
- NASA will own APOD/NeoWs semantics and archived-endpoint exclusions.

Similar wire shapes never permit one source crate to depend on another.

## Package And File Rules

- Every reusable Rust crate is independently publishable to crates.io.
- Crates enter only when implementation starts; no placeholder packages.
- The facade does not contain copied implementations.
- Runtime/build/dev dependency tables contain only first-party workspace
  crates unless an explicit dependency admission changes policy.
- Default builds do not silently enable network, credentials, filesystem,
  clock, cache, telemetry, live tests, or hosted relaying.
- Generated and handwritten first-party code/configuration files are each
  below 500 lines; split review begins near 300 lines.
- Generated code is deterministic, source-manifested, and divided by object
  family rather than emitted as one giant file.

## Post-1.0 Boundaries

Write operations, restricted data, bulk/scientific formats, concrete
third-party transports, unsafe FFI, and hosted services require separate
admission. A hosted service must use focused service crates and its own threat
model for tenants, deployment-wide quota, persistent storage, coalescing,
credential encryption, and abuse controls. Those concerns may not leak into
the direct NLR SDK merely in anticipation.
