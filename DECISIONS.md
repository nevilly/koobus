# KooBus — Technical Decisions Log

Every important technical decision is recorded here with its reason.
Format: date, decision, reason, files affected.

---

## 2026-10-21 — Memory settings reduced for Gradle

- **Decision:** Changed `org.gradle.jvmargs` in `android/gradle.properties`
  from `-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m`
  to `-Xmx2G -XX:MaxMetaspaceSize=1G -XX:ReservedCodeCacheSize=256m`.
- **Reason:** The machine has 7.8 GB RAM total. The old settings allowed a
  single Gradle daemon to claim 8 GB, which caused the OS/JVM to kill the
  Kotlin compiler daemon (`Connection to the Kotlin daemon has been unexpectedly lost`).
- **Files:** `android/gradle.properties`
- **Revisit when:** The project grows very large or a faster machine is used.

## 2026-10-21 — One Android build at a time

- **Decision:** Never run Gradle builds for two different projects at the same time.
- **Reason:** All Gradle builds share one cache directory
  (`C:\Users\dell\.gradle`) and hold an exclusive lock on it. An old project at
  `C:\Users\dell\Desktop\myAppu\koobus\koo\koobus` was running a build at the
  same time, causing `Timeout of 120000 reached waiting for exclusive access`.
- **Files:** none (process/workflow rule)
- **Revisit when:** never; this is a permanent rule.

## 2026-10-21 — NDK 28.2.13676358 required by the toolchain

- **Decision:** Keep `ndkVersion = flutter.ndkVersion` in
  `android/app/build.gradle.kts` and install NDK 28.2.13676358 through the
  new `android` CLI instead of the deprecated `sdkmanager.bat`.
- **Reason:** Flutter 3.47.5 + Android Gradle Plugin 9.1.0 expect this NDK
  version during project configuration. Commenting the line out did not remove
  the requirement (the Flutter Gradle plugin enforces it). The old
  `sdkmanager.bat` failed with `Failed to move temporary file to final destination`;
  the current tool is `android.exe` from cmdline-tools.
- **Files:** `android/app/build.gradle.kts`
- **Revisit when:** Flutter upgrades change `flutter.ndkVersion`.

## 2026-10-21 — First UI: KooBus splash screen

- **Decision:** Replaced the Flutter counter demo in `lib/main.dart` with a
  KooBus splash screen (blue gradient, bus icon, Swahili tagline
  "Usalama wa safari ya shule"). Kept `StatefulWidget` for the splash.
- **Reason:** Phase 1.2 requires one visible UI change so the beginner can see
  how `main()`, `runApp()`, `MaterialApp`, `Scaffold` and widgets fit together
  before adding business logic. Swahili text first because the target market
  is Tanzania.
- **Files:** `lib/main.dart`, `test/widget_test.dart`
- **Verified by:** `flutter analyze` (no issues) and `flutter test`
  (1 test passed). Note: this is *code written + test passed*, NOT yet
  *run on a physical device* — that is blocked on the NDK download.

## 2026-10-21 — Login screen, validators, splash→login navigation

- **Decision:** Built `lib/features/auth/screens/login_screen.dart`
  (StatefulWidget) with form validation via shared `Validators` class in
  `lib/core/utils/validators.dart`. Splash navigates to login after 2 s using
  `Future.delayed` + `Navigator.pushReplacement`. Login shows a clear SnackBar
  "Server bado haijaunganishwa" instead of fake success.
- **Reason:** Phase 2.2 requires learning TextField, validation and
  navigation through real KooBus UI. Validation lives in `core/utils` (not in
  widgets) so every screen can reuse it. Phone format is Tanzania-specific
  (+255 or 0, then 6 or 7). `pushReplacement` so the back button does not
  return to splash.
- **Files:** `lib/core/utils/validators.dart`,
  `lib/features/auth/screens/login_screen.dart`, `lib/main.dart`,
  `test/widget_test.dart`, `test/validators_test.dart`
