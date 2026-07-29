# United States Security Controls

Controls are proportional to the admitted direct-SDK/NLR JSON scope and trace
to [API_CAPABILITY_MATRIX.md](API_CAPABILITY_MATRIX.md).

## Input And Resource Controls

- Closed validated identifiers, versions, methods, origins, path/query
  components, headers, status/media profiles, and operation membership.
- No arbitrary absolute URL, host, raw header map, or raw query fragment.
- Strict UTF-8/JSON, decoded-name duplicate rejection, bounded depth/tokens/
  strings/numbers/collections/work, and complete-input proof.
- Validated latitude/longitude, dates, finite numeric values, units, ZIP codes,
  and fixed-size monthly vectors.
- Checked non-cloneable ledgers charged before bytes, allocation, parse work,
  request attempt, redirect, record handling, cache scan, or diagnostic
  emission.
- Exact collection progress with total record/cell/body/work budgets; NLR
  `all` is one bounded stream, not pagination.
- Partial streamed data cannot create final provenance or enter a cache.

## Network And Credential Controls

- Generated HTTPS production origins and explicit production/test separation.
- `developer.nlr.gov` is the only NLR credential target;
  `developer.nrel.gov` is denied, not aliased.
- Same-origin redirects only when the exact operation admits them; no
  cross-origin or downgrade key forwarding.
- Closed typed headers reject CRLF, controls, hop-by-hop fields, forbidden
  framing, illegal duplicates, and aggregate overflow.
- NLR key material is one-use, injected late into `X-Api-Key`, reacquired for
  retry, and excluded from canonical plans, caches, provenance, diagnostics,
  errors, fixtures, and formatting.
- PVWatts response `inputs.api_key` is discarded/redacted before result,
  cache, fixture, or diagnostic creation.
- Caller transports are explicitly trusted for DNS, TLS, certificates,
  framing, metadata accuracy, byte accounting, deadline, and cancellation.

## Policy And Authority Controls

- Source-independent policy code is separate from generated reviewed source
  membership.
- Missing, unknown, contradictory, expired, rolled-back, or killed policy
  fails closed.
- Opaque one-use `AuthorizedExecution<R>` binds exact plan, origin, header
  schema, status/media, JSON decoder, semantic validator, output, limits,
  evidence versions, and provenance.
- Completion witnesses are private to wire/codec/registry/executor producers
  and bound to one attempt; callers cannot substitute a decoder or validator.
- Current-policy revalidation occurs before credential materialization/I/O and
  after waits/redirects. The documented direct-SDK revocation race remains
  honest.

## Rate Retry And Cache Controls

- Built-in rate accounting is process-local. api.data.gov accounting uses a
  provider-owned opaque non-secret quota-pool ID so NLR and a later
  participating source can share one bucket inside the same limiter; the ID is
  not derived from secret bytes.
- Local accounting is never claimed as complete key-, IP-, organization-, or
  deployment-wide enforcement.
- Retry needs operation permission, replayability, non-ambiguous delivery,
  remaining attempt/delay/deadline budgets, fresh policy, and a fresh key
  lease.
- `429`/`Retry-After` handling is bounded and does not refund attempts.
- `NoCache` is default.
- The optional cache is bounded, in-process, public-response only,
  complete-result only, keyed by full canonical/representation/environment/
  version identity, and independent of NLR key identity.
- Cache freshness uses one monotonic process epoch; restart or incompatible
  policy/schema/registry version invalidates entries.
- No persistent/shared trust, cross-process coalescing, or distributed fill
  fencing is claimed before a separate hosted-service admission.

## Evidence Data And Diagnostics

- Builds perform no upstream fetch.
- Dossiers contain official references, retrieval time, digest, reviewer,
  expiry, operation inventory, exact formats, terms, and exclusions.
- Generated registry code is deterministic and reviewed.
- Official fixtures require explicit retention/redistribution evidence;
  synthetic fixtures are the default.
- Diagnostics use closed event codes, counts/timings, and opaque IDs; no
  response fields or credentials.
- Data classification, attribution, transformation, export, retention, and
  fixture rules travel with policy/provenance through project-owned paths.

## Build Profile Scope

`overflow-checks = true` and `panic = "abort"` in this workspace's
`[profile.release]` harden only builds for which this workspace is the root,
including its release verification in CI. Cargo does not apply a dependency
crate's profile settings when a downstream application consumes the library.
Downstream binaries control their own panic and overflow profiles.

The protection shipped in this library's source is the
`clippy::arithmetic_side_effects = "forbid"` policy enforced by CI. It prevents
unchecked arithmetic from being admitted here; the workspace profile is
defense in depth for repository-owned builds, not a runtime guarantee to
consumers.

## Scope Controls

The 1.0 build contains no XML or CSV codec and no NLR XML, CSV, GeoJSON
document output, or route POST. It contains no entitlement-rebind loop,
distributed quota authority, persistent authenticated cache, or generic
change-feed checkpoint.

Future Regulations.gov writes, SAM restricted data/extracts, NOAA scientific
formats, archived NASA endpoints, or hosted services require new threat,
resource, legal, and capability admissions before implementation.
