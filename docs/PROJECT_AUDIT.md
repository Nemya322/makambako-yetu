# Makambako Yetu: Project Audit

**Audit date:** 2026-10-17  
**Scope:** Repository and current Flutter implementation; no application files
were changed as part of Phase Zero.

## Executive summary

This repository is an Android/iOS/web/desktop Flutter starter with a
Makambako-branded discovery prototype. It is not yet a connected-services MVP:
there is no backend, canonical listing data, interactive map, account system,
or transaction workflow. The app currently filters eight locally declared
service categories and Swahili/English keyword aliases.

Since this Phase Zero snapshot, the worktree has gained a provider-neutral
discovery domain/repository boundary and tested ranking/state handling.
The runtime still has no approved place data source, backend, or map provider;
the default repository explicitly reports that it is not configured.

The latest local discovery/search work is not yet committed. Preserve it while
reviewing this audit; do not reset, stash, or include it in a Phase Zero commit.

## Repository and Git state

- Flutter project root; Git root is this directory.
- `master` tracks `origin/master` at `cccebbc` (`Initial Makambako Yetu project
  snapshot`).
- At audit time, `README.md`, `lib/main.dart`, and `test/widget_test.dart` have
  uncommitted modifications. These are pre-existing product work and are out
  of scope for this audit.
- `.vscode/` is untracked and was not inspected or changed.
- `android/local.properties` is ignored and contains machine-specific SDK
  paths. Do not commit it.
- No existing `docs/` directory or project architecture documents were found.
- Generated build, Gradle, and Dart tool files exist locally; standard ignore
  rules cover the main generated build outputs.

## Stack and dependencies

- Flutter 3.47.5 / Dart 3.13.4 was the locally installed toolchain at audit
  time. The package constraint is `sdk: ^3.13.4`.
- Android uses Kotlin DSL Gradle files, Android Gradle Plugin 9.1.0, Kotlin
  plugin 2.4.0, Java 17, and Flutter's default NDK version.
- iOS, web, Windows, macOS, and Linux starter targets are present.
- Runtime packages in `pubspec.yaml`: Flutter SDK and `cupertino_icons`.
- Development packages: Flutter test SDK and `flutter_lints`.
- There is no state-management, routing, networking, database, persistence,
  location, mapping, authentication, analytics, notification, or payment
  package.
- `pubspec.lock` is present and should remain version-controlled for this app.
- Android application ID is still `com.example.mk_yetu_app`; platform labels,
  web metadata, and package description retain starter-project names. These
  need a coordinated release-identity decision, not an incidental Phase One
  refactor.

## Screen and navigation inventory

`lib/main.dart` contains the application, state, category data, and UI widgets.
Navigation is a four-destination Material 3 `NavigationBar`:

| Destination | Current behavior | Limitations |
| --- | --- | --- |
| Nyumbani | Branded welcome banner, shared text field, category grid, community card | No actual featured places, live activity, or data service |
| Gundua | Search field and category filters; tapping a category opens a bottom sheet | Category list only; not a map |
| Zilizohifadhiwa | Shows bookmarked categories | In-memory state only; lost when the app process is restarted |
| Wasifu | Static welcome/profile information and About dialog | No authenticated user, preferences, account, or history |

Home and Explore share one `TextEditingController` and category-filter state.
The current search is local substring matching against category names,
subtitles, aliases, and a fixed Makambako/Njombe term list. It does not search
businesses, products, menus, addresses, articles, or events. A location term
can match every category; it does not apply distance or geographic ranking.

## Feature and interaction inventory

**Present:**

- Makambako/Njombe brand and fixed location context.
- Eight categories: Biashara, Chakula, Huduma, Usafiri, Malazi, Matukio,
  Maeneo, and Jamii.
- Local English/Swahili aliases and token-based category filtering.
- Home-to-Explore category selection, Explore category chips, and search clear
  action.
- Session-only category bookmarks and explanatory category bottom sheets.
- Material touch/ripple feedback and explicitly configured bouncing list
  scrolling on the primary screens.
- Accessible labels/tooltips on some controls and four widget tests.

**Not present:**

- Sound-effect playback. No sound package or audio asset is configured.
- Explicit haptic-feedback hooks, scale/elevation press animations, or
  loading/success/error button state machine.
- Real listing, location, event, news, transport, map, order, or user data.
- API calls, persistence, authentication, offline cache, or backend error
  handling.
- Phone/email/location permissions, map SDK configuration, or push setup.
- Separate customer, driver, business, or administrator workflows.

