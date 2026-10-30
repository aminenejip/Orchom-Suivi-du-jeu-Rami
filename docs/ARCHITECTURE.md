# Architecture

Orchom follows a **layered architecture** inspired by Clean Architecture, kept deliberately simple for a score-keeping app: no DI framework, no code generation, just one-directional dependencies and a pure, unit-testable core.

## Overview

```
┌──────────────────────────────────────────────┐
│ presentation/                                │
│   screens · widgets · theme                  │
│        │  (watches ChangeNotifiers)          │
│        ▼                                     │
│ application/                                 │
│   GameController · GameSettingsController ·  │
│   ThemeController                            │
│        │  (calls domain services &           │
│        ▼   repository interfaces)            │
│ domain/          ◄──────────────────┐        │
│   entities · enums ·               │        │
│   repositories (interfaces) ·      │        │
│   services (GameEngine)            │        │
│        ▲                           │        │
│        │  (implements interfaces)  │        │
│ data/  ────────────────────────────┘        │
│   local (SQLite, audio, media) ·            │
│   repositories (implementations)            │
└──────────────────────────────────────────────┘
```

**Dependency rule:** `presentation → application → domain ← data`. The `domain` layer never imports Flutter, `sqflite`, or any platform package. `data` imports `domain`; `application` orchestrates both.

## Layers

### 1. Domain (`lib/domain`) — pure business rules

| Path | Responsibility |
|---|---|
| `entities/` | Immutable business objects: `Player`, `GameSession`, `GameConfig`, `RoundScore`, `QuickScoreButton`… with `copyWith` and (JSON) `toJson`/`fromJson` |
| `enums/` | `StarterMode` (rotation / random / manual), `AppThemeMode` |
| `repositories/` | Abstract contracts (`GameRepository`, `GameSettingsRepository`) implemented in `data/` |
| `services/` | `GameEngine` — validation, round scoring, winner/loser ranking, starter rotation |

`GameEngine` is the heart of the game logic:

- **`validateSetup`** — 2 or 4 players only, target score 1–10000, non-empty & unique player names.
- **`addRound`** — applies a round's scores to every player, records a `RoundScore`, advances the starter index (with reverse-rotation support), and finishes the game when any player reaches the target score.
- **`undoLastRound`** — rolls back the last round and reverses the starter rotation.
- **`getRanking` / `getWinner` / `getLoser`** — score sorting; the *loser* of Rami is the player who reached the target score (lower is better, so ranking is ascending).

Because this layer is pure Dart, `GameEngine` is covered by `test/domain/game_engine_test.dart` and runs in milliseconds without a device.

### 2. Data (`lib/data`) — persistence & platform glue

| Path | Responsibility |
|---|---|
| `local/app_database.dart` | `sqflite` database setup, schema and migrations |
| `local/database_init_*.dart` | Conditional database factory init: `sqflite_common_ffi` on desktop (`.io`), a no-op stub elsewhere — selected at compile time via `dart.library.io` |
| `local/quick_button_audio_service.dart` | Sound playback for quick score buttons using `audioplayers` |
| `local/media_storage.dart` | Saves player photos: converts uploads to JPEG (via `flutter_image_compress`/`image`), stores them in the app documents directory |
| `repositories/` | `GameRepositoryImpl` and `GameSettingsRepositoryImpl`, which serialize domain entities to/from JSON rows in SQLite |

The repositories depend only on the **abstract** interfaces from `domain`, so swapping the storage backend does not touch business logic.

### 3. Application (`lib/application`) — state management

Plain Flutter `ChangeNotifier` classes — no external state-management package:

- **`GameController`** — holds the active `GameSession`, delegates rule handling to `GameEngine`, persists through `GameRepository`.
- **`GameSettingsController`** — loads/saves the default settings (target score, ghalta penalty, quick buttons, theme preference, starter mode).
- **`ThemeController`** — theme mode switching.

Each controller is unit-tested (`test/application/*_test.dart`) with fake repositories.

### 4. Presentation (`lib/presentation`) — UI

- **`screens/`** — `HomeScreen` → `SetupScreen` (players, options) → `GameScreen` (score entry) → `ResultsScreen`; plus `HistoryScreen`, `GameSettingsScreen`, `LoadingScreen` and `PhotoPreviewScreen`.
- **`widgets/`** — a small in-house design system: every reusable component is prefixed `Orchom*` (`OrchomButton`, `OrchomCard`, `OrchomModal`, `OrchomToast`, score cards, round history, quick score button widget…).
- **`theme/`** — design tokens split into `app_colors`, `app_text_styles`, `app_spacing`, `app_shadows`, `app_animations`, assembled in `app_theme` (light + dark `ThemeData`).

Dependency wiring happens once in **`main.dart`** (constructor injection, no service locator): the database, repositories, engine, controllers and audio service are created there and passed down.

## Internationalization

- Config: `l10n.yaml` — generates `AppLocalizations` into `lib/l10n/generated/`.
- Translations: ARB files `app_en.arb` and `app_ar.arb` (English / Arabic).
- UI code imports the generated class and never hard-codes user-facing strings.

## Testing strategy

`test/` mirrors `lib/` one-to-one, layer by layer:

```
test/
├── application/   # controllers with fake repositories
├── data/          # repository implementations (SQLite via sqflite_common_ffi)
└── domain/        # GameEngine and entity rules — fast, pure tests
```

The stub/IO conditional-import pattern used for database initialization lets `sqflite_common_ffi` power both desktop builds **and** native unit tests.

## Design decisions worth knowing

- **Why `ChangeNotifier` instead of Riverpod/Bloc?** The app is small; constructor injection in `main.dart` keeps everything inspectable and removes dependencies on external packages.
- **Why immutable entities?** `GameEngine` never mutates state — it returns new `GameSession` objects via `copyWith`. This makes undo trivial (just don't commit the new session) and makes the engine stateless and re-entrant.
- **Why is the game finished when someone "reaches" the target?** In Tunisian Rami, accumulating points is bad; the first player to cross the target score loses, hence ascending ranking and `getLoser` being the showcase metric.
- **Why conditional imports for the database factory?** `sqflite` needs `sqflite_common_ffi` initializing on desktop platforms; the stub keeps web/unsupported targets compileable.