- **Verified by:** `flutter analyze` clean; `flutter test` → 7 tests passed
  (validators unit tests + widget tests). Note: still NOT run on a physical
  device — blocked on NDK download.

## 2026-10-21 — Session persistence (stay logged in) + logout

- **Decision:** Added `provider` + `flutter_secure_storage`. Session is stored
  as JSON (token + phone) via `SecureSessionService` (Android Keystore /
  iOS Keychain), behind an abstract `SessionService`. `AuthController`
  (ChangeNotifier) owns auth state (`unknown`/`loggedOut`/`loggedIn`) and is
  provided app-wide with `ChangeNotifierProvider`. Splash restores the
  session and routes to home if a valid one exists, else to login.
  `InMemorySessionService` exists for tests only.
- **Reason:** Requirement: a user who logs in stays logged in after closing
  the app unless they explicitly logged out. `flutter_secure_storage` was
  chosen over `shared_preferences` because a session token is a secret —
  shared_preferences writes plaintext XML readable with file access;
  secure storage uses hardware-backed Keystore encryption. The abstract
  interface lets us swap in the real API token later (Phase 7) without
  touching controllers or screens.
- **Login token is clearly labelled DEV** (`DEV-TOKEN-DO-NOT-USE-IN-PRODUCTION`)
  because there is no backend yet (Phase 6/7). This is development-only and
  must be replaced by a real API-issued token before any real use.
- **Fix learned:** calling `notifyListeners()` while the widget tree is still
  building (e.g. directly in `initState`) throws
  `setState() or markNeedsBuild() called during build`. Splash therefore
  defers `_bootstrap()` with `addPostFrameCallback`. Also removed a redundant
  first `notifyListeners()` in `restoreSession` (state already starts at
  `unknown`).
- **Files:** `pubspec.yaml`, `lib/core/storage/session_service.dart`,
  `lib/core/storage/secure_session_service.dart`,
  `lib/controllers/auth_controller.dart`, `lib/main.dart`,
  `lib/features/auth/screens/login_screen.dart`,
  `lib/features/parent/screens/parent_home_screen.dart`, `test/widget_test.dart`
- **Verified by:** `flutter analyze` clean; `flutter test` → 9 tests passed,
  including the two critical scenarios: (1) login → restart app → still
  logged in; (2) login → logout → restart app → login required. Still NOT run
  on a physical device — blocked on NDK download.

## 2026-10-22 — Design system centralized in theme (Phase 4.1)

- **Decision:** All colors live in `lib/core/constants/app_colors.dart`, all
  spacing/radii in `lib/core/constants/app_spacing.dart`, and all widget
  styling in `lib/app/app_theme.dart` (`AppTheme.light`). Screens use theme
  values and the shared `AppButton`, `AppLoader`, `ErrorView` widgets instead
  of hard-coded `Colors.*`, `EdgeInsets.all(24)` or per-screen button styles.
- **Reason:** Consistency and one-place change. A hard-coded color on each
  screen drifts: this project already had `Colors.blue` in splash, login and
  home. The theme also encodes behaviour (button height 52, disabled while
  loading) once, so it is tested once.
- **Palette:** primary `#1565C0`, primaryDark `#0D47A1` (splash gradient),
  accent `#FFB300` (school-bus amber), background `#F5F7FA`, status colors
  success/warning/danger. Light theme only for now; dark theme is not MVP.
- **Files:** `lib/core/constants/app_colors.dart`,
  `lib/core/constants/app_spacing.dart`, `lib/app/app_theme.dart`,
  `lib/core/widgets/app_button.dart`, `app_loader.dart`, `error_view.dart`,
  `lib/main.dart`, `lib/features/auth/screens/login_screen.dart`,
  `lib/features/parent/screens/parent_home_screen.dart`,
  `test/design_system_test.dart`
- **Verified by:** `flutter analyze` clean; `flutter test` → 15 tests passed
  (theme colors, button height 52, input radius 12, button loading state,
  ErrorView retry). Not yet seen on a device (NDK blocked).

