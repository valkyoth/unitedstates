# Standards Source Policy

Status: policy

United States uses exact RFC Editor plain-text publications as local normative
references for source-neutral URI, date/time, JSON, HTTP, caching, and status
behavior. They are fetched manually, checked into `rfc/`, and bound to
`rfc/SHA256SUMS`. Builds and tests never download them.

Requirements:

- use only HTTPS RFC Editor URLs listed in `rfc/SOURCES`;
- keep RFC text byte-for-byte unmodified;
- reject missing, extra, changed, or empty local RFC text by exact checksum;
- prevent Git line-ending normalization with `.gitattributes`;
- treat `scripts/lock-rfcs.sh` as optional local hardening because Git cannot
  preserve read-only file bits across checkouts;
- review source-list and checksum changes together;
- record implementation notes and errata decisions separately;
- map applicable normative requirements during the milestone that implements
  the corresponding parser/protocol behavior;
- use current IANA registries, not remembered assignments, when a registry is
  relevant;
- never include RFC text in published crate archives or represent it as
  covered by the repository's software licences.

Agency documentation is different. Unless its redistribution permission is
explicitly reviewed, the repository stores only its URL, retrieval metadata,
digest, extracted facts, and review decision. Private, account-gated,
credential-bearing, or terms-restricted material remains local and gitignored.

See [the RFC directory](../rfc/README.md) and the verification scripts
documented there.
