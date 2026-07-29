# United States Threat Model

Status: living baseline for the direct SDK and the pre-1.0 NLR JSON scope.
Hosted services, write APIs, restricted data, and bulk/scientific formats need
separate threat-model extensions before admission.

## Protected Assets

- NLR API keys and future source credentials.
- Integrity of canonical requests, closed origins, operation policy, registry
  authority, decoder/validator selection, and result provenance.
- Availability under malicious query values, headers, response bytes, JSON
  structures, model fields, large collections, retries, and cache entries.
- Correct data classification, attribution, transformation, redistribution,
  fixture retention, and diagnostics.
- Accuracy of claims about source operations, schemas, quotas, formats,
  freshness, and deployment scope.
- Release artifacts, reviewed evidence, and generated code.

## Adversaries And Failure Sources

- Malicious caller input attempting SSRF, header/query injection, ambiguity,
  resource exhaustion, or policy bypass.
- Compromised/misbehaving upstream returning malformed, huge, deceptive, or
  secret-echoing data.
- Network attacker within the caller-supplied transport boundary.
- Buggy or hostile transport, clock, credential provider, allocator, event
  sink, local cache, or policy authority.
- Downstream crate attempting to forge operation authority or mix plans,
  codecs, validators, results, and completion witnesses.
- Stale/compromised dossier, schema snapshot, generator, CI action, Cargo tool,
  or release input.
- Application operator incorrectly assuming process-local quota/cache controls
  coordinate a deployment.

## Primary Threats

### Request and credential threats

- Arbitrary host/scheme/port, user-info, downgrade, DNS/proxy confusion, and
  cross-origin redirect credential forwarding.
- CRLF/control injection, duplicate protected headers, forbidden framing,
  query delimiter/percent ambiguity, Unicode confusion, and raw-fragment
  escape.
- Key disclosure through debug/errors, query URLs, provenance, cache identity,
  fixtures, diagnostics, retry state, panic text, or PVWatts `inputs.api_key`.
- Earlier key selection surviving a wait, policy change, redirect, retry, or
  cancellation.

### Response and parser threats

- Malformed UTF-8/JSON, invalid escapes/numbers, duplicate decoded object
  names, excessive depth/strings/tokens/collections, numeric overflow and
  non-finite values.
- Partial or wrong-status/media response becoming success.
- Source error body selecting a success decoder.
- Provisional stream events being cached or treated as complete.
- Geo/unit/date confusion, invalid coordinates, antimeridian errors, and
  malformed monthly vectors.

### Control-flow and availability threats

- Retry/redirect loops, misleading `Retry-After`, ambiguous transport delivery,
  non-returning external components, and cancellation races.
- Misleading `limit`, huge `all` responses, inconsistent counts, duplicate
  records, or unbounded collection.
- Cache collision scans, stale/version-mismatched results, restart age errors,
  eviction storms, and secret-contaminated values.
- A second process or application using the same key/IP while the local
  limiter falsely appears authoritative.

### Policy evidence and supply-chain threats

- Expired, incomplete, rolled-back, or forged policy/schema evidence.
- Offline binaries missing a later revocation.
- Generated registry entry diverging from reviewed manifests.
- Source rename or retired endpoint treated as a safe alias.
- Optional upstream format accidentally becoming a public 1.0 guarantee.
- Dependency/action/tool compromise and publication of unreviewed artifacts.

### Data-use threats

- Official data containing personal, malicious, misleading, or medically/
  legally consequential content.
- Fixture recording or diagnostics retaining protected fields or keys.
- Caller assuming provenance establishes correctness, endorsement, or licence.
- Caller copying/logging/redistributing decoded data outside reviewed terms.

## Trust Boundaries