## 2026-10-22 — Parent bottom navigation: 5 tabs (Phase 4.2)

- **Decision:** The parent experience is a shell (`ParentShell`) with 5 tabs:
  Nyumbani, Watoto, Historia, Taarifa, Wasifu, using Material 3
  `NavigationBar` + `IndexedStack`.
- **Reason:** 5 is the maximum recommended number of bottom-navigation
  destinations. The five tabs answer the parent's daily questions: Where is the
  bus? Where are my children? What happened today? Did anything need my
  attention? What are my details and who may collect my children? Settings,
  language and logout live inside Wasifu instead of taking a sixth tab.
- **Child history** opens from Watoto (per child) and is summarised in
  Historia — boarding/alighting time, place and the supervising matron.
- **Files:** `lib/features/parent/screens/parent_shell.dart`, `tabs/*`,
  `child_history_screen.dart`, `widgets/trip_event_tile.dart`,
  `lib/core/widgets/dev_badge.dart`, `test/parent_shell_test.dart`,
  `test/widget_test.dart`.
- **Verified by:** `flutter analyze` clean; `flutter test` → 19 tests passed.
  Later confirmed on a physical device (see next entry).

## 2026-10-22 — Matron (bus attendant) is a first-class operational role

- **Decision:** Model the person who supervises children on the bus ("matron")
  separately from the driver. Boarding/alighting events will record who
  recorded them (`trip_events.recorded_by`) and a trip will link its crew
  (driver + matron).
- **Reason:** The driver is on the road and cannot safely confirm every child's
  boarding. Parents asked specifically to know *which matron* was supervising.
  A trip needs at least a driver (vehicle control) and a matron (child safety).
- **Consequence:** The Phase 5 ER design must include matron/attendant in
  `users.role` plus a trip-crew link. Until then the UI shows this as clearly
  labelled DEV data.
- **Files:** `lib/features/parent/dev/parent_demo_data.dart` (fields `matron`,
  `DemoTripEvent.matron`); `CHECKLIST.md` Phase 5.

## 2026-10-22 — Parent UI uses labelled DEV fixtures until the API exists

- **Decision:** All parent UI sample data comes from
  `lib/features/parent/dev/parent_demo_data.dart` (`DemoChild`,
  `DemoTripEvent`, `DemoGuardian`, `DemoAlert`). Every screen showing it also
  shows the "MFANO (DEV)" badge and says which phase will provide real data.
- **Reason:** Phase 4 is UI/UX; the database and API do not exist yet. We need
  realistic layouts to test scrolling, long school names and multiple children.
  The badge prevents anyone mistaking the data for live tracking.
- **Consequence:** Phase 5 replaces the `Demo*` classes with real models;
  Phase 6/7 replaces constants with API calls through controllers. No
  production screen may read `parent_demo_data.dart`.
- **Files:** `lib/features/parent/dev/parent_demo_data.dart`,
  `lib/core/widgets/dev_badge.dart`, all parent tabs.

## 2026-10-23 — First APK built and tested on a real phone (V2333)

- **Decision:** Build debug APKs with `flutter build apk --debug`; install with
  `adb install -r build\app\outputs\flutter-apk\app-debug.apk`.
- **Reason:** Phase 4 milestone: prove the app runs on real hardware before any
  backend work. `flutter run` is used while iterating (hot reload), `build apk`
  for a shareable file.
- **NDK saga (what went wrong, and the fix):** the 2.12 GB NDK download stalled
  twice. The lesson: **killing a PowerShell parent does not kill its child
  `curl.exe`** — an orphaned curl kept appending to the same `rem2` part file
  while a second download wrote to it, producing a wrong-size part. Fix: check
  `Get-CimInstance Win32_Process -Filter "Name='curl.exe'"` before assuming a
  download stopped, then verify **every** part size against its byte range
  before merging with `copy /b`. Final archive verified at exactly
  `748,118,221` bytes with 8103 zip entries before extraction.
