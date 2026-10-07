# Sasvyn

**A modular Apple-platform workspace for building, organizing, and presenting professional portfolios.**

Sasvyn brings projects, work history, education, skills, languages, documents, device mockups, profile information, and social links into a native SwiftUI application. Its Swift Package Manager monorepo separates shared domain and infrastructure capabilities from platform-specific feature packages.

> **Project status:** iOS is the primary product surface. Shared local persistence and REST synchronization are implemented for selected domains. An authenticated WebSocket client is wired into the iOS app, with realtime UI handling currently limited to part of the Skills flow. macOS composition exists, but its feature surface is still early scaffolding.

| Snapshot | Current implementation |
| --- | --- |
| Apple platforms | iOS and macOS app configurations; iPhone is the configured iOS device family. |
| UI and state | SwiftUI and The Composable Architecture (TCA). |
| Shared packages | 23 packages under `Sasvyn/Modules`. |
| iOS packages | 18 feature/composition packages under `Sasvyn/iOS`. |
| macOS packages | 3 composition packages under `Sasvyn/macOS`. |
| Persistence | GRDB-backed local database plus package-owned asset storage. |
| Remote data | NetworkKit-backed HTTP APIs and a reusable reconciliation engine. |
| Realtime | URLSession WebSocket transport with a partial Skills event consumer. |
| Package toolchain | Swift tools version 6.4; the app target is configured for iOS/macOS 26. |

## Contents

