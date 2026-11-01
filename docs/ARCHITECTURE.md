# Makambako Yetu: Proposed Architecture

**Status:** Phase Zero proposal; not an implementation or provider commitment.  
**Decision gate:** Review and approve the consequential choices in §10 before
Phase One integrations.

**Phase One worktree update:** Provider-neutral place/location models,
repository contracts, deterministic ranking, typed outcomes, and tested
discovery UI are now implemented. The default runtime repository serves
clearly badged trial development fixtures (trial services and offices) so the
discovery slice is exercisable end to end; the unconfigured no-source state
remains implemented and tested. No provider, backend, production listing
source, or location permission has been selected or integrated.

## 1. Product architecture

Makambako Yetu is one Flutter customer application over a shared discovery,
identity, and geographic platform. Business, driver, and administrator
experiences are future clients of the same server-side domain services, not
independent copies of listing, order, or location data.

```text
Flutter customer app
  Home | Universal search | Explore map | Activity | Community | Profile
                       |
             feature repositories
                       |
          versioned application API
                       |
   modular backend (one deployable to start)
   ├── discovery/search
   ├── places and shared location
   ├── identity and authorization
   ├── business/catalogue
   ├── orders/rides/deliveries/service requests
   ├── news/events/moderation
   └── notification dispatch
                       |
     PostgreSQL + PostGIS (canonical records)
     object storage | push provider | map provider
```

Start with a **modular monolith**, not microservices: one versioned API and
relational database, with feature/domain boundaries and explicit ownership of
business rules. Split a service only when measured operational or scaling
needs justify the cost.

## 2. Flutter structure and design constraints

Retain Flutter and the working visual language. Extract by feature when each
feature is implemented; do not rename the current screen or perform a
whole-app rewrite to establish a folder convention.

Proposed direction:

```text
lib/
  app/                 app shell, theme, navigation, dependency setup
  core/
    location/          shared location value types and selection state
    networking/        API client, typed failures, auth/session boundary
    design/            current Makambako Yetu tokens and reusable components
  features/
    discovery/
      data/ domain/ presentation/
    map/
      data/ domain/ presentation/
    profile/
```

Introduce folders only as the corresponding code is extracted. Keep widgets
thin; put ranking, filtering, validation, and state transitions in
unit-testable code. Put API access behind repositories so UI is not coupled to
a vendor SDK or table layout. Keep Material 3, forest-green palette, Roboto,
compact information density, current card hierarchy, ripple feedback, and
elastic scrolling. There is no custom sound implementation in the audited
source; add sound only as an explicitly approved, user-controlled product
decision.

State management, router, and code-generation packages are not currently
installed. First extract/test the discovery state boundary. Then compare
Riverpod, Provider, or Flutter built-ins against actual needs and avoid adding
dependencies until a choice is approved.

## 3. Shared domain and location model

Use stable UUID identifiers and explicit entity tables. Do not make a category
an entity, put coordinates in presentation widgets, or rely on a weak
polymorphic `entity_type/entity_id` pair as the only relationship.

| Entity | Key relationships and purpose |
| --- | --- |
| `country`, `region`, `district`, `town`, `area` | Geographic hierarchy; Makambako is an initial town/area, not a hard-coded global database rule |
| `location` | Canonical mappable place with UUID, display name, optional address/area, `geography(Point, 4326)`, source/provenance, verification state, timestamps |
| `business` | Canonical owner/profile/category/contact/verification record; references one canonical location where applicable |
| `service_category` | Extensible category ID, localized display names, and search aliases |
| `service_provider` | Provider identity/profile and service area; references a business and/or provider location where applicable |
| `product`, `menu_item` | Business-owned catalog records; never duplicate business location |
| `event`, `news_article` | Moderated records; event references location, editorial content remains separate from commercial listings |
| `user`, `saved_item` | Auth/profile and saved entity references; server-linked only after authentication |
| `ride`, `order`, `delivery`, `service_request` | Separate workflows, typed status/state history, actor IDs, and references to canonical pickup/destination/customer locations |
| `driver`, `vehicle` | Verified provider and transport asset; private, short-lived current-location data separated from public stable places |
| `review`, `report`, `dispute`, `notification`, `payment` | Trust, operational, and financial records with explicit ownership and access rules |