- **First-build facts (useful for the future):** Gradle 9.3.1 distribution is
  695 MB (`.gradle` total 1.63 GB); NDK 2.12 GB. The first `assembleDebug` took
  **840.7 s** because Gradle auto-installed Android SDK Platform 36 + 35 and
  CMake 3.22.1. Later builds reuse them.
- **Files added to the SDK (by Gradle automatically):** `platforms/android-36`,
  `platforms/android-35`, `cmake/3.22.1`.
- **Verified by:** on device `10HE93F0RR001GL` (V2333, Android 16/API 36):
  splash → login → DEV login works; all 5 tabs (Nyumbani, Watoto, Historia,
  Taarifa [badge 2], Wasifu) render; `Historia yake` opens the per-child
  timeline with matron names; back returns correctly. APK is 151.8 MB (debug).
  Flutter logs confirm Impeller/OpenGLES renderer. Not yet verified: logout
  button (its position could not be located reliably through `uiautomator`
  dumps — needs a manual check), and nothing has been tested against a real
  server (none exists until Phase 6/7).

## 2026-10-24 — Internationalization (Kiswahili/English) with Flutter gen-l10n

- **Decision:** Use official Flutter localization (`flutter gen-l10n`) with `.arb` files. Kiswahili (`sw`) is the template/base locale (`template-arb-file: app_sw.arb`). Language selection lives in Profile (Wasifu) and is persisted via `LanguageService` (abstract + `SecureLanguageService` + `InMemoryLanguageService`) mirroring the session pattern (`flutter_secure_storage`).
- **Reason:** Compile-time safety (missing keys fail build), official tooling, no runtime JSON parsing. Keeping the same storage pattern avoids adding `shared_preferences` and makes testing easy. Material/Cupertino/Widgets localizations are included via `AppLocalizations.localizationsDelegates`.
- **Validators:** Changed from static getters to factories taking `AppLocalizations` (`Validators.phone(l10n)`, `Validators.password(l10n)`) plus a UI-free `Validators.isPhoneValid(String)`. The validation rules stay in one place; wording comes from the dictionary. Tests use `AppLocalizationsSw()`.
- **Widgets:** `ErrorView.title` made nullable (`String?`) with fallback to `l10n.errorTitle`. `DevBadge` now uses `l10n.devBadgeLabel`. `ParentShell` tab titles/labels read from `l10n` (no longer `const` lists), added tooltips. Tab accessibility labels become localized.
- **Demo data:** Identity/names/places remain untranslatable (`Amina Juma`, `Mbezi Beach`, `Bi. Neema`, school names). Labels/statuses/actions/dates become enums (`DemoChildStatus`, `DemoTripAction`, `DemoTripDay`) resolved via `l10n` (prevents string-matching bugs like checking for "panda" when switching languages). `DemoTripEvent` uses `DemoTripDay` instead of raw strings like `"Leo"`.
- **Files:** `l10n.yaml`, `l10n/app_sw.arb`, `l10n/app_en.arb`, `lib/l10n/*`, `lib/core/storage/language_service.dart`, `lib/controllers/language_controller.dart`, `lib/main.dart` (MultiProvider + `Consumer<LanguageController>` wraps `MaterialApp`), all localized parent/auth/core screens/widgets, updated tests.
- **Verified by:** `flutter gen-l10n` succeeded; `flutter analyze` — No issues found; `flutter test` — all tests passed (21 tests). Language picker added to Profile (Wasifu) with dialog, instant rebuild on change, SnackBar confirmation, persisted in secure storage.

## 2026-10-24 — Adapted PHP API framework to KooBus