- [Highlights](#highlights)
- [Project status](#project-status)
- [Design references](#design-references)
- [Product areas](#product-areas)
- [Architecture](#architecture)
- [Repository layout](#repository-layout)
- [Package catalog](#package-catalog)
- [Application lifecycle](#application-lifecycle)
- [Data, persistence, and sync](#data-persistence-and-sync)
- [Realtime and multi-device updates](#realtime-and-multi-device-updates)
- [Apple platform integrations](#apple-platform-integrations)
- [Requirements](#requirements)
- [Getting started](#getting-started)
- [Build and test](#build-and-test)
- [Fastlane](#fastlane)
- [Configuration and signing](#configuration-and-signing)
- [Current limitations](#current-limitations)
- [Contributing](#contributing)
- [License](#license)

## Highlights

- **Portfolio-focused:** Organize projects, work history, education, skills, languages, documents, mockups, profile details, and social links.
- **Native presentation:** SwiftUI application roots for iOS and macOS, with the current feature surface primarily implemented in iOS packages.
- **Modular by responsibility:** Shared domain and infrastructure packages are separated from platform-specific feature packages.
- **Local data first:** GRDB-backed persistence and package-owned file-storage helpers keep domain data and assets organized.
- **Domain synchronization:** Local-first REST synchronization currently covers skills, languages, social links, and personal information, using reconciliation, conflict handling, retry, and pending-change metadata.
- **Realtime foundations:** An authenticated WebSocket client carries typed events and identifies the connecting client; current UI event handling is intentionally narrower than the event catalog.
- **System entry points:** iOS quick actions, App Intents/Shortcuts, and Core Spotlight can route into app features.

## Project status

The repository is an active product codebase, not a completed cross-platform release. The iOS app has the broadest user-facing feature set. Shared packages provide reusable persistence, networking, authentication, sync, and presentation infrastructure. The macOS roots and share-extension directory should be treated as scaffolding rather than feature parity.

Realtime delivery and REST synchronization are separate paths. A WebSocket connection does not by itself synchronize every domain: domain writes still use their repositories and HTTP endpoints, while realtime events are consumed only where a feature explicitly subscribes and handles them. See [Realtime and multi-device updates](#realtime-and-multi-device-updates) for the exact current boundary.

## Design references

The repository includes early visual explorations. These are design references, **not screenshots of the current application**, and some of the screens or controls shown may not be implemented.

<details>
<summary>View the portfolio dashboard and portfolio-list concepts</summary>

<p align="center">
  <img src="Designs/image.png" alt="Early portfolio dashboard design concept, not a screenshot of the current application" width="320" />
  <img src="Designs/portfolios.png" alt="Early portfolio-list design concept, not a screenshot of the current application" width="320" />
</p>

</details>

## Product areas

| Area | Current capabilities |
| --- | --- |
| Home | Dashboard, recent projects, and portfolio creation entry points. |
| Portfolio | Portfolio presentation with project and experience sections. |
| Projects | Project overview, description, role, app information, screenshots, screenshot ordering, and technology stack. |
| Experience | Work history, responsibilities, dates, and edit forms. |
| Education | Education records, grades, lists, and forms. |
| Skills | Skills and categories, grouped presentation, add flows, and chips. |
| Languages | Language selection, proficiency, lists, cards, and edit forms. |
| Documents | Document categories, local files, document cards, and PDF previews. |
| Mockups | Device selection, image placement, presentation modes, previews, and export-related behavior. |
| Personal information | Profile details, name and birth-date editing, and profile-image handling. |
| Social links | Typed links and add/edit flows for common social and portfolio services. |
| Settings | Appearance preferences, tint selection, and personal-information destinations. |

## Architecture

The application uses **The Composable Architecture (TCA)** for feature state, actions, reducers, navigation, and dependency access. Shared packages own domain behavior and infrastructure; platform packages compose those capabilities into views and app flows.

```mermaid
flowchart TD
    App["Sasvyn SwiftUI app"] --> AppDI["SVAppDIContainer"]
    AppDI --> IOSRoot["iOSRootKit"]
    AppDI --> MacRoot["macOSRootKit"]
    AppDI --> Realtime["SVRealtimeKit"]
    IOSRoot --> IOSFeatures["iOS feature packages"]
    MacRoot --> MacFeatures["macOS main/auth packages"]
    IOSFeatures --> Shared["Shared domain and UI packages"]
    MacFeatures --> Shared
    Shared --> Domain["Entities, repositories, use cases"]
    Domain --> Storage["SVDatabaseKit / GRDB"]
    Domain --> Network["SVNetwork / HTTP APIs"]
    Domain --> Sync["SVSyncKit reconciliation"]
    Sync --> API["REST backend"]
    Realtime --> Socket["URLSession WebSocket"]
    Socket <--> API
    IOSFeatures --> Design["SVDesignSystem"]
    App --> System["App Intents, Spotlight, scene actions"]
```

  The REST path is used for domain reads and writes and selected-domain reconciliation. The WebSocket path is a separate event stream; it does not replace persistence or the sync engine.

### Typical package boundaries

Domain packages commonly group code by responsibility:

```text
Domain/
  Entities/       Domain value types
  Repositories/   Repository contracts
  UseCases/       Application operations
Data/
  Sources/        Local and/or remote data sources
  Repositories/   Repository implementations
  DTOs/           Network request and response models
  Endpoints/      HTTP endpoint definitions
Database/
  Records/        Persisted record types
  Mappers/        Record/domain conversion
  Migrations/     Schema creation and evolution
DI/
  Clients/        TCA dependency clients
  Containers/     Dependency registration and composition
Presentation/     Reusable views, where applicable
```

The exact folder set varies by package; not every module implements every layer. Swift Package manifests declare Swift tools version **6.4**. The app target itself currently sets Swift language version 5 and enables approachable concurrency/default main-actor isolation; individual packages may opt into Swift 6 language mode.

## Repository layout

```text
.
|-- Designs/                          Early visual explorations
|-- Sasvyn.xcodeproj/                 Xcode project and shared scheme
|   \-- xcshareddata/xcschemes/       Shared Sasvyn scheme
|-- Sasvyn/
|   |-- App/                          SwiftUI, app delegate, and scene delegate
|   |-- Assets.xcassets/              App-level assets
|   |-- Modules/                      Shared domain, infrastructure, and UI packages
|   |-- iOS/                          iOS feature and composition packages
|   \-- macOS/                        macOS root, main, and auth packages
|-- SasvynTests/                      Xcode unit-test target
|-- SasvynUITests/                    Xcode UI-test target
|-- SasvynShareExtension/             Share-extension localization scaffold
|-- fastlane/                         Simulator and iPhone build lanes
|-- Gemfile                           Fastlane dependency
|-- ExportOptions.plist               Development export settings
|-- LICENSE                           MIT License
\-- README.md
```

The Xcode project currently defines the `Sasvyn`, `SasvynTests`, and `SasvynUITests` targets. `SasvynShareExtension` is a localization scaffold, not a configured Xcode target. Shared Swift package pins are stored under `Sasvyn.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`.

## Package catalog

There are currently **23 shared packages**, **18 iOS packages**, and **3 macOS packages**.

### Shared packages - `Sasvyn/Modules`

| Package | Responsibility |
| --- | --- |
| `AuthKit` | Apple Sign In authentication, auth session state, repository, client, and use cases. |
| `SVAboutKit` | About/profile content, local persistence, repository, migration, and use cases. |
| `SVDatabaseKit` | GRDB-backed database abstraction, migrations, records, CRUD, filtering, sorting, and observation. |
| `SVDesignSystem` | Shared SwiftUI controls, visual primitives, colors, fonts, symbols, spacing, and empty states. |
| `SVDIInfra` | App-level dependency composition and database/network/domain container wiring. |
| `SVDocumentKit` | Document entities/categories, local file storage, persistence, and document use cases. |
| `SVEducationKit` | Education records, grade types, persistence, repository, and CRUD use cases. |
| `SVExperienceKit` | Work experience and responsibilities, persistence, repository, and CRUD use cases. |
| `SVFoundation` | Shared extensions, date formats, file-storage helpers, property wrappers, and quick-action types. |
| `SVHomeKit` | Shared home-domain support and repository abstractions. |
| `SVLanguageKit` | Language/proficiency models, bundled language data, persistence, repository, and language use cases. |
| `SVMockupKit` | Mockup/device models, image storage, Photos integration, rendering modes, preview UI, and export support. |
| `SVNetwork` | HTTP environment resolution, auth/token wiring, refresh and upload support, DTOs, and network status. |
| `SVPersonalInformationKit` | User profile domain, local/remote sources, endpoints, persistence, image handling, and sync metadata integration. |
| `SVPortfolioKit` | Reusable portfolio cards and chip presentation components. |
| `SVProjectKit` | Projects, categories, screenshots, skills, persistence, storage, migrations, and use cases. |
| `SVRemoteImage` | SwiftUI remote-image loading and caching abstraction. |
| `SVRealtimeKit` | Authenticated WebSocket connection, connection state, typed event messages, and async message streams. |
| `SVShortcutsKit` | App Shortcuts provider and project/mockup creation intents. |
| `SVSkillsKit` | Skills, categories, grouped models, persistence, migrations, and use cases. |
| `SVSocialLinkKit` | Social-link models/types, persistence, repository, CRUD use cases, and service icons. |
| `SVSpotlightKit` | Spotlight items/destinations, indexing client, and destination mapping. |
| `SVSyncKit` | Generic sync engine, local/remote store contracts, metadata, pending changes, conflict resolution, and retries. |

### iOS packages - `Sasvyn/iOS`

| Package | Responsibility |
| --- | --- |
| `iOSAboutKit` | About screen and editable profile content. |
| `iOSAppearanceKit` | Appearance mode and tint selection. |
| `iOSAuthKit` | Sign-in feature and authentication screen. |
| `iOSDocumentsKit` | Document list, categories, cards, and PDF thumbnail views. |
| `iOSEducationKit` | Education list, cards, and forms. |
| `iOSExperienceKit` | Experience list, cards, and forms. |
| `iOSHomeKit` | Dashboard, recent projects, and quick-action entry points. |
| `iOSLanguageKit` | Language list, picker, cards, and forms. |
| `iOSLibraryKit` | Library destinations aggregating profile and portfolio-related areas. |
| `iOSMainKit` | Main tab and navigation composition. |
| `iOSMockupKit` | Mockup list, creation, device picker, and presentation modes. |
| `iOSPersonalInformationKit` | Personal-information screen and profile editors. |
| `iOSPortfolioKit` | Portfolio root, project/experience sections, and featured cards. |
| `iOSProjectKit` | Project list and project editing flows. |
| `iOSRootKit` | iOS root feature, dependency container, and auth/main-flow switching. |
| `iOSSettingsKit` | Settings root and destinations. |
| `iOSSkillsKit` | Skills list, add flow, modes, and chips. |
| `iOSSocialLinkKit` | Social-link list and add/edit forms. |

### macOS packages - `Sasvyn/macOS`

| Package | Responsibility |
| --- | --- |
| `macOSAuthKit` | macOS authentication package scaffold. |
| `macOSMainKit` | macOS main feature and view. |
| `macOSRootKit` | macOS root feature, dependency composition, and main-flow assembly. |

## Application lifecycle

The entry point is [`SasvynApp.swift`](Sasvyn/App/SasvynApp.swift).

1. `SasvynApp` creates the shared `SVAppDIContainer`.
2. Compile-time platform selection constructs `iOSRootDIContainer` or `macOSRootDIContainer`.
3. The selected root container creates the initial view and feature hierarchy.
4. The root container is exposed to the app delegate for supported external actions.
5. The SwiftUI window is configured with a default size of 1200 x 800 and content-driven minimum sizing.

On iOS, [`SceneDelegate.swift`](Sasvyn/App/SceneDelegate.swift) receives quick actions, Spotlight activities, and App Intents, then dispatches recognized actions into the root feature. Unknown quick-action identifiers are ignored.

## Data, persistence, and sync

`SVDatabaseKit` provides the shared persistence abstraction over GRDB. Domain packages own their records and migrations, map persisted values to domain entities, and expose operations through repository/use-case and TCA dependency layers. Local documents, project screenshots, profile images, and mockup assets use file-storage helpers rather than being treated as ordinary database values.

### Domains currently integrated with REST synchronization

The shared `SVSyncKit` engine is currently wired into these repositories:

| Domain | Current integration |
| --- | --- |
| Skills | Local data is emitted first; fetch reconciles with the remote store. Create, update, and delete enqueue metadata and start an entity sync. |
| Languages | Local data is emitted first; fetch reconciles with the remote store. Create, update, and delete enqueue metadata and start an entity sync. |
| Social links | Local data is emitted first; fetch reconciles with the remote store. Create, update, and delete enqueue metadata and start an entity sync. |
| Personal information | Current-user fetch reconciles by user ID; profile and image updates are persisted locally and synchronized through the remote store. |

Other domains currently use their local data paths and should not be assumed to synchronize remotely. The repository does not currently provide a general background-sync scheduler; sync is initiated by these repository fetch and mutation flows.

`SVSyncKit` defines reusable synchronization contracts:

- `SyncableEntity` supplies an entity identity, sync version, and update timestamp.
- `SyncLocalStore` and `SyncRemoteStore` abstract local and remote operations.
- `DefaultSyncEngine` reconciles local and remote state, coordinates per-entity requests, and supports bulk and pending-change synchronization.
- `SyncConflictResolver` decides how conflicting versions are resolved.
- `SyncRetryPolicy`, `SyncRetryStrategy`, and `SyncSleeper` control retry classification and backoff.
- `SyncMissingRemoteStrategy`, `SyncMetadataStore`, and sync-state types handle missing entities and persisted sync status.
- Operation IDs and pending-change context support idempotent retries.

The app-level dependency container shares a metadata store across the integrated domains. Each repository owns when it fetches or schedules entity-level sync; the generic engine does not automatically enroll every package.

## Realtime and multi-device updates

`SVRealtimeKit` provides a URLSession WebSocket transport, typed `RealtimeEvent`/`RealtimeMessage` models, connection state, and an `AsyncStream` fan-out for message subscribers. `SVDIInfra` registers it as a TCA dependency. The iOS main feature starts the connection when it appears, using the configured `wss://api.vijaythakur.online/api/v1/ws` endpoint. The connection attaches a Bearer access token and the stored `X-Client-ID` when available.

The client currently has this event catalog:

- Skills: `skill.created`, `skill.updated`, `skill.deleted`.
- Languages: `language.created`, `language.updated`, `language.deleted`.
- Projects: `project.created`, `project.updated`, `project.deleted`.

**Current delivery scope:** The iOS Skills feature is the only UI consumer found in the repository. It applies incoming `skill.created` and `skill.deleted` events. `skill.updated` is not yet applied, and the Language and Project events currently have no feature consumers. The realtime client exposes an outbound send API, but app mutations currently go through HTTP repositories; there is no app-level `realtimeClient.send` call in the current source.

This is a multi-device-ready transport foundation, not yet a guarantee of complete multi-device synchronization. Other devices can reflect a change only when the backend emits the corresponding event and the receiving app has a consumer for it. After an established socket disconnects, the current client marks itself disconnected but does not run an automatic reconnect/backoff loop. During initial connection, it makes one retry after attempting token refresh. Realtime package tests are currently scaffolding rather than behavior coverage.

## Apple platform integrations

### Quick actions

The current iOS `Info.plist` declares two home-screen quick actions: **New Project** and **Create Mockup**. Scene handling maps known action identifiers to root actions.

### App Intents and Shortcuts

`SVShortcutsKit` declares project-creation and mockup-creation intents and exposes them through an App Shortcuts provider. Scene launch and active-scene handling route the recognized intents to the same root action system.

### Core Spotlight

`SVSpotlightKit` defines searchable items and destinations. Spotlight activities are decoded by the iOS scene delegate and dispatched to the root feature for navigation.

### Appearance and media

The iOS appearance feature provides appearance and tint choices. Photo-library access is declared for selecting images for mockups and profile pictures. The app also includes device mockup assets and shared image/viewer components.

## Requirements

- A macOS development machine with Xcode and Apple-platform SDKs compatible with the project.
- Swift tools version **6.4** for the package manifests.
- iOS **26** and macOS **26** deployment targets for the app. Individual package platform declarations can differ; check the owning `Package.swift` when working at package level.
- The Xcode test targets currently specify deployment targets of **27.0**; an eligible newer simulator/runtime may be needed to run those targets.
- Ruby and Bundler are needed only for the Fastlane workflows.
- A configured Apple development team and signing setup are needed for signed device builds.

The app target currently supports iOS, iOS Simulator, and macOS in the Xcode project. Its current iOS device family is iPhone (`TARGETED_DEVICE_FAMILY = 1`); do not infer iPad support from the presence of iOS packages alone.

## Getting started

```bash
git clone https://github.com/thakur-vijay/sasvyn.git
cd sasvyn
open Sasvyn.xcodeproj
```

In Xcode:

1. Select the shared **Sasvyn** scheme.
2. Select an installed iOS Simulator, eligible iOS device, or macOS destination.
3. Let Xcode resolve the Swift packages.
4. For device runs, select a development team in Signing & Capabilities.

The local packages are declared through the Xcode project and their own manifests. For a package-level change, run package commands from that package directory; for app integration, build from the root Xcode project.

## Build and test

### Discover destinations

```bash
xcodebuild \
  -project Sasvyn.xcodeproj \
  -scheme Sasvyn \
  -showdestinations
```

### Build the app

Replace the example simulator with one reported by `-showdestinations`:

```bash
xcodebuild \
  -project Sasvyn.xcodeproj \
  -scheme Sasvyn \
  -destination 'platform=iOS Simulator,name=iPhone 14 Plus' \
  build
```

For a macOS build, use `-destination 'platform=macOS'`. A device build requires valid signing credentials:

```bash
xcodebuild \
  -project Sasvyn.xcodeproj \
  -scheme Sasvyn \
  -destination 'generic/platform=iOS' \
  build
```

### Run Xcode tests

The shared scheme includes `SasvynTests` and `SasvynUITests`. Choose a simulator compatible with the test targets' current deployment target:

```bash
xcodebuild \
  -project Sasvyn.xcodeproj \
  -scheme Sasvyn \
  -destination 'platform=iOS Simulator,name=iPhone 14 Plus' \
  test
```

### Run a package test suite

```bash
cd Sasvyn/Modules/SVSyncKit
swift test
```

The same command works in other package directories that declare tests, for example `Sasvyn/Modules/SVExperienceKit`.

### Test coverage notes

- `SVSyncKit` has focused tests for server-newer downloads, local-newer uploads, same-version conflict resolution, pending local changes, duplicate-request suppression, retries, and missing remote entities.
- `SVExperienceKit` tests that a currently active experience clears its end date.
- `SVRealtimeKit` currently contains a generated placeholder test and does not yet have focused WebSocket behavior tests.
- The app unit-test file and UI-test file are still Xcode-generated scaffolding; they do not yet provide broad product behavior coverage. Several package test targets are also placeholders.

## Fastlane

The root `Gemfile` declares Fastlane. Install it and run one of the build-only lanes:

```bash
bundle install
bundle exec fastlane ios simulator
bundle exec fastlane ios iphone
```

`simulator` cleans and builds using the configured **iPhone 14 Plus** simulator destination. `iphone` cleans and builds for `generic/platform=iOS`. These lanes do not archive, distribute, or upload a release. [`ExportOptions.plist`](ExportOptions.plist) currently describes a development export.

## Configuration and signing

| Path | Purpose |
| --- | --- |
| `Sasvyn/Info.plist` | App metadata and the two declared iOS home-screen quick actions. |
| `Sasvyn/Sasvyn.entitlements` | Apple Sign In entitlement. |
| `Sasvyn.xcodeproj/project.pbxproj` | App/test targets, package products, deployment settings, and signing settings. |
| `Sasvyn.xcodeproj/xcshareddata/xcschemes/Sasvyn.xcscheme` | Shared build, launch, and test scheme. |
| `Sasvyn.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved` | Resolved Swift package versions. |
| `Sasvyn/Modules/SVDIInfra/Sources/SVDIInfra/SVAppDIContainer.swift` | App-level dependency composition, including the current realtime WebSocket URL. |
| `Sasvyn/Modules/SVNetwork/Sources/SVNetwork/EnvironmentResolver.swift` | HTTP API environment-to-base-URL mapping. |
| `Gemfile` | Ruby dependency declaration for Fastlane. |
| `fastlane/Appfile` | Fastlane app identity settings. |
| `fastlane/Fastfile` | Simulator and generic iPhone build lanes. |
| `ExportOptions.plist` | Development export configuration. |

The app target currently uses automatic signing and a project-configured development team. The configured app bundle identifier is `com.artist.yattsTest`; review both values and select your own team/identifier before using the project in another Apple Developer account. Do not commit personal credentials, private tokens, provisioning profiles, or machine-specific signing material.

The network container currently selects the development environment in code. The environment resolver maps the declared environment cases to the same configured API base URL today; treat staging/production separation as unfinished until that configuration is deliberately changed and verified.

## Current limitations

- The macOS root/main packages exist, but `macOSAuthKit` is a scaffold and the macOS feature surface is not equivalent to iOS.
- `SasvynShareExtension` contains localization scaffolding only; it is not an Xcode target.
- REST synchronization is integrated for skills, languages, social links, and personal information; the other product domains should be treated as local-only until their repositories are explicitly integrated.
- WebSocket event handling is partial: only skill create/delete events currently update a feature, while skill updates and Language/Project event consumers remain unfinished. Multi-device delivery also depends on backend broadcasts.
- The realtime client does not automatically reconnect after an established connection drops, and app-side writes do not currently publish realtime messages directly.
- Development, staging, production, and custom HTTP environments currently resolve to the same API host. The WebSocket URL is also configured directly in the app dependency container.
- The current iOS device family is iPhone; iPad support is not configured.
- Broad app and UI behavior test coverage is still in progress.
- App/test deployment settings differ: the app is set to iOS/macOS 26, while Xcode test targets are set to 27.0.

## Contributing

When adding or changing a domain feature:

1. Keep domain entities, repository contracts, and use cases in the relevant shared package under `Sasvyn/Modules`.
2. Implement local/remote sources, DTOs, records, migrations, and mapping in the owning package as needed.
3. Register dependencies through the package client/container and app-level composition.
4. Put platform-specific reducers, views, and navigation in `Sasvyn/iOS` or `Sasvyn/macOS`.
5. Add focused package tests for domain and persistence behavior; add app/UI coverage for user-visible workflows.
6. Update this README when package responsibilities, platform support, setup, or automation change.

Keep changes scoped to the package that owns the behavior and verify them with that package's tests plus an app build when integration is affected.

## License

Sasvyn is distributed under the [MIT License](LICENSE).
