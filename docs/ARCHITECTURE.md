# KooBus — Architecture

This document explains where code belongs and how a request flows through
the system. Read it before adding a new file.

---

## 1. Big picture

```
┌─────────────────┐        HTTPS/JSON        ┌──────────────────┐
│  Flutter app    │  ──────────────────────▶ │  PHP REST API    │
│  (parent phone) │  ◀────────────────────── │                  │
└─────────────────┘                          │                  │
                                             │   MySQL          │
┌─────────────────┐        HTTPS/JSON        │   (source of     │
│  Flutter app    │  ──────────────────────▶ │    truth)        │
│  (driver phone) │  ◀────────────────────── │                  │
└─────────────────┘                          └──────────────────┘
```

- The two phones **never** talk to each other directly. All communication
  goes through the API. A Dart stream/local variable cannot reach another
  phone.
- The Flutter app **never** knows database credentials and never connects to
  MySQL.
- MySQL is the source of truth. The API enforces authentication, authorization
  and business rules.

---

## 2. Flutter folder structure (`lib/`)

| Folder | Responsibility | Examples |
|---|---|---|
| `app/` | App-level configuration: theme, named routes, root app widget | `app_theme.dart`, `app_routes.dart` |
| `core/config/` | Environment configuration (API base URL, timeouts) | `app_config.dart` |
| `core/constants/` | Constant values shared by the app | `app_constants.dart`, `api_endpoints.dart` |
| `core/network/` | HTTP client, response envelope, API exceptions | `api_client.dart`, `api_exception.dart` |
| `core/storage/` | Local persistence (secure session, offline queue) | `session_service.dart` |
| `core/utils/` | Pure functions: validators, date/time helpers, distance math | `validators.dart` |
| `core/widgets/` | Reusable UI pieces with no business logic | `app_button.dart`, `app_loader.dart` |
| `models/` | Data classes + JSON serialization. No logic beyond parsing. | `child_model.dart`, `trip_model.dart` |
| `services/` | External systems: HTTP calls, GPS, notifications, storage | `auth_service.dart`, `location_service.dart` |
| `controllers/` | `ChangeNotifier` business state shared across screens | `auth_controller.dart` |
| `screens/` | Top-level pages (only if a page is not feature-specific) | — |
| `widgets/` | Reusable UI components used by multiple features | — |
| `features/<feature>/screens/` | Pages that belong to one feature | `features/parent/screens/...` |
| `features/<feature>/controllers/` | State used only by that feature | `features/parent/controllers/...` |
| `features/<feature>/services/` | API calls for that feature | `features/parent/services/...` |
| `features/<feature>/widgets/` | Widgets used only by that feature | `features/parent/widgets/...` |

**Rule of thumb:** if it is used by one feature only, keep it inside
`features/<feature>/`. If it is used by two or more features, move it to
`core/`, `models/`, `services/` or `controllers/`.

---

## 3. Layers and responsibilities

### Screen (UI)
- Builds widgets, reads user input, shows loading/error/empty states.
- Reads state with `context.watch<T>()`, triggers actions with
  `context.read<T>()`.
- **Never** calls `http`, MySQL, GPS or the Keystore directly.

### Controller (state)
- `ChangeNotifier`. Owns business state (logged in? which child selected?
  trip running?).
- Calls services, then calls `notifyListeners()`.
- Does not know about widgets or `BuildContext` (except where navigation is
  unavoidable, and then only in the screen).

### Service (external world)
- Talks to HTTP, GPS, notifications, secure storage, local database.
- Returns models or throws typed exceptions.
- Does not call `notifyListeners()` and does not decide UI.

### Model (data)
- Plain Dart classes with `fromJson` / `toJson`.
- Field names must match the API contract exactly. If a name changes, the
  Flutter model, PHP response and MySQL column change together.

---

## 4. Request flow example (future real login)

```
LoginScreen (user taps "Ingia")
      │
      ▼
AuthController.signIn(phone, password)
      │
      ▼
AuthService.login(phone, password)          ← core/network/api_client.dart
      │  POST /api/v1/auth/login
      ▼
PHP controller → validation → AuthService (server) → MySQL
      │  200 OK { "token": "...", "user": {...} }
      ▼
AuthController stores token via SessionService (secure storage)
      │
      ▼
notifyListeners() → LoginScreen rebuilds → navigation to home
```

Parent tracking flow:

```
ParentHomeScreen → TripController.refresh()
      → TripService.getLatestLocation(tripId)
      → GET /api/v1/trips/{id}/location  (Bearer token)
      → PHP verifies: is this user an authorized guardian of a child
        on this trip?  (no → 403)
      → MySQL latest trip_locations row
      → JSON { "lat": ..., "lng": ..., "recorded_at": ... }
      → Controller marks data fresh/stale → map widget shows bus
```

---

## 5. Non-negotiable rules

1. No secrets in the Flutter app: no DB password, no server API key, no
   service account JSON.
2. Never trust IDs sent by the app. The server checks `child_id`, `trip_id`,
   `school_id` against the authenticated user every time.
3. One source of field names: DB → API → model. Document changes in
   `DECISIONS.md`.
4. Offline data is cached data, not live data. Always show the timestamp.
5. Development fixtures must be labelled as such in the UI. Production flows
   must not use them.
6. A feature is "done" only when its tests pass — and "verified" only when
   tried on a real device with a real backend.

---

## 6. Current state (as of Phase 3)

- Implemented: splash, login (validation + DEV session), parent home
  placeholder, session persistence + logout, validators.
- Not implemented yet: PHP API, MySQL, real authentication, GPS, trips, map,
  notifications, offline queue, driver screens.

See `CHECKLIST.md` for the full list and `DECISIONS.md` for why things are
the way they are.
