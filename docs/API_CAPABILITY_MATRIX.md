# U.S. API Capability Matrix

Status: architecture input
Last reviewed: 29 July 2026

This document is the traceability source for shared architecture and source
roadmaps. It records the selected official contracts; it is not a promise that
every listed capability ships in 1.0. A source dossier must pin the exact
documents, retrieval time, digest, terms, and operation schema before code may
authorize production I/O.

## Cross-Source Conclusions

- There is no universal U.S. government API-key contract. `api.data.gov` is
  infrastructure used by some APIs, while openFDA, Census, SAM.gov, NWS, and
  NCEI have distinct authentication or identification rules.
- HTTPS, structured relative paths/query parameters, JSON, bounded response
  processing, redaction, and source-specific status/result-set logic are the
  common foundation.
- XML, CSV, GeoJSON document mode, NetCDF, GRIB, OPeNDAP, archive extraction,
  multipart/upload workflows, and write delivery semantics are capabilities
  to admit for named operations, not generic prerequisites.
- A credential can control quota without changing data entitlement. Public NLR
  results therefore do not need credential-entitlement cache partitions.
- api.data.gov documents a default quota across participating APIs for one
  key. Local accounting therefore needs an opaque credential-pool identity
  that can span NLR and a later NASA client sharing the same provider. It must
  not derive that identity from secret bytes or claim visibility outside the
  limiter instance.
- Offset, page, token, date-window, point-to-grid traversal, and async extract
  jobs are different continuation protocols. No NLR 1.0 operation needs one,
  so continuation abstractions wait for the source that introduces them.

## Operation Matrix

| Source / stable candidate | Method and body | Authentication / identification | Response and query shape | Pagination / traversal | Principal risks | Shared primitive | Admission |
| --- | --- | --- | --- | --- | --- | --- | --- |
| NLR Alternative Fuel Stations: all, by ID, nearest, last-updated | GET, no body | api.data.gov key; 1.0 selects late `X-Api-Key` only; default quota pool can span participating APIs | JSON selected; typed filters and geospatial parameters; result `limit` is `0..200` or `all` | no pagination; `all` is one potentially large bounded stream; last-updated is not a cursor | key leakage, old-host credential forwarding, shared-key quota, large single responses, field drift | closed origin, opaque local quota-pool identity, query encoder, JSON, geo, record/body budgets, provenance | 1.0 |
| NLR PVWatts v8 monthly lat/lon slice | GET, no body | api.data.gov key via late `X-Api-Key` | JSON selected; numeric/unit parameters; 12-month arrays; response may echo `api_key` in `inputs` | none | secret echo, non-finite/range/unit errors, warnings versus errors | query encoder, JSON, scientific scalars, redaction | 1.0 |
| openFDA selected read endpoints | GET, no body | keyed or unkeyed; `api_key` query parameter when used | JSON; source query language for `search`, `sort`, `count`, `limit`, `skip` | bounded `skip`/`limit` windows | query injection, nested/variable models, medical misuse, distinct quotas | source AST over query encoder, JSON, offset budgets, disclaimer metadata | post-1.0 |
| NASA APOD | GET, no body | api.data.gov key or documented demo key | small JSON object; date/range options | bounded date range | media URLs are data, not trusted fetch targets; demo quota | query encoder, JSON, dates, URL-as-data type | post-1.0 |
| NASA NeoWs | GET, no body | api.data.gov key | nested JSON keyed by date | date windows and endpoint-specific paging | large nesting, scientific numbers, potentially alarming interpretation | JSON, dates, scientific scalars, paging | post-1.0 |
| Census ACS / Decennial | GET, no body | Census `key` query parameter, not api.data.gov | JSON 2D array: first row headers, later rows values; variable and geography grammar; 50-variable query limit | dataset/geography-specific rows, not one universal page protocol | row/header mismatch, stringly variable IDs, cell explosion, suppression/null conventions | source query builder, 2D row decoder, cell budgets, tagged geography | post-1.0 |
| Regulations.gov documents/dockets/comments reads | GET, no body | api.data.gov key | JSON:API resources, relationships, filters, sorting | page number/size and links per v4 contract | terms, PII in comments, nested relationships, query limits | JSON:API subset, page budgets, redaction/data handling | post-1.0 read track |
| Regulations.gov comment submission | POST JSON:API; separate attachment upload workflow using submission key and presigned URLs | activated api.data.gov key plus participation requirements | write receipt, validation errors, upload state | multi-step submission state, not ordinary paging | public legal act, PII, file safety, idempotency and ambiguous delivery | write-specific state machine, audit and attachment admission | separate later admission |
| SAM.gov Contract Awards public/revealed search | GET, no body | SAM.gov account API key | deeply nested JSON filters/results | limit up to documented maximum; finite synchronous record window | account-dependent quota/access, huge models, D&B field rights, CUI boundary | JSON, query builder, window budgets, account policy | post-1.0 read track |
| SAM.gov async extracts | job request/download workflow; JSON or CSV outputs | SAM.gov account and permissions | job state plus potentially massive downloadable extract | asynchronous job continuation | storage, expiry, bulk size, CSV formula/export issues, rights | separate job/bulk/format architecture | separate later admission |
| NWS forecast | GET, no body | identifying `User-Agent`; no key in current contract | JSON-LD/GeoJSON selected as JSON; point response yields office/grid coordinates, then grid forecast | point-to-grid multi-request traversal; grid mappings may change | required identification, external links, geospatial correctness, traversal staleness | caller metadata slot, JSON, geo, bounded traversal | post-1.0 |
| NCEI CDO | GET, no body | NCEI `token` header | JSON with dataset/location/date filters | offset/limit | separate quota, large historical queries, domain IDs | source credential slot, query builder, JSON, paging | later NOAA feature |
| NOAA scientific/bulk families | varies | varies | NetCDF, GRIB, OPeNDAP, archives, radar/ocean formats | files, ranges, multidimensional subsets | parser complexity, decompression bombs, huge data, scientific metadata | none until a format-specific admission | separate later admissions |

