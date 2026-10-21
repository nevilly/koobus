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

## Known bugs / unfinished

- NDK 28.2.13676358 is still downloading (~37 KB/s, ETA ~5 h). Until it is
  installed, `flutter build apk` / `flutter run` to an Android device will
  fail. Work in progress in the background with curl resume+retry.
