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

## Known bugs / unfinished

- NDK 28.2.13676358 is still downloading (~49 KB/s via curl with resume+retry).
  Until it is installed, `flutter build apk` / `flutter run` to an Android
  device will fail. `flutter analyze` and `flutter test` work without it.
- Login screen signs in with a clearly-labelled DEV token. Real authentication
  (API-issued token, password check on server, token expiry) is Phase 7.
- Windows Developer Mode must be enabled for plugin builds (symlink support).
  The user was asked to enable it via Settings → Developer Mode.
- Parent home screen is a placeholder (amber DEVELOPMENT card). Real children,
  bus and map arrive in Phase 5/9.
