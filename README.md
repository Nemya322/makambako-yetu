# Makambako Yetu

Makambako Yetu is a Flutter app concept for one connected way to discover
businesses, food, services, transport, places to stay, events, and community
resources in Makambako.

The current app includes:

- A Makambako-branded home screen with quick links into discovery.
- One search across discovery categories, including English and Swahili terms.
- A shared Makambako, Njombe location context for discovery.
- Explore category filters.
- A saved-items page for categories a user bookmarks during the session.
- A simple profile and app information page.

Categories are starting points for a connected local-services ecosystem; they
are not verified business listings. The app does not yet provide a live map,
account sync, nearby-device location, live transport data, or community
announcements.

The discovery feature now has canonical place/location models, a repository
contract, deterministic search ranking, and typed loading/error outcomes.
There is no approved listing source or backend configured, so the app
explicitly reports that place data is not connected instead of showing
invented businesses. Test-only sample records are visibly marked as
development fixtures. Map rendering and manual area selection in the UI are
still pending provider and data-source decisions.

## Project documentation

- [Current project audit](docs/PROJECT_AUDIT.md)
- [Proposed architecture and technical decisions](docs/ARCHITECTURE.md)
- [Phased roadmap and acceptance criteria](docs/ROADMAP.md)

## Run the app

```sh
flutter pub get
flutter run
```

## Run tests

```sh
flutter test
```