Material's normal button and ink response is present; it should not be
described as custom sound, haptics, or transactional feedback.

## Design-system inventory

- Material 3 theme; green seed/forest primary, off-white canvas, dark green
  body text, muted secondary text.
- Roboto font family; no bundled custom typeface.
- White rounded category cards, category-tinted icon backgrounds, a green
  gradient welcome banner, and a white bottom navigation surface.
- Compact, two-column home category grid and list-based Explore results.
- Material `InkWell`, `FilledButton`, chips, icon buttons, and a bottom sheet.
- Primary list screens explicitly use `BouncingScrollPhysics` with
  `AlwaysScrollableScrollPhysics`.

Preserve this recognizable palette, type, hierarchy, compact density, card
language, material ripple behavior, and elastic scrolling as architecture is
introduced. Improve accessibility, touch target sizes, responsive behavior,
and state feedback without replacing the design.

## State, data, and architecture assessment

- One stateful screen class owns navigation index, query text, selected
  category, and a `Set<String>` of saved category names.
- Category definitions and aliases are constants in the same file as widgets.
- Search/filter logic lives in a computed getter rather than a testable
  service/repository.
- The project is currently a single-file UI prototype, not a modular
  application architecture.
- There are no domain models or canonical IDs. A category is not a business,
  place, provider, or map feature.
- Fixed text `Makambako, Njombe` is presentation context only; it is not a
  validated town/area record or device location.
- No persistent or server-side state exists. Bookmarks are categories, not
  saved businesses or places.

The next implementation should extract only the discovery slice and shared
location contract it needs. Avoid premature microservices or a wholesale
state-management/navigation replacement.

## UX, privacy, trust, and readiness

- The current screens do not request device location; this avoids unexpected
  tracking but also means the displayed location is not personalized or
  verified.
- Android manifest and iOS `Info.plist` currently contain no location
  permission declarations or user-facing permission explanations.
- There are no user accounts, personal records, credentials, payment data,
  or third-party API keys in the inspected Flutter configuration.
- No back-end authorization, business verification, audit trail, abuse
  reporting, dispute flow, or data-deletion process exists.
- No offline/cache behavior or network failure states are implemented.
- Accessibility has not had a dedicated audit; some labels exist, but touch
  targets, screen-reader order, contrast, text scaling, and localization need
  verification.

Before collecting precise user locations or sensitive operational data, define
consent, purpose, access control, retention, deletion, and applicable Tanzanian
privacy/legal review. Manual area selection must remain possible.

## Existing checks

Run against the existing working tree on 2026-10-17:

| Check | Result |
| --- | --- |
| `flutter analyze` | Passed; no issues found |
| `flutter test` | Passed; 4 widget tests |
| Android emulator | Existing app was running; this audit made no UI/code changes |

These are baseline results, not proof of production readiness or backend/map
behavior.

## Audit conclusions

1. Keep Flutter and the current brand/design.
2. Treat the uncommitted search/category evolution as user work to preserve.
3. Treat the UI as a prototype; do not call category aliases “unified search”
   over actual local records.
4. Establish a canonical, permission-aware location/domain contract before
   integrating search and a map.
5. Choose backend, map/geocoding, data sourcing, and privacy rules explicitly
   before adding external services or credentials.
6. Implement one vertical discovery workflow, test it end-to-end, and defer
   transactions and operator dashboards to later phases.

## Phase One worktree update

- Added canonical place, linked entity, location, geographic-area, provenance,
  and verification models with optional coordinates.
- Added repository operations for ranked search, map-bounds queries, and
  canonical ID lookup. Category and manually supplied area IDs can be passed
  through the same filter contract without requesting device location.
- Added deterministic exact/prefix/alias/partial ranking and typed
  not-configured, timeout, and server-error outcomes.
- The Flutter UI shows place results only from the repository and visibly
  labels development fixtures. Its default repository is intentionally
  unconfigured; no real records or sample businesses ship in the app.
- An unavailable-map notice is shown; no map SDK, tiles, markers, attribution,
  or location permission has been added. A selectable area directory is not
  implemented because no authoritative area data source is approved.
- Search-to-detail and shared search/bounds/lookup identity are tested with
  synthetic test-only data. Live acceptance criteria remain blocked on
  approval of the data source, backend, map provider, and area directory.

See [ARCHITECTURE.md](./ARCHITECTURE.md) for the proposal and decision record,
and [ROADMAP.md](./ROADMAP.md) for phase gates and measurable acceptance
criteria.
