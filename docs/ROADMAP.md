# Makambako Yetu: Phased Roadmap

**Status:** Phase Zero is documented. Safe, independent Phase One groundwork
has been authorized; completion still requires the listed data/provider gates.

## Working rules for every phase

- Preserve the current Makambako Yetu color palette, Roboto typography,
  compact card/grid layout, information density, Material touch/ripple
  feedback, and elastic scrolling unless a reviewed change requires otherwise.
- Inspect and retain user work. At roadmap start, `README.md`, `lib/main.dart`,
  and `test/widget_test.dart` contain uncommitted changes; `.vscode/` is also
  untracked. Do not overwrite, reset, stash, or accidentally commit these.
- Do not fabricate local listings, prices, addresses, reviews, availability,
  distances, events, or live driver positions. Development fixtures must be
  clearly labelled and sourced.
- Do not add paid services, expose secrets, request location without a user
  action and explanation, or enable real financial transactions without the
  approvals in [ARCHITECTURE.md](./ARCHITECTURE.md).
- Every phase adds targeted unit/widget/integration coverage; run
  `flutter analyze` and `flutter test` before marking it complete.

## Phase Zero — audit and architecture

**Deliverables:** [PROJECT_AUDIT.md](./PROJECT_AUDIT.md),
[ARCHITECTURE.md](./ARCHITECTURE.md), this roadmap.

**Acceptance criteria:**

- Existing app, dependencies, navigation, state, visual identity, platform
  configuration, real-vs-mock behavior, and Git state are recorded.
- Proposed shared location/data/API boundaries, screen inventory, privacy
  posture, provider options, trade-offs, costs, and required approvals are
  documented.
- A phased plan and measurable gates are defined.
- No application code, dependencies, credentials, or external project
  configuration are changed.
- Existing baseline checks are recorded.

**Status:** Ready for review. `flutter analyze` and all 4 widget tests passed
against the existing working tree on 2026-10-17. No app code was changed for
this phase.

**Gate:** Phase One groundwork has been explicitly authorized. Provider,
backend, data-source, and permission decisions still gate external
integrations.

## Phase One — one complete discovery slice

**Goal:** Search a canonical real place/business record and open the same
record from search and the shared map.

### Deliverables

1. A minimal testable discovery/domain boundary extracted from the current
   screen, without a whole-app rewrite.
2. A stable `Location` and `Place/Business` model with IDs, provenance,
   verification status, timestamps, and location hierarchy.
3. An approved backend/API and map-provider integration boundary.
4. One source of Makambako records: owner-approved, verifiable initial records
   or explicitly badged development fixtures. No invented commercial facts.
5. Actual-record search, category filtering, and an interactive map with
   bounds/layers only for available data.
6. Shared detail card/profile routing from both result types.
7. Permission explanation and denial path if device centering is approved;
   manual area selection must always work.
8. Loading, retry/network error, no-results, and no-listed-places states.

### Phase One worktree status

- **Implemented:** canonical place/entity/location and geographic-area
  contracts; source provenance and verification states; optional coordinates
  and address; timestamps; typed repository outcomes; deterministic
  case-insensitive exact, prefix, alias, partial, and description/address
  ranking; category/area filters; bounds queries; canonical ID lookup; UI
  loading, empty, timeout, server-error, and not-configured states; detail
  lookup by the selected result ID.
- **Implemented but test-only:** synthetic records exercise search, filter,
  bounds, and detail behavior. The UI visibly labels any injected development
  fixture. No synthetic listing is configured in the runtime app.
- **Not implemented:** backend/API, approved listings, map SDK/tiles/markers,
  attribution, actual map-to-detail interaction, and a selectable area
  directory. The Explore screen explicitly says the map is unavailable.
- **Manual area:** the repository accepts an optional canonical area ID and
  needs no GPS permission. A user-facing area selector remains unimplemented
  until an authoritative area directory is selected.

### Acceptance-criteria status

| # | Status | Evidence / remaining work |
|---|---|---|
| 1 | Blocked | No approved real place/business records are available. |
| 2 | Partial | Search and bounds queries use the same canonical place ID in tests; no live map exists. |
| 3 | Partial | Search-to-detail lookup is widget-tested with a clearly labelled test fixture; no real listing is configured. |
| 4 | Complete | Ranking, category/area filters, and deterministic ordering have unit coverage. |
| 5 | Partial | Shared filter/query contract is implemented; map marker synchronization awaits the provider. |
| 6 | Partial | Manual area ID is accepted without GPS; no user-facing area selector/directory exists. |
| 7 | Partial | Typed loading, empty, timeout, server, and not-configured states are implemented and widget-tested; a live server adapter and retry behavior against it remain pending. |
| 8 | Complete | Development fixtures are visibly labelled; runtime defaults contain none. |
| 9 | Complete | Existing category search, navigation, bookmarks, theme, and visual behavior remain covered by widget tests. |
| 10 | Complete for local checks | `flutter analyze` passed; full `flutter test` passed (15 tests). Mobile integration tests remain pending provider/data availability. |
| 11 | Complete | No credentials, machine-specific settings, permissions, or new dependencies were added. |