- **Decision:** Use the existing PHP API framework under `htdocs/Api/api/v1/` (Routes → Controller → Module → Database) and adapt it gradually to KooBus without rewriting from scratch. Keep the same routing/response patterns.
- **Changes:** Updated `.rd` for KooBus (`koobuss` DB), rewrote `Table.php` with KooBus core schema (users, schools, buses, routes, route_stops, children, parent_children, trips, trip_events, locations, notifications, device_tokens). Adapted `UsersModule/Controller/Routes` to use `role` enum (parent/driver/matron/school_admin/super_admin) and `phone` field; simplified mobile-first login.
- **Reason:** Faster integration, follows existing proven structure, easier to deploy to XAMPP later.
- **Files:** `htdocs/Api/api/v1/.rd`, `htdocs/Api/api/v1/Table.php`, `htdocs/Api/api/v1/Module/UsersModule.php`, `htdocs/Api/api/v1/Controller/UsersController.php`, `htdocs/Api/api/v1/Routes/Users.php`, `htdocs/Api/README_KOOBUS_API.md`
- **Committed:** `0584aae` pushed to `https://github.com/nevilly/koobus.git`

## 2026-10-25 — Phase 7 authorization hardening + token expiry handling

- **Decision:** Centralize authorization in `Util/AuthGuard.php` (token + role check) and enforce parent-child scoping in the API; handle token expiry once in the Flutter network layer.
- **API changes:** `AuthGuard::requireAuth/requireRole/requireAny` used in `Users`, `Trips`, `TripEvents`, `Locations`, `Children`, `ParentChildren`, `Schools`, `Buses`, `Routes`. Parent access to children/trips/trip_events/locations is filtered through `parent_children` (and the child's `route_id` for trips/locations); unlinked IDs return `403`. Driver trip/location ownership enforced. Admin CRUD restricted to `school_admin`/`super_admin`.
- **Flutter changes:** Added `http`; new `lib/core/network/{api_config,api_exception,api_response,api_client}.dart`. `ApiClient` sends `Authorization: Owesis <token>`, maps the API’s `{status,payload}` envelope, and on `401` calls `onUnauthorized` (single-flight) which triggers `AuthController.signOut(expired: true)`; `403` does **not** log the user out. `TokenUtils` decodes JWT `exp` for proactive expiry; `StoredSession.expiresAt` persisted; `restoreSession()` clears expired sessions. `KooBusApp` is now stateful: creates `AuthController`, `LanguageController`, `ApiClient` once, and redirects to `LoginScreen` via `navigatorKey` when a session expires. Login shows a localized `sessionExpiredNotice`.
- **Reason:** Satisfy Phase 7 gates (server-side roles, parent-child isolation, ID tampering prevention, token expiry) before starting Phase 8.
- **Verified by:** `flutter analyze` (no errors), `flutter test` — 34 tests passed, including `test/api_client_test.dart`, `test/token_utils_test.dart`, `test/auth_session_expiry_test.dart`.
- **Follow-up (same day):** the remaining Phase 7 items above were closed by the
  school-tenancy/bootstrap work recorded in the next entry.

## 2026-10-25 — School tenancy, staff bootstrap and authentication bug fixes

- **Decision:** Treat `users.school_id` as the tenancy boundary and enforce it in one
  helper (`Util/Tenant.php`). `super_admin` is unrestricted; `school_admin` is limited to
  its own `school_id` and fails closed with `403` when it has none. Resource ownership is
  resolved through joins (`route.school_id`, `trips.driver_id`/`matron_id`,
  `parent_children`), never trusted from the request body.
- **Account creation:** public registration is limited to `parent`. `school_admin` may
  create `parent`/`driver`/`matron` only, forced into the caller's school. `super_admin`
  may create any role. The very first `super_admin` may self-register only while no
  `super_admin` exists; afterwards the endpoint requires `super_admin`.
- **Scoping added:** `Users` (list/get/update/delete, `get_users_by_roles`), `Buses`,
  `Routes`, `Schools` (writes; reads stay available to any authenticated user),
  `Children`, `ParentChildren`, `Trips`, `TripEvents`, `Locations`, `DeviceTokens`,
  `Notifications`. `DeviceTokens::remove` is owner-or-super_admin;
  `remove_by_user` is the school-scoped admin path for other users.
- **Auth bugs fixed:** `AuthGuard::user()` now handles the `mysqli_result` returned by
  `UsersModule::getUserIdByToken()` (it previously rejected every request);
  `Util::tokenValidate()` now compares `exp` with `time()`, uses `hash_equals`, checks
  for three JWT segments and strips malformed payloads; `base64UrlDecode` added.
  `Config.php` hides PHP errors in production; `Module/Database.php` no longer sets
  `error_reporting(1)`. Registration no longer calls
  `get_user_by_email_or_username('')` (empty value returned every user and blocked
  sign-ups); `phone` + `password` are required, empty optional fields and
  `school_id = 0` are omitted to avoid UNIQUE/FK failures.
- **Reason:** Phase 7 completion gate requires cross-family, cross-school and
  unauthorized-driver access to fail safely, and the `school_id` column is needed
  before Phase 8 staff/driver flows.
- **Files:** `Config.php`, `Table.php`, `Module/Database.php`, `HTTP/http.php`,
  `Util/{AuthGuard,Tenant,Util}.php`, `Routes/{Users,Children,ParentChildren,Schools,
  Buses,Routes,Trips,TripEvents,Locations,DeviceTokens,Notifications}.php`.
- **Verified by:** `C:\xampp\php\php.exe -l` on all 17 changed files — all pass.
  Live HTTP tests are blocked until Apache/MySQL run (port 80 held by PID 4, 3306 closed).
- **Still open:** legacy template routes (`Ads.php`, `Booking.php`, `Upload.php`,
  singular `Notification.php`, etc.) were not reviewed or removed; the hardcoded AES
  key/IV in `Util::encrypt_decrypt` should move to environment configuration; live
  authorization tests must be repeated once XAMPP is running.

## 2026-10-25 — Phase 8 driver trip flow and real Flutter login

- **Decision:** Finish the Phase 7 mobile login loop before starting Phase 8 UI: `LoginScreen`
  now calls `/users/login`, saves the token through `AuthController.signIn`, loads
  `/users/user` and calls `AuthController.attachProfile`. `StoredSession` persists
  `role`, `userId` and `displayName`; `RoleHome` sends `parent` to `ParentShell`, `driver`
  to `DriverHomeScreen`, and matron/school_admin/super_admin to an explicit
  `UnsupportedRoleScreen` (never silently to the parent UI). Legacy DEV sessions are
  treated as `parent` for backward compatibility. The DEV login button is debug-only and
  clearly labelled.
- **Why two steps for login:** `ApiClient` reads the token from `AuthController.session`,
  so the token must be saved before the profile request. If the profile request fails,
  the partial session is cleared; a session without a role is not left behind.
- **Driver data:** `DriverService` first asks for the active trip
  (`/trips/active_by_driver/{id}`), otherwise the latest pending trip
  (`/trips/by_driver/{id}`), then loads the assigned bus, route and stops. A new endpoint
  `GET /routes/stops/{route_id}` (`Routes::stops` + module/controller methods) returns
  `route_stops` ordered by `stop_order` with the same parent/school scoping as
  `Routes::get`. The client checks `trips.driver_id` as an extra guard, but the server
  remains the source of truth.
- **Trip transitions:** `Trips::transition` now allows only `pending -> active`,
  `active -> completed` and `pending/active -> cancelled`; anything else returns `409`.
  Starting is rejected with `409` when the driver already has another active trip. After
  every update the row is re-read to confirm the status actually changed (guards races),
  and `cancel_trip` now has a status constraint too. `get`/`transition`/`delete` reject
  non-numeric trip ids — previously an id like `12abc` produced an empty `WHERE` and
  could act on the first row.
- **UI:** `DriverHomeScreen` shows the trip type, bus, route, stops, a readiness checklist,
  the current status and a clear start/end action. Errors from the server are localized
  (`409` conflict, `403`, `404`, network, generic) and shown both as a banner and a
  SnackBar. No GPS or sample trip data is used; an empty server result shows an explicit
  "no trip scheduled" state. A trip with no stops shows a warning but does not fake data.
- **Tests:** `flutter test` passes 55 tests. New coverage: `test/models_test.dart`,
  `test/driver_controller_test.dart` (fake `DriverRepository`: pending, active, not-owned,
  empty, start, `409`, end) and `test/driver_home_test.dart` (readiness, start, stops page,
  empty state). `test/auth_session_expiry_test.dart` now also covers role persistence and
  `attachProfile`. Existing widget tests use the debug DEV button because the real API is
  not reachable offline.
- **Known limitation:** `trips` has no dedicated trip-date column, so "today" is derived
  from `created_at`. Add `trip_date` before scheduling more than one trip per day.
- **Still blocked:** the live transition/conflict/authorization matrix and on-device check
  need XAMPP (Apache/MySQL) running; only `php -l` and offline Flutter tests were possible.

## 2026-10-25 — XAMPP deployment, routing fix and live API smoke test

- **Deployment layout:** deploy `htdocs/Api/api` to `C:\xampp\htdocs\api` and
  `htdocs/Api/public` to `C:\xampp\htdocs\public`. Do **not** copy the whole `htdocs/Api`
  folder to `C:\xampp\htdocs\Api`: API includes use
  `$_SERVER["DOCUMENT_ROOT"] . "/api/v1/..."`, so a nested `/Api/api/v1` path breaks
  `Database.php`/controller includes.
- **Update workflow:** `scripts/deploy-xampp.ps1` syncs the two folders, preserves the
  target `.rd` after first creation, and supports `-Mirror` for an exact copy. A directory
  junction (`mklink /J`) is documented as the dev alternative. The repo stays the source
  of truth; XAMPP is only the runtime.
- **Router bug fixed:** `Config.php` previously calculated `route`/`route1` off by one, so
  `/api/v1/users/login` looked for `Routes/Login.php` instead of `Routes/Users.php`.
  The router now strips `/api/v1` wherever it appears, maps the next segment to the route
  class, the following one to the method, and the rest to encoded `page*` params.
  `install`, `login`, `password`, `activate`, `user`, `users` and `search` aliases are kept.
- **HTTP status line fixed:** `HTTP::Headers()` sent `HTTP/2 ...`, which is not a valid
  HTTP/1.x status line; curl/Flutter rejected the response. It now sends `HTTP/1.1`.
- **Token payload fixed:** `Util::generateToken()` accepts string/array/object and no longer
  reads an undefined `stdClass::$username`; `Users::add` and `Users::login` pass an object.
- **PHP 8 inheritance fixes:** route classes override `add/update/delete` from their
  controllers/`Database`, so each override now keeps the parent's optional parameter
  (`$data = ''`). Without this, PHP 8 aborted with "Declaration ... must be compatible"
  the first time `Schools`, `Buses`, `Routes`, `Trips`, `Children`, `ParentChildren`,
  `Notifications` or `TripEvents` was loaded.
- **Database query fix:** some modules put `ORDER BY` inside `select()`'s `where` string
  (for example `route_stops.stop_order` and `trips.started_at`). `Database::select()`
  appended a second `ORDER BY id DESC`, which made MySQL return `false` and the API
  answer `204`. It now appends the default order only when the caller did not supply one.
  Insert/create-table SQL errors are logged instead of being printed into the response.
- **Live verification:** Apache 2.4.56 (port 8080, because port 80 belongs to
  `ReportServer$SQLEXPRESS`) and MySQL 3306 are running. `/api/v1/install` created the
  `koobuss` tables; a local bootstrap `super_admin` was created; `POST /users/login` and
  `GET /users/user` return 200 through real Apache. `flutter test` passes 55/55.
- **Phase 8 live matrix passed:** with a local school (1), driver (2), bus (1), route (1),
  two stops and three trips, the server returned: `pending -> active` (200),
  concurrent start (409), `active -> completed` (200), `completed -> active` (409),
  `pending -> completed` (409), `pending -> cancelled` (200), `cancelled -> active` (409),
  and reloads showed the persisted status. Parent and matron received 403 on driver trip
  endpoints; an owner driver and same-school `school_admin` received 200; another driver
  was scoped to its own trips (204) and could not start/end trip 2 (403); another school's
  admin received 403.
- **Remaining:** app restart/device check, then change/remove the local test super_admin
  and set a strong `SECRET` plus `APP_ENV: production` for release.

## 2026-10-26 - Student manifest, attendance and child stops

- **Manifest ni server-side:** `GET /api/v1/trips/manifest/{trip_id}` ndiyo chanzo
  cha orodha ya wanafunzi; app haitengenezi wanafunzi wa mfano.
- **Mpangilio wa orodha:** safari ya asubuhi (`morning`) hupangwa kwa
  `children.pickup_stop_id`, safari ya mchana (`afternoon`) kwa
  `children.dropoff_stop_id`, kisha jina. Hivyo mwanafunzi anayeshuka karibuni
  anaonekana kwanza bila app kupanga upya.
- **Vituo vya mtoto:** `children.pickup_stop_id` na `children.dropoff_stop_id`
  ni nullable, vina index na foreign key. Wakati wa kuongeza/kubadilisha mtoto,
  kituo lazima kiwe cha route ya mtoto huyo; vinginevyo API inarudisha 403.
- **Mahudhurio:** hutumia `trip_events` (`board`, `alight`, `absent`, `excused`).
  Tukio la hivi karibuni ndilo hutawala; manifest inarudisha
  `attendance_status` na `attendance_at`. Kituo cha tukio lazima kiwe cha route
  ya safari.
- **Ruhusa:** manifest na kuandika mahudhurio ni kwa `driver`, `matron`,
  `school_admin` na `super_admin` tu. Driver huona safari zake tu; mzazi
  anapata 403.
- **UI:** kadi za wanafunzi ni horizontal (Bolt/Uber style), na bottom sheet ya
  mahudhurio inaonyesha hali ya sasa. Mabadiliko haya ni msingi wa UI, si
  alama ya checklist ya Phase 9.
- **Uthibitisho:** `php -l` zote za faili zilizobadilika zinapita, `flutter test`
  67/67 zinapita, na `/install` imeongeza columns/indexes/FKs kwenye database
  iliyopo. Live manifest bado inahitaji watoto halisi kwenye route.

## Known bugs / unfinished

- NDK 28.2.13676358 is **installed** (2.12 GB) and `flutter build apk --debug`
  succeeds; the first APK was installed and opened on V2333 on 2026-10-23.
  `flutter analyze` and `flutter test` also work.
- Logout button on Wasifu could not be located by automated UI dumps (scroll
  position/grid navigation issue, not a confirmed bug). Must be checked by hand
  before Phase 4 is signed off.
- Login screen still offers a clearly-labelled DEV shortcut, but real
  authentication (API-issued token, server password check, token expiry) is
  implemented as of Phase 7; the DEV shortcut is compiled only in debug builds
  (`kDebugMode`) and must not be enabled for release.
- Windows Developer Mode is now ON (registry
  `AllowDevelopmentWithoutDevLicense = 1`); plugin builds (symlinks) work.
- Parent screens use labelled DEV fixtures. Real children, bus, GPS and map
  arrive in Phase 5/9; push notifications in Phase 10. No production screen may
  read `parent_demo_data.dart`.
- Language switching (sw/en) implemented and tests pass; device verification on V2333 pending (picker + persistence + instant UI change).
- PHP API passes `php -l` and has a live HTTP smoke test through Apache/MySQL:
  install, login, profile and the Phase 8 transition/conflict/authorization matrix pass.
  The broader Phase 6/7 cross-family audit and the app-restart/device check are still
  pending before deployment.
- Apache is configured on port 8080 (`Listen 8080`, `ServerName localhost:8080`).
  Port 80 is held by SQL Server Reporting Services (`ReportServer$SQLEXPRESS`); stop that
  service or keep using `:8080`.