`location` is the common spatial record. Each mappable domain entity has a real
foreign key to it, so business discovery, map markers, and profile screens
resolve to the same canonical record. For relationships that are genuinely
many-to-many (for example, an event with multiple locations), introduce an
explicit association table with enforced foreign keys.

Store public place points as WGS84 longitude/latitude in PostGIS
`geography(Point, 4326)` with a GiST index; document axis order at API
boundaries. Keep presentation address separate from geometry. Add source,
verification status, and created/updated timestamps. Represent country →
region → district → town → area with stable IDs; do not infer a user's exact
location from a search keyword.

Precise user pickup/dropoff coordinates and driver live-location events are
sensitive operational data, **not** public `location` records. Store them in
workflow-specific records with authorization, purpose, and retention controls.
Do not continuously collect or retain user movement by default.

## 4. Discovery and unified search

The current app's alias matching is category-only. Phase One's search contract
must query actual approved `Business`/`Place` records and return typed results;
categories are filters, not successful entity results.

Proposed request:

```text
GET /v1/search?q=plumber&town_id=...&category=service&near=lat,lng
```

`near` is optional, permission-aware, and omitted for manual-town search.
Return result ID, entity type, canonical title, verified/sample status,
category, display address, optional coordinates/distance, and only fields
permitted for public discovery. Do not return private phone numbers or
operational coordinates by default.

Initial ranking, defined before implementation:

1. Exact normalized name match.
2. Name prefix match.
3. Name/alias/category match.
4. Partial match against description or address.
5. Optional proximity adjustment only when user location is consented or an
   area is explicitly selected.
6. Stable deterministic tie-break by name then ID.

Search input is case-insensitive and supports reasonable partial terms.
Maintain an explicit, reviewable alias table for English and Swahili terms.
Use PostgreSQL full-text search for tokenized fields and evaluate `pg_trgm` for
partial matching against real sample-sized data; do not treat a keyword list
embedded in UI as production search. Return an empty successful response for
zero matches, and a distinct typed network/server failure when the request
fails.

Potential endpoints:

- `GET /v1/search`
- `GET /v1/places?town_id=...&bbox=...&category=...`
- `GET /v1/places/{place_id}`
- `GET /v1/businesses/{business_id}`

The map and search must reference the same canonical place/business IDs.

The current client boundary exposes `search`, `findWithinBounds`, and
`getById` operations over one canonical place ID. The bounds operation is a
data contract only; it is not a map SDK, viewport controller, or rendering
implementation. The unconfigured repository returns a typed not-configured
result so that absence of a data source is not mistaken for a successful
empty search; the current default serves clearly badged trial fixtures
instead.

## 5. Map and geographic integration

Keep a provider-neutral `MapView`/map-controller boundary in the feature
layer. Its input is canonical `Place` records and its output is selected
record IDs and viewport changes; it must not own business data or transaction
rules.

First map slice:

1. Select/approve provider, data attribution, API key restrictions, and budget.
2. Verify street/address coverage and geocoding for Makambako with a device
   field test and test queries.
3. Render the map and licensed tiles with visible attribution.
4. Request device permission only when a user asks to center on their
   position; keep manual town/area selection available after denial.
5. Fetch only supported, approved place records for the visible bounds and
   active category layers.
6. Selecting a marker opens the same canonical result/profile as search.
7. Distinguish map-provider failure, no listed places, and denied location.

No map provider or location service exists in the repository. Do not render a
static graphic or category icon as a “live map.” Do not show invented pins,
distance, opening status, or availability.

## 6. API, trust boundaries, and future flows

Use a versioned JSON API and typed feature repositories. The server owns
authorization, validation, verification, transaction-state transitions,
idempotency, audit records, and notification events. The mobile client must
never contain a database service-role key or payment secret. Public discovery
may be read-only; authenticated mutations must be enforced server-side, not
by hiding UI controls.

Model separate typed workflows:

```text
Order -> optional DeliveryRequest
Ride  -> pickup Location + destination Location + assigned Driver
ServiceRequest -> service + customer-supplied location + description + status
Event -> canonical Location
Business -> canonical Location -> shared Search/Map/Profile
```

An order and a delivery are related but distinct; do not duplicate an order
when assigning a courier. Use explicit allowed status transitions, actor/time
history, cancellation rules, and delivery confirmation/dispute records.
Never display “accepted” before the server confirms it.