- Caller input -> validated source operation.
- Source operation -> canonical credential-free plan.
- Generated dossier/policy -> opaque registry authorization.
- Authorization -> exact origin/header/status/JSON/validator/result package.
- Executor -> caller transport.
- Upstream metadata/body -> bounded HTTP/body/JSON pipeline.
- JSON completion -> source semantic validation -> final provenance.
- Credential provider -> one-use late secret -> protected header injection.
- Local limiter/cache/clock -> their documented process-local decisions.
- Source result -> project-owned cache, fixture, transform, diagnostics.
- Official documents -> reviewed snapshots -> deterministic generated code.
- Repository/tooling -> package/release artifact.

## Mitigations

- No arbitrary production URL or raw header/query escape hatch.
- Generated HTTPS origins; NLR credentials only to `developer.nlr.gov`.
- Typed header categories, canonical duplicate rules, CRLF/control and
  hop-by-hop rejection, and aggregate bounds.
- One-use late key materialization and reinjection only after current policy;
  no retained secret for retry.
- PVWatts key-echo redaction before any public/stored result.
- Strict bounded JSON with decoded-name duplicate rejection and private
  attempt-bound completion.
- Checked non-cloneable ledgers for bytes, work, allocation, records,
  attempts, redirects, cache scans, and diagnostics.
- Typed geo/scientific/date/unit values and exact semantic validation.
- Opaque non-forgeable `AuthorizedExecution<R>` binding exact plan, origin,
  status/media, decoder, validator, result, limits, policy, and provenance.
- Unknown/expired/contradictory policy and evidence fail closed; rollback and
  kill-switch checks.
- `NoCache` default; optional bounded in-process cache for complete public
  results only, keyed independently of NLR key identity and invalid across
  process/version epochs.
- Process-local limiter explicitly described as advisory outside its instance;
  api.data.gov keys sharing one provider use an opaque non-secret local
  quota-pool ID; bounded replay-aware retry and honest ambiguous-delivery
  handling.
- Synthetic-only fixtures by default and retention-aware official corpora.
- Deterministic offline generation, pinned tooling/actions, package rehearsal,
  per-version pentest, and final source refresh.

## Scope-Reduction Mitigations

The following attack surfaces are removed from 1.0 rather than prematurely
generalized:

- XML entities/namespaces/request encoding;
- CSV formula/dialect handling;
- GeoJSON document parsing;
- NLR route POST replay/delivery;
- credential-entitlement partitions and provider-driven rebind loops;
- persistent authenticated cache reconstruction;
- cross-process cache-fill fencing/coalescing;
- distributed quota authority;
- generic change-feed checkpoint serialization;
- Regulations.gov public comments/uploads;
- SAM restricted/CUI data and bulk extracts;
- NOAA NetCDF/GRIB/OPeNDAP/archive parsing.

They return only with a named operation, exact contract, resource model, legal
review, adversarial tests, and explicit release admission.

## Residual Risks

- Safe Rust, `no_std`, and zero third-party dependencies do not prevent logic
  errors.
- Caller transport controls DNS/TLS/certificates/framing and can lie about
  status, headers, byte counts, deadlines, or delivery.
- Cooperative deadlines cannot preempt an external component that never
  returns; portable `no_std` cannot catch all panics or sandbox callbacks.
- Policy can change after final revalidation but before caller-owned transport
  sends. Atomic revocation needs a controlled broker or per-attempt grant.
- An offline old binary cannot learn a newly published revocation before its
  compiled evidence expiry.
- Process-local rate accounting cannot observe other processes, machines,
  applications, keys aliases, or shared egress-IP traffic.
- Monotonic in-process cache freshness is not persistence or cross-process
  coherence.
- `BodyWireBytes` is not total network bandwidth.
- Logical allocation accounting does not include allocator metadata,
  fragmentation, or physical memory behavior.
- Upstream data and official documentation can be wrong, stale, malicious, or
  privacy-sensitive.
- After results cross the SDK boundary, caller code can copy, log, retain,
  transform, or redistribute them.
- Compilation for a platform does not prove its caller-provided networking.

Residual risks must remain visible in source docs and release notes; they are
not erased by adding a trait or policy type.
