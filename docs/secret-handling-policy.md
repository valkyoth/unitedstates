# United States Secret Handling Policy

Foundation crates do not store or accept credentials.

When NLR credential support is introduced:

- secret types are not `Copy`, cloneable, serializable, or revealing through
  `Debug`/`Display`;
- keys are supplied by an explicit provider, materialized once only after
  origin, policy, optional cache, and local-rate decisions;
- the executor immediately injects the key into the protected `X-Api-Key`
  slot and retains no copy for retry;
- every retry reacquires a fresh one-use value;
- cancellation, expiry, mismatch, or unused materialization drops the value;
- raw header maps and caller override of protected slots do not exist;
- canonical plans, cache keys/values, provenance, logs, metrics, diagnostics,
  fixtures, errors, panic text, and correlation IDs exclude secret bytes;
- production and test/demo providers are distinct configurations;
- `developer.nlr.gov` is the only production NLR credential destination;
  redirects never carry the key cross-origin or to the retired NREL host;
- PVWatts `inputs.api_key` echoes are discarded/redacted before any public or
  stored result is formed;
- local api.data.gov quota accounting uses a provider-owned opaque pool ID
  stable for keys/aliases that share a documented upstream pool; it is not
  caller supplied, logged, serialized, or derived from raw key bytes;
- secret-marker snapshots cover formatting, errors, responses, cache, retry,
  cancellation, and fixtures.

NLR data is public. The API key controls quota and does not create a data
entitlement partition, so key rotation does not trigger cache partition
rebind/relookup machinery. A future source whose credentials change accessible
data must separately admit and threat-model that behavior.

The direct SDK does not promise zeroization, swap exclusion, locked memory, or
crash-dump resistance without an independently admitted protected-memory
implementation. Future hosted credentials require tenant isolation and
encryption in a separately designed service.