Initial service boundaries (modules in one deployable initially):
authentication/authorization, discovery, location, business/catalogue,
order, ride/delivery, service request, editorial/events/moderation, media,
notifications, payments, and audit. Defer financial and live operational
modules until providers, legal terms, safety controls, and operating processes
are approved.

## 7. Privacy, security, data quality, and connectivity

- Ask for foreground device location only after a user action and explain its
  purpose. Maintain manual town/area selection.
- Query nearby public places only with consented device coordinates or an
  explicitly selected area.
- Separate public business geometry from private pickup, saved-home, and
  driver-location data; default to least privilege.
- Define purpose, retention/deletion, export, and access audit policy before
  retaining precise coordinates or personal data. Obtain Tanzanian privacy
  counsel/compliance review before production processing.
- Enforce row-level/server authorization for every protected entity. Validate
  on the server; do not trust client role claims or hidden controls.
- Use HTTPS, secret management, least-privilege keys, backups, rate limits,
  safe logging, and tested recovery procedures.
- Mark listing provenance and VERIFIED / UNVERIFIED / SUSPENDED states.
  Search/map must not imply a listing is verified unless it is.
- Model loading, timeout, retry, offline/stale public cache, and empty states
  separately. Never use stale driver coordinates as live positions.
- Check screen-reader labels, text scaling, contrast, and touch target
  usability while preserving the established visual language.

## 8. Proposed first vertical slice

**Goal:** one truthful, tested Makambako discovery flow, not a miniature
ride-commerce launch.

The independent client-side groundwork is in place: domain records contain
entity relationships, optional geographic coordinates/address, provenance,
verification status, and timestamps; ranking and filters are exercised by
unit tests. The UI can render canonical search results and resolve details by
the same place ID, and marks injected development fixtures explicitly. These
tests use synthetic test-only records and do not establish that a real listing
source or map works.

1. Agree on backend, map provider, and a lawful/verifiable initial data source.
2. Define a canonical `Location` and `Place/Business` contract.
3. Load only owner-approved/verified records, or clearly badged, sourced demo
   fixtures for development. If no records are available, show a correct empty
   state rather than fictional businesses.
4. Search actual records with typed results and deterministic ranking.
5. Display the same records on the approved map; selecting a result/marker
   opens the same detail card.
6. Keep town selection usable without GPS permission; make location consent
   explicit.
7. Test repository logic, search ranking/errors, permission-denied behavior,
   map filters/selection, and the complete search-to-detail flow.

This slice establishes the shared data/map boundary for later modules; it does
not implement ordering or promise live availability.

## 9. Screen and role inventory

**First slice:** Home; universal search/results; Explore map; place/business
detail; manual area selection; permission explanation/denial state; loading,
empty, and retry states.

**Later customer screens:** authentication/verification, business/menu/product
detail, cart/order confirmation/history, ride request/active trip, delivery
status, service request/history, news/community, event detail, saved places,
settings/privacy, notifications, and support/disputes.

**Later operator tools:** business dashboard; driver onboarding/availability/
requests/history; admin moderation/verification/catalogue/content/reports/
disputes/analytics. A single Flutter user app cannot be presented as all of
these roles without their separate authorization, workflows, and operational
support being implemented.

## 10. Technical decision record (proposal)

Prices below are publicly advertised USD figures/pages checked on
2026-10-17. They are not a Tanzania-specific quote or a cost forecast. Taxes,
foreign exchange, traffic, payment-provider contracts, and regional data
residency must be checked before approval.