### Acceptance criteria

- A fixture/repository test proves that the same place UUID is returned from
  search and map queries.
- At least one valid and one zero-result search pass; a simulated timeout or
  server error is visibly distinct from zero results.
- Case-insensitive exact/prefix/partial/alias ranking behavior is unit-tested,
  deterministic, and documented.
- Category filters change map pins and result lists consistently.
- Tapping a result and its map marker opens the matching canonical ID.
- Manual town/area search works when location permission is denied or not
  requested.
- Permission is requested only on the approved user action; no background
  tracking is introduced.
- No unlabelled demo record, fake distance, or fabricated availability appears.
- `flutter analyze`, unit tests, relevant widget tests, and the end-to-end
  discovery integration test pass on the intended mobile target.
- Existing navigation/search/bookmark behavior remains available unless an
  explicitly reviewed product decision replaces it.

**Gate:** Provider coverage, attribution, secrets/key restrictions, recurring
cost cap, data source/provenance, privacy/retention policy, and test results
are reviewed before Phase Two.

## Phase Two — canonical business discovery

**Goal:** Businesses, restaurants, shops, products, services, and places use
canonical records across search, map, and profile.

### Acceptance criteria

- One business ID/profile and location are reused across all discovery
  surfaces; category membership does not duplicate a business.
- Business profile supports approved fields, contact consent, opening hours
  where sourced, source timestamps, and VERIFIED/UNVERIFIED/SUSPENDED state.
- Listing creation/update, image authorization, and moderation are
  server-authorized and tested.
- Search and map only expose public, approved fields and show verification
  status accurately.
- Missing data is omitted or marked unavailable, never guessed.
- Repository, API, UI, authorization, moderation, and accessibility tests pass.

## Phase Three — customer transactions and service requests

**Goal:** Add one separately testable transaction workflow at a time, starting
with the workflow selected by the owner and local operators.

**Candidate workflows:** food/shop order; on-site service request; ride
request; reusable delivery request.

### Acceptance criteria for each workflow

- The workflow has explicit typed states, allowed transitions, actor/time
  history, validation, idempotency, cancellation, and failure behavior.
- Server confirmation—not optimistic client UI—determines accepted, paid,
  assigned, picked-up, delivered, or completed status.
- Order and optional delivery are separate linked records.
- Pickup/destination/customer locations follow the shared location/privacy
  model; sensitive coordinates are protected and have a retention rule.
- Delivery confirmation and dispute records exist before COD delivery is
  operationally offered.
- Unit tests cover valid/invalid transitions and authorization; integration
  tests cover the end-to-end workflow and recovery from network failure.
- No real payment is enabled until provider contracts, callback validation,
  reconciliation, refunds/disputes, legal, and security review are approved.

## Phase Four — operational roles and platform services

Deliver, in separately approved releases:

- Account signup, phone/email verification, saved places, history, privacy,
  and deletion.
- Driver onboarding/verification, availability, ride/delivery requests,
  trip status, and location safety.
- Business dashboard, catalogue/orders/availability/reviews.
- Admin moderation, verification, reports, disputes, and audit.
- Event-driven notifications, push delivery, payment adapters, analytics.
- Multi-town configuration and localization.

### Acceptance criteria

- Server-enforced role/record authorization is tested for allow and deny cases.
- Driver live location is consented, access-restricted, purpose-limited, and
  not represented as live when stale.
- Admin and business changes are auditable and have least-privilege roles.
- Notification delivery is based on persisted domain events; push is not the
  only copy of a business event.
- Payment success is reconciled with a verified provider response and
  server-side record.
- Data deletion/export, backup recovery, rate limits, and incident/support
  process are documented and tested.
- Availability/performance targets are chosen from expected workloads before
  production launch.

## Release checklist

Every release report must state:

1. User-visible changes and exact files changed.
2. Tests, analyzer, build, and target devices executed with actual results.
3. Known defects and accepted exceptions.
4. Services, credentials/configuration, licensing, and budget still required.
5. Which records are live, verified, or demo/mock.
6. Privacy/security implications and permission behavior.
7. Whether work is committed/pushed; never claim it unless verified.
8. The next phase and any approval gate.

## Remaining blockers to complete Phase One

- No approved backend, database region, API/auth approach, or deployment
  environment.
- No selected map/tile/geocoding provider or Makambako coverage test.
- No approved source and owner for real local listings or map data.
- No location permission/retention policy.
- The current project has only category data and no persistence/network layer.
- Phase Zero review and explicit Phase One approval are still required.