## Pre-1.0 NLR Contract

The 1.0 production slice is deliberately:

- Alternative Fuel Stations v1 JSON GET operations for station-by-ID,
  all/filtered stations, nearest stations, and last-updated;
- PVWatts v8 JSON GET;
- `developer.nlr.gov` only;
- late `X-Api-Key` injection;
- public-response semantics;
- explicit `limit=0..200` collection mode plus opt-in `all` streaming under
  total body/record/allocation/work ceilings; there is no offset paging;
- optional bounded in-process caching;
- process-local advisory rate enforcement plus reviewed retry behavior.

It excludes:

- `developer.nrel.gov`, which is retired and must never receive a credential;
- query-string or Basic credential placement from the stable convenience API;
- AFDC route POST;
- Electric Vehicle Charging Networks and the CSV-only Electric Vehicle
  Charging Ports endpoint;
- Canadian/all-country result modes;
- XML, CSV, and GeoJSON document representations;
- PVWatts hourly output, `file_id`/Solar Dataset Query coupling, and JSONP;
- generic change-feed or checkpoint claims;
- persistent/shared authenticated cache and cross-process request coalescing;
- deployment-wide quota guarantees.

## Shared-Capability Admission Rule

A shared crate or major abstraction enters the plan only when at least one
named operation needs it and at least one of these is true:

1. a second named source needs the same semantics;
2. the capability is a security boundary that must be source-independent; or
3. keeping it source-local would duplicate a fully specified wire primitive.

Similar-looking source semantics are not enough. In particular:

- openFDA search syntax remains an openFDA AST;
- Census variable/geography selection remains a Census builder;
- NWS point-to-grid traversal remains an NWS workflow;
- Regulations.gov writes remain a Regulations.gov write state machine;
- SAM access tiers remain SAM policy;
- media and scientific file parsers remain format/source admissions.

## Official References

- api.data.gov developer manual:
  <https://api.data.gov/docs/developer-manual/>
- NLR API key guidance:
  <https://developer.nlr.gov/docs/api-key/>
- NLR Alternative Fuel Stations v1:
  <https://developer.nlr.gov/docs/transportation/alt-fuel-stations-v1/>
- NLR PVWatts v8:
  <https://developer.nlr.gov/docs/solar/pvwatts/v8/>
- openFDA authentication:
  <https://open.fda.gov/apis/authentication/>
- openFDA query syntax and parameters:
  <https://open.fda.gov/apis/query-syntax/> and
  <https://open.fda.gov/apis/query-parameters/>
- NASA APIs: <https://api.nasa.gov/>
- Census API concepts and keys:
  <https://www.census.gov/data/developers/guidance/api-user-guide.Core_Concepts.html>
  and
  <https://www.census.gov/data/developers/guidance/api-user-guide.API_Key.html>
- Regulations.gov v4:
  <https://open.gsa.gov/api/regulationsgov/>
- SAM.gov Contract Awards:
  <https://open.gsa.gov/api/contract-awards/>
- National Weather Service API:
  <https://www.weather.gov/documentation/services-web-api>
- NCEI CDO v2:
  <https://www.ncei.noaa.gov/cdo-web/webservices/v2>

These links guide review; the checked-in source dossier, not a live URL, is
the build input.