| Decision | Options and trade-offs | Recommendation / gate |
| --- | --- | --- |
| Client | Existing Flutter; rewrite is costly and unjustified | Retain Flutter; **approved by existing project** |
| App structure/state | Keep one file forever; extract feature repositories and tested state; add Riverpod/Provider/BLoC | Extract incrementally; choose state library after the discovery boundary is known. No current state package. |
| Database/spatial | PostgreSQL + PostGIS; Firebase/Firestore geohash; self-host PostgreSQL/PostGIS | Prefer relational PostgreSQL + PostGIS for canonical relations, constraints, and indexed radius/bounds queries. Supabase is a managed MVP candidate; **approval required**. |
| Backend | Supabase managed Postgres/Auth/Storage/API; Firebase services; custom API + managed/self-host DB | Pilot Supabase as the default candidate, with a thin versioned server boundary and strict RLS; compare latency/region, backup, exit path, and data rules before creating production data. Do not ship privileged keys in Flutter. |
| Supabase cost | Official pricing: Free $0, 500 MB DB and 1 GB storage, two active projects; free projects pause after one inactive week. Pro starts at $25/month, with $10 compute credits covering one Micro instance; overages/additional compute cost extra. | Free is development-only, not an unattended production commitment. Budget USD and review live terms/region before launch. |
| Firebase alternative | Managed Auth/Firestore/FCM ecosystem; Firestore geo queries require geohash candidate-range queries and distance filtering, rather than native PostGIS geometry queries. Blaze is usage-based; estimate requires a workload. | Strong push/real-time option; less direct fit for a relational, spatially connected source of truth. Do not choose solely because mobile SDKs are convenient. |
| Map SDK/provider | Google Maps Flutter plugin; Flutter Map with a commercial OSM-derived tile provider; MapLibre-based SDK/provider; self-hosted OSM stack | Run a Makambako coverage, attribution, Android/iOS performance, key-security, and cost proof before choosing. No local coverage test has been done, so **provider selection remains open**. |
| Map costs/licensing | Google Maps has SKU/usage billing and a new-customer trial credit; actual bill depends on APIs and current plan. MapTiler lists Free for testing/prototyping/non-commercial use and Flex at $30/month plus extra traffic. OSM data is open, but `tile.openstreetmap.org` is donation-funded best-effort with no SLA and has strict identification, attribution, caching, and no-bulk-download policy. | Do not use the public OSM tile server as a production service dependency. Budget a commercial tile provider or self-host only after demand and operations are understood. Check current plan terms and attribution. |
| Search | Category aliases in Flutter; PostgreSQL full-text/trigram + alias records; external search cluster | Start with PostgreSQL full-text, reviewed aliases, optional `pg_trgm`, and PostGIS relevance. No separate search cluster until measured scale requires it. |
| Authentication | Supabase Auth; Firebase Auth; custom identity | No auth in Phase One. For later accounts, select one managed identity provider after phone OTP cost/coverage, recovery, Tanzanian phone support, and data rules are tested. Do not build custom password storage. |
| File storage | Managed object storage; Firebase Storage; self-hosted object storage | Use provider-neutral upload/storage boundary; decide with backend. Store metadata and access policy separately from business records; no media feature exists now. |
| Notifications | FCM/APNs; managed push vendor; in-app event feed | Start with server-generated in-app event model; add FCM/APNs only when a verified workflow needs push. iOS requires APNs configuration. Push is delivery, not the notification source of truth. |
| Payments | Tanzanian mobile-money/bank operator integration; licensed aggregator; cash recorded as an explicit method | No provider chosen. Obtain merchant eligibility, signed pricing/settlement terms, callback security, reconciliation, refund/dispute process, and legal review before integration. Use a server-side payment adapter; never claim a payment succeeded from the client alone. |
| Deployment | Managed regional cloud; Supabase; self-hosted cloud | Prefer managed service for an early team only if an acceptable region, latency, data-residency terms, support, and backup/restore are verified. No deployment target has been selected. |

### Provider references

- [Supabase pricing](https://supabase.com/pricing)
- [Supabase Flutter quickstart](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
- [Supabase PostGIS guide](https://supabase.com/docs/guides/database/extensions/postgis)
- [Firebase pricing](https://firebase.google.com/pricing)
- [Firestore geohash queries](https://firebase.google.com/docs/firestore/solutions/geoqueries)
- [Google Maps Platform pricing](https://mapsplatform.google.com/pricing/)
- [Flutter Google Maps plugin](https://pub.dev/packages/google_maps_flutter)
- [MapTiler Cloud pricing](https://www.maptiler.com/cloud/pricing/)
- [OpenStreetMap tile usage policy](https://operations.osmfoundation.org/policies/tiles/)
- [PostGIS capabilities](https://postgis.net/)

## 11. Decisions requiring owner approval

Before Phase One writes integrations or creates remote environments, approve:

1. Managed backend/database candidate and region/data-residency requirements.
2. Map SDK/tile/geocoding provider and a recurring budget cap.
3. The first real listing data source, curation owner, and verification policy.
4. Whether to use device location in the first slice; default proposal is
   manual area only until user-initiated permission flow is approved.
5. Any new state-management or storage dependencies.

No production credentials, paid services, payments, or background tracking are
authorized by this proposal.
