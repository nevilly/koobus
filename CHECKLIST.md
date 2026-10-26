# KOOBUS — MASTER DEVELOPMENT CHECKLIST

**Project:** KooBus School Bus Tracking System  
**Market:** Tanzania  
**Founder/developer:** Beginner learning Flutter while building the product  
**Mobile:** Flutter + Dart  
**Backend:** PHP REST API  
**Database:** MySQL  
**State management:** ChangeNotifier + Provider  
**First platform:** Android  
**Goal:** Build, test, pilot and prepare a real school bus tracking product for production.

---

# PROJECT RULES

- [ ] Build from a clean Flutter project.
- [ ] Keep the architecture and naming conventions consistent.
- [ ] Use one agreed data model and API contract across Flutter, PHP and MySQL.
- [ ] Use real GPS, real API requests and real database persistence for the actual product.
- [ ] Use simulated data only for clearly identified development tests.
- [ ] Build one feature at a time.
- [ ] Test each feature before moving to the next phase.
- [ ] Keep a Git commit after each meaningful milestone.
- [ ] Never expose passwords, tokens, database credentials or private keys.
- [ ] Never claim a feature is production-ready without appropriate tests.
- [ ] Maintain a list of known bugs and unfinished work.
- [ ] Document every important technical decision.

# PHASE 0 — PRODUCT DEFINITION AND PLANNING

## 0.1 Define the first version

- [ ] Write a clear one-paragraph description of KooBus.
- [ ] Define the primary problem: parents lack reliable information about school bus journeys.
- [ ] Identify the first customer: a school willing to participate in a pilot.
- [ ] Define the primary users: parent/guardian, driver and school administrator.
- [ ] Decide which features belong in the first release.
- [ ] List features that must wait until a later version.
- [ ] Define what success means for the first pilot.
- [ ] Identify who will provide and maintain student, bus, driver and route information.

## 0.2 Research the real operating environment

- [ ] Interview several parents about their current transport arrangements.
- [ ] Interview school administrators about bus assignments and parent communication.
- [ ] Interview drivers about phone use, routes, connectivity and charging.
- [ ] Check mobile network availability on likely routes.
- [ ] Determine whether drivers will use their own Android phones or school-owned devices.
- [ ] Estimate data, battery and mobile-device requirements.
- [ ] Identify who is allowed to authorize a child's tracking.
- [ ] Establish what happens when a child does not board, changes transport or is collected by another guardian.
- [ ] Identify local privacy and child-protection requirements.
- [ ] Record the findings and use them to refine the MVP.

**Deliverable:** Product requirements document (PRD), initial user stories and a list of assumptions requiring validation.

**Completion gate:** You can explain who uses KooBus, which problem it solves and exactly what the first version will and will not do.

# PHASE 1 — DEVELOPMENT ENVIRONMENT AND LEARNING FOUNDATION

## 1.1 Prepare the computer

- [x] Check Flutter installation.
- [x] Check Dart version.
- [x] Run `flutter doctor`.
- [x] Resolve Android SDK and license problems.
- [x] Confirm a physical Android device or emulator is available.
- [x] Confirm USB debugging if using a physical phone.
- [x] Run `flutter devices`.
- [x] Confirm Git is installed.
- [x] Learn the basic terminal commands needed to navigate the project.

## 1.2 Create the project

- [x] Create a new Flutter project named `koobus`.
- [x] Open the project in the code editor.
- [x] Understand `pubspec.yaml`.
- [x] Understand `lib/main.dart`.
- [x] Run the default app.  ← done 2026-10-23 on V2333 after NDK install
- [x] Make one visible UI change.
- [x] Run the app again and verify the change.  ← done 2026-10-23 on V2333
- [x] Create the initial Git repository.
- [x] Create a `.gitignore` appropriate for Flutter.
- [x] Make the first commit.

**Deliverable:** A clean Flutter project that builds and runs.

**Completion gate:** You can stop the app, run it again, make a small code change and understand how the app starts.

# PHASE 2 — LEARN THE FLUTTER FOUNDATIONS THROUGH KOOBUS

## 2.1 Dart foundations

- [ ] Understand variables and data types.  ← recap lesson pending
- [ ] Understand `String`, `int`, `double` and `bool`.  ← recap lesson pending
- [x] Understand nullable and non-nullable values.
- [x] Learn lists and maps.
- [x] Learn `if`, `else`, loops and functions.
- [x] Understand classes, constructors and objects.
- [x] Understand named parameters.
- [x] Understand `Future` and `async/await`.
- [x] Understand exceptions and error handling.
- [x] Understand JSON decoding and encoding.

## 2.2 Flutter foundations

- [x] Understand `main()` and `runApp()`.
- [x] Understand `MaterialApp` and `Scaffold`.
- [x] Learn `Row`, `Column`, `Stack`, `Container`, `Padding` and `Expanded`.
- [x] Learn `ListView` and scrolling layouts.
- [x] Learn `TextField` and form validation.
- [x] Understand `StatelessWidget` versus `StatefulWidget`.
- [x] Learn navigation between screens.
- [x] Learn reusable widgets.
- [ ] Understand loading, empty, error and success states.  (loading + error done; empty/success pending)
- [x] Learn how to read Flutter error messages.

## 2.3 State management

- [x] Understand what application state means.
- [x] Learn `ChangeNotifier`.
- [x] Learn `Provider`.
- [x] Understand how controllers notify screens.
- [ ] Learn how to dispose controllers and subscriptions.  ← baada ya kuwa na stream/subscription
- [x] Keep business logic outside screen widgets.

**Deliverable:** A small KooBus interface with navigation and forms.

**Completion gate:** You can explain what a widget, model, controller and service do without treating them as interchangeable concepts.

# PHASE 3 — ARCHITECTURE AND PROJECT STRUCTURE

## 3.1 Establish the agreed `lib/` structure

- [x] Create `app/` for app configuration and navigation.
- [x] Create `core/` for shared networking, constants, utilities and widgets.
- [x] Create `models/` for agreed data structures.
- [x] Create `services/` for API, GPS, local storage and notifications.
- [x] Create `controllers/` for shared application state where appropriate.
- [x] Create `features/auth/`.
- [x] Create `features/parent/`.
- [x] Create `features/driver/`.
- [x] Create `features/routes/` and `features/trips/` when needed.
- [x] Create `features/notifications/` when needed.
- [x] Create `features/settings/` when needed.
- [x] Document the responsibility of each folder.  → `docs/ARCHITECTURE.md`

## 3.2 Architecture rules

- [x] Screens handle presentation and user interactions.
- [x] Controllers coordinate application logic and state.
- [x] Services handle external systems such as GPS and HTTP requests.
- [x] Models define data structure and serialization.
- [x] Flutter communicates with PHP through an API client.
- [x] PHP handles authorization, validation and business rules.
- [x] PHP communicates with MySQL.
- [x] No Flutter screen communicates directly with MySQL.
- [x] No in-memory Dart stream is treated as communication between separate phones.
- [x] Avoid duplicate implementations of the same service.

> Hizi zote zimeandikwa na kukubaliwa kwenye `docs/ARCHITECTURE.md`
> (sehemu ya 5 "Non-negotiable rules"). Utekelezaji wa API/MySQL ni Phase 6+.

**Deliverable:** A documented architecture and an initial folder structure.

**Completion gate:** You know where new code belongs and can trace a request from a screen to a controller, service, API and database.

# PHASE 4 — UI/UX AND DESIGN SYSTEM

## 4.1 Define the design system

- [x] Choose primary, secondary, background and status colors.
- [x] Define text styles and font sizes.
- [x] Define spacing and screen margins.
- [x] Define standard button styles.
- [x] Define input field styles.
- [x] Define cards, dialogs and loading indicators.
- [x] Define reusable error and empty-state components.
- [ ] Make the interface usable on different Android screen sizes.  ← baada ya UI halisi + jaribio la simu
- [x] Provide readable Swahili messages.
- [x] Ensure important actions are easy to identify.

## 4.2 Build screens

- [x] Splash/loading screen.
- [x] Login screen.
- [ ] Password recovery screen if supported by the chosen authentication method.
- [x] Parent home screen.
- [x] Child details screen.
- [ ] Bus tracking screen.  ← ramani ya mfano ipo; GPS halisi ni Phase 9
- [x] Trip history screen.
- [x] Parent profile screen.
- [ ] Driver home screen.
- [ ] Assigned route screen.
- [ ] Active trip screen.
- [x] Notifications screen.
- [ ] Settings screen.  ← sehemu ya Mipangilio ipo ndani ya Wasifu; screen kamili bado
- [ ] Unauthorized-access screen.
- [ ] Offline and server-error states.

Use clearly labelled development fixtures while building UI, but do not confuse sample data with live production information.

**Device milestone (2026-10-23):** first `flutter build apk --debug` succeeded and
was installed on V2333 (`10HE93F0RR001GL`). Verified by hand on the phone:
splash → login → DEV login → all 5 tabs → `Historia yake` per child → back.
Wasifu logout button still needs a manual check.

**Deliverable:** Navigable UI for the initial Parent and Driver experiences.

**Completion gate:** The screens are consistent, understandable and usable even when data is loading or unavailable.

# PHASE 5 — DATA MODEL AND DATABASE DESIGN

## 5.1 Design the domain

- [x] Define the school entity.
- [x] Define users and roles (parent, driver, matron, school_admin, super_admin).
- [x] Define school membership and permissions.
- [x] Define children.
- [x] Define parent/guardian-to-child relationships (`parent_children`).
- [x] Define buses.
- [x] Define driver profiles (via users role).
- [x] Define routes.
- [x] Define route stops.
- [x] Define route assignments.
- [x] Define trips.
- [x] Define trip location records (`locations`).
- [x] Define notification events (`notifications`).
- [x] Define registered device tokens (`device_tokens`).
- [x] Define trip events (`trip_events` - board/alight/absent/excused, recorded by matron/driver).
- [x] Define any additional tables required by validated product requirements.

## 5.2 Define the relationships

- [x] Decide how users can belong to one or multiple schools.
- [x] Define how guardians are authorized to access children.
- [x] Define how drivers are assigned to buses and routes.
- [x] Define how a trip is linked to a route, bus and driver (and matron).
- [x] Define how a location update is linked to a trip.
- [x] Define how a notification event relates to a parent and trip.
- [x] Define primary keys and foreign keys.
- [x] Add appropriate unique constraints and indexes.
- [x] Define timestamps and timezone handling (Africa/Dar_es_Salaam).
- [x] Define what happens when records are deactivated or deleted.
- [ ] Document retention rules for sensitive location records.

## 5.3 Create the database

- [x] Draw an ER diagram (documented in `docs/PHASE5_ERD.md`).
- [x] Write a data dictionary (see ERD doc).
- [x] Create schema migrations (`htdocs/Api/api/v1/Table.php` - KooBus core tables).
- [ ] Create development seed data.
- [x] Test relationships and constraints (schema defined).
- [ ] Test invalid foreign keys and duplicate records.
- [ ] Create a database backup and restoration procedure.
- [x] Verify that credentials are stored securely (.rd not committed with real secrets).

**Deliverable:** Version-controlled schema, ER diagram and data dictionary.

**Completion gate:** The database can represent schools, authorized guardians, children, buses, routes, trips and location updates without inconsistent relationships.

# PHASE 6 — PHP BACKEND AND REST API

## 6.1 Prepare the backend

- [x] Set up the PHP development environment. (XAMPP structure in place)
- [x] Configure MySQL access. (Database.php configured via .rd)
- [x] Create environment configuration for secrets. (.rd configured for KooBus)
- [x] Establish a consistent API response format. (HTTP::response in place)
- [x] Establish error handling and HTTP status codes. (HTTP class in place)
- [x] Configure request validation. (Util helpers in place)
- [x] Configure secure database access using prepared statements. (real_escape_string + parameterized patterns in place)
- [ ] Set up a development API URL.
- [ ] Document how Android emulator and physical-phone networking differ.

## 6.2 Implement the API

- [ ] Authentication endpoints.
- [ ] User and profile endpoints.
- [ ] School membership and authorization endpoints.
- [ ] Parent and child endpoints.
- [ ] Bus and driver assignment endpoints.
- [ ] Route and stop endpoints.
- [ ] Trip start and end endpoints.
- [ ] Location upload endpoint.
- [ ] Latest location and trip status endpoints.
- [ ] Notification registration and event endpoints.
- [ ] Appropriate health/status endpoint for monitoring the API.

For each endpoint:

- [ ] Define method and path.
- [ ] Define authentication requirements.
- [ ] Define request JSON.
- [ ] Define success JSON.
- [ ] Define error JSON.
- [ ] Validate all inputs.
- [ ] Verify access permissions.
- [ ] Verify database effects.
- [ ] Write API tests.
- [ ] Document the endpoint.

**Deliverable:** A tested backend that can be used independently of the Flutter UI.

**Completion gate:** API requests create and retrieve real database records, and unauthorized requests are rejected.

# PHASE 7 — AUTHENTICATION AND AUTHORIZATION

- [x] Define how school staff create or approve accounts. (staff are created by an
  authenticated `school_admin`/`super_admin`; public sign-up is `parent` only; the first
  `super_admin` may self-register only while none exists — see DECISIONS 2026-10-25)
- [x] Implement secure password hashing on the server. (Util::Hash)
- [x] Implement login and logout. (API + Flutter: `LoginScreen` calls `/users/login`, stores the
  token, loads `/users/user`, persists role/user id/name and routes through `RoleHome`;
  logout clears the secure session. A clearly-labelled DEV shortcut remains in debug builds only.)
- [x] Use a suitable token/session design. (Token-based with Owesis header)
- [x] Define token expiry and renewal. (JWT `exp` ~61 days; renewal = re-login; no refresh token yet)
- [x] Store authentication material securely on the device. (flutter_secure_storage)
- [x] Restore a valid session appropriately. (expired token is cleared on restore)
- [x] Handle expired tokens. (ApiClient 401 -> signOut + redirect to login; local `exp` check;
  server-side expiry check fixed to fail closed)
- [x] Enforce roles and permissions on the server. (AuthGuard added for users/trips/events/locations/children/parent_children/schools/buses/routes/devices/notifications)
- [x] Verify school-level access. (`users.school_id` + `Util/Tenant.php`; super_admin unrestricted,
  school_admin own school only, school_admin without a school fails closed; admin CRUD and
  child/trip/event/location/notification reads scoped)
- [x] Verify parent-to-child authorization. (children/trips/trip_events/locations filtered by parent_children; `get('')` on protected resources returns 403)
- [x] Verify driver-to-trip authorization. (start/end/cancel and event/location upload require
  `trips.driver_id` = caller; matron scoped by `trips.matron_id`)
- [x] Prevent users from changing IDs to access another family's information. (scoping added for parent on children/trips/trip_events/locations; `recorded_by` forced from token)
- [x] Avoid leaking private information in logs or error messages. (production hides PHP errors;
  request log redacts password/token; API strips `password`/`token` from user responses)

> **Status 2026-10-25:** Phase 7 code is complete and all changed PHP files pass `php -l`.
> Flutter now signs in against the real API and routes by role (`parent` -> `ParentShell`,
> `driver` -> `DriverHomeScreen`, other staff -> a clear "not supported yet" screen).
> The DEV login button is debug-only and labelled; it is not part of release behaviour.
> Live API smoke test now passes through Apache on port 8080 + MySQL: `/install`, first
> super_admin bootstrap, `/users/login` and `/users/user` all return 200. Full
> cross-family/cross-school/unauthorized-driver matrix is still pending. Port 80 is held by
> `ReportServer$SQLEXPRESS`; Apache is on 8080.
> Legacy template routes (`Ads.php`, `Booking.php`, `Upload.php`, singular `Notification.php`,
> etc.) still exist and are not part of the KooBus API surface.

**Deliverable:** Users can authenticate and access only resources they are authorized to use.

**Completion gate:** Cross-family, cross-school and unauthorized-driver access tests fail safely.

# PHASE 8 — DRIVER AND TRIP MANAGEMENT

- [x] Load the driver's assigned bus from the backend. (`GET /buses/get/{id}`)
- [x] Load the assigned route and stops. (`GET /routes/get/{id}` and new
  `GET /routes/stops/{id}`; stops are ordered by `stop_order`)
- [x] Display trip readiness. (`DriverHomeScreen` readiness card: assignment, bus, route,
  stops, trip status)
- [x] Validate that the driver is authorized to start the trip. (client ownership check plus
  server `trips.driver_id` guard in `Trips::transition`)
- [x] Implement trip start. (`POST /trips/start` -> `DriverController.startTrip`)
- [x] Record trip start time on the server. (`start_trip` sets `started_at`; the app reloads
  the trip from the server after the action)
- [x] Define allowed trip state transitions. (`pending -> active`, `active -> completed`,
  `pending/active -> cancelled`; anything else returns `409`)
- [x] Implement trip pause or interruption if required. (not required for v1; cancellation
  covers an interrupted trip)
- [x] Implement trip completion. (`POST /trips/end` -> `end_trip` sets `ended_at`)
- [x] Prevent conflicting active trips. (server returns `409` when the driver already has an
  active trip; the UI shows a clear conflict message)
- [x] Handle server errors during trip actions. (`ApiException` becomes a localized banner /
  SnackBar; network, `403`, `404`, `409` and generic server errors are handled separately)
- [x] Display clear trip status. (status chip, readiness list and active-trip card)
- [x] Test all trip state transitions. (Flutter unit/widget tests cover pending, active,
  start, end, conflict and empty states; the live server matrix passed for
  `pending -> active`, `active -> completed`, `pending -> cancelled`, conflict `409`,
  and the invalid `completed/cancelled -> active` and `pending/completed -> completed`)

> **Status 2026-10-25:** Phase 8 code is implemented on both sides and `php -l` passes on the
> changed PHP files. `flutter test` passes 55 tests, including the new driver controller and
> driver home tests. A driver can sign in with a real token, see the assigned trip, bus, route
> and stops, start/end the trip, and the state is reloaded from the server after each action.
> The API is live on Apache 8080 + MySQL `koobuss`; install/login/profile pass. A local
> school/driver/bus/route/stops/trip seed was created and the live transition/conflict/
> authorization matrix passed: owner driver 200, parent/matron 403, other driver scoped
> (204) and blocked from another trip (403), same-school admin 200, other-school admin 403.
> Remaining before sign-off: app-restart and physical-device verification. Trip dates are
> still derived from `created_at` because `trips` has no dedicated trip-date column.

**Deliverable:** A driver can perform an authorized trip workflow backed by server data.

**Completion gate:** Trip state is persisted on the server and remains consistent when the app restarts. (server persistence verified by reloading the active trip; app-restart/device check pending)

# PHASE 9 - REAL GPS AND LIVE TRACKING

> Maendeleo (2026-10-26): UI ya dereva (shell, dashboard, sticky Start/End),
> manifest ya wanafunzi na mahudhurio zimekamilika kama msingi. GPS halisi na
> ramani ya OSM vimeunganishwa: ruhusa, location services, denied/permanently
> denied, stale/inaccurate, upload yenye uthibitisho wa safari, na map display
> vimejaribiwa kwenye simu V2333. Background tracking, notification ya
> ufuatiliaji, upande wa mzazi na jaribio la simu mbili bado havijaanza.
> Alama rasmi za checklist hapa chini bado ni 0/28 hadi completion gate yote
> (pamoja na parent retrieval na two-phone test) ikamilike.

## 9.1 GPS acquisition

- [ ] Request location permissions appropriately.
- [ ] Check whether location services are enabled.
- [ ] Handle denied and permanently denied permissions.
- [ ] Display a clear message if GPS is unavailable.
- [ ] Acquire a real device location.
- [ ] Capture timestamp and accuracy.
- [ ] Handle missing, stale or inaccurate readings.
- [ ] Select a suitable update interval and distance filter.
- [ ] Monitor battery and mobile-data use.

## 9.2 Upload and display locations

- [ ] Send location updates through the authenticated API.
- [ ] Associate each update with the correct active trip.
- [ ] Validate data and trip ownership on the server.
- [ ] Persist location records.
- [ ] Retrieve the latest location for authorized parents.
- [ ] Display the bus on a map.
- [ ] Display the last update time.
- [ ] Indicate stale or unavailable location.
- [ ] Avoid presenting an old position as live.
- [ ] Test on two physical phones.
- [ ] Test with different network conditions.

## 9.3 Background tracking

- [ ] Define the required tracking behavior when the app is backgrounded.
- [ ] Configure Android location permissions and foreground service requirements.
- [ ] Display the required ongoing tracking notification.
- [ ] Test with the screen locked.
- [ ] Test app switching and app restart.
- [ ] Test battery optimization behavior.
- [ ] Test the supported Android versions.
- [ ] Document limitations and recovery steps.

**Deliverable:** A driver phone sends genuine location updates, and an authorized parent phone retrieves and displays them.

**Completion gate:** The end-to-end flow works on separate devices using a real backend, not an in-memory stream or hardcoded coordinates.

# PHASE 10 — GEOFENCING AND NOTIFICATIONS

## 10.1 Geofencing logic

- [ ] Define a configurable radius for each relevant stop.
- [ ] Calculate distance using valid coordinates.
- [ ] Account for GPS accuracy.
- [ ] Consider trip direction and stop order.
- [ ] Define entry and exit rules.
- [ ] Define minimum timing/distance conditions to reduce false alerts.
- [ ] Prevent duplicate alert events.
- [ ] Record the event and its processing status.
- [ ] Test boundary conditions and poor GPS accuracy.

## 10.2 Remote notifications

- [ ] Select and configure FCM or another appropriate push service.
- [ ] Register device tokens.
- [ ] Associate tokens with authenticated users.
- [ ] Keep credentials for sending notifications on the server.
- [ ] Trigger notifications from validated server-side events.
- [ ] Send notifications only to authorized recipients.
- [ ] Handle token refresh and invalid tokens.
- [ ] Handle foreground, background and terminated app states.
- [ ] Respect notification permissions.
- [ ] Handle delivery retries and duplicate prevention.
- [ ] Record event and processing status.
- [ ] Test a driver phone triggering an event that reaches a parent phone.

**Deliverable:** A valid bus-approaching event can trigger a remote notification for the correct parent.

**Completion gate:** The notification is generated from real trip/location data and duplicate or unauthorized alerts are prevented as far as the architecture allows.

# PHASE 11 — OFFLINE STORAGE AND SYNCHRONIZATION

## 11.1 Driver offline mode

- [ ] Detect connectivity changes.
- [ ] Store eligible location updates in a local database.
- [ ] Assign unique IDs to queued records.
- [ ] Store original timestamps and required metadata.
- [ ] Retry uploads with backoff.
- [ ] Make server writes idempotent to prevent duplicate records.
- [ ] Mark records as synchronized only after server confirmation.
- [ ] Handle partial upload failures.
- [ ] Define queue size and retention limits.
- [ ] Clean up synchronized records safely.

## 11.2 Parent offline mode

- [ ] Cache appropriate last-known trip information.
- [ ] Show when the information was last updated.
- [ ] Label stale data clearly.
- [ ] Do not imply that cached information is live.
- [ ] Refresh data when connectivity returns.

## 11.3 Failure recovery

- [ ] Test internet loss during a trip.
- [ ] Test internet recovery.
- [ ] Test server downtime.
- [ ] Test app restart with queued records.
- [ ] Test duplicate retries.
- [ ] Test GPS unavailable while internet remains available.
- [ ] Define behavior when the driver phone is switched off.
- [ ] Ensure missing data does not generate misleading alerts.

**Deliverable:** A documented and tested offline/synchronization strategy.

**Completion gate:** The system recovers from temporary connectivity problems without silently losing records or presenting stale positions as current.

# PHASE 12 — SECURITY, QUALITY AND PILOT READINESS

## 12.1 Security and privacy

- [ ] Use HTTPS in deployed environments.
- [ ] Review authentication and authorization.
- [ ] Review child and guardian access controls.
- [ ] Review server-side input validation.
- [ ] Review database queries and error handling.
- [ ] Protect secrets and device tokens.
- [ ] Configure backups and test restoration.
- [ ] Establish access logging and monitoring.
- [ ] Define location retention and deletion.
- [ ] Establish a privacy notice and suitable consent/authorization process.
- [ ] Review applicable Tanzanian data protection and child-related requirements.
- [ ] Define incident response and account revocation procedures.

## 12.2 Testing

- [ ] Unit tests for models and calculations.
- [ ] Unit tests for geofencing and duplicate suppression.
- [ ] Widget tests for key screens.
- [ ] API tests for validation and authorization.
- [ ] Database tests for relationships.
- [ ] Integration tests for login and trip lifecycle.
- [ ] Integration tests for location upload and retrieval.
- [ ] Tests for notifications.
- [ ] Tests for offline queue and recovery.
- [ ] Manual tests on physical Android devices.
- [ ] Regression tests after important changes.
- [ ] Resolve critical and high-severity bugs before pilot.

## 12.3 School pilot

- [ ] Identify a willing pilot school.
- [ ] Obtain necessary permissions and agreements.
- [ ] Configure the school, drivers, buses, routes and authorized guardians.
- [ ] Train the pilot users.
- [ ] Test the real route at different times.
- [ ] Measure location freshness and update reliability.
- [ ] Measure notification usefulness and false alerts.
- [ ] Observe battery and data consumption.
- [ ] Collect feedback from parents and drivers.
- [ ] Record incidents and unresolved issues.
- [ ] Fix important issues before expanding.

**Deliverable:** A documented pilot report and a prioritized list of improvements.

**Completion gate:** Real users have tested the intended workflow under realistic conditions, and critical safety, privacy and reliability issues are addressed.

# PHASE 13 — PRODUCTION RELEASE AND OPERATIONS

## 13.1 Production infrastructure

- [ ] Choose a suitable hosting provider.
- [ ] Configure production PHP and MySQL.
- [ ] Configure HTTPS and domain/DNS.
- [ ] Set production environment variables.
- [ ] Separate development, staging and production environments.
- [ ] Configure database backups.
- [ ] Test backup restoration.
- [ ] Configure application and server error monitoring.
- [ ] Configure server resource and API availability monitoring.
- [ ] Define a process for deploying database migrations.
- [ ] Document rollback and recovery procedures.

## 13.2 Flutter release

- [ ] Configure app name, package ID and icon.
- [ ] Remove development-only settings and test fixtures from production flows.
- [ ] Verify production API configuration.
- [ ] Review Android permissions.
- [ ] Review release signing and protect signing credentials.
- [ ] Build a release APK/AAB as appropriate.
- [ ] Test the release build on physical devices.
- [ ] Complete applicable Google Play requirements.
- [ ] Prepare store listing, privacy policy and support contact.
- [ ] Release to a controlled test track before wider distribution.

## 13.3 Ongoing operations

- [ ] Monitor API failures and application crashes.
- [ ] Monitor push notification failures.
- [ ] Review unusual access attempts.
- [ ] Maintain a bug backlog.
- [ ] Plan dependency and security updates.
- [ ] Maintain user support procedures.
- [ ] Define how accounts, buses and routes are updated.
- [ ] Review actual infrastructure and notification costs.
- [ ] Establish a process for restoring service after an outage.
- [ ] Plan the next release from real pilot feedback.

**Deliverable:** A deployed and supportable KooBus release, with operational procedures.

**Completion gate:** The system can be deployed, monitored, recovered and updated—not merely installed on one developer's phone.

# PROJECT COMPLETION DEFINITION

KooBus must not be called production-ready until the applicable requirements below are verified:

- [ ] Parent and driver accounts use real backend authentication.
- [ ] Users can access only the data they are authorized to access.
- [ ] Driver trips are managed by the backend.
- [ ] Real GPS data is uploaded and persisted.
- [ ] Parent devices receive the correct trip/location information.
- [ ] Geofence events are validated and duplicate alerts are controlled.
- [ ] Remote notifications are tested on separate devices.
- [ ] Offline behavior and synchronization are tested.
- [ ] Background tracking has been tested on supported devices.
- [ ] Privacy and security requirements have been reviewed.
- [ ] Critical and high-severity defects have been addressed.
- [ ] Backups, monitoring and recovery procedures are in place.
- [ ] A real pilot has been completed and evaluated.
- [ ] Production deployment and support responsibilities are documented.

**Final principle:** Build a small, real, testable system first. Expand it only when the current stage is understood, working and verified.

# POST-MVP (PHASE 14+) — PARENT EXPERIENCE ENHANCEMENTS

> See `FUTURE_UX_IDEAS.md` for full details, schema ideas and rationale.

## 14.1 Driver Red Alert (Student Not Attending) — PRIORITY #1
- [ ] Add `trip_attendance` concept (boarded/alighted/absent/excused, marked_by matron/parent/driver)
- [ ] Driver app: split student list into "Boarding" vs "Not attending today"
- [ ] Red border/avatar + `HATAFIKA` badge on student not attending
- [ ] Allow matron/parent to mark "child will not attend today"
- [ ] Do not stop at stops marked as not attending (visual cue only for now)

## 14.2 Bus Fee Payments (Installments/Weekly/Full)
- [ ] Add `bus_fees`, `fee_invoices`, `fee_payments` schema ideas to ERD
- [ ] Parent UI placeholders: Fees tab/section showing balance, due date, history
- [ ] Support full / installments / weekly (UI only)
- [ ] Receipts/history view
- [ ] Payment reminders/overdue badge
- [ ] (Later) integrate payment gateway (AzamPay/Selcom/M-Pesa)

## 14.3 Alternative Transport Marketplace (Bajaj/Bodaboda/Coaster)
- [ ] Add `transport_providers`, `transport_requests` schema ideas to ERD
- [ ] "Pata Usafiri Karibu" screen (backup transport) with filters by vehicle type/area
- [ ] Provider registration + verification flow (pending/approved/rejected)
- [ ] `Imethibitishwa` badge, availability toggle
- [ ] Call/contact flow (safe)
- [ ] Start with Bajaj/Coaster first; be cautious with bodaboda for young children

## 14.4 Communication, SMS & Reports
- [ ] "Piga simu" buttons (driver/matron) using `tel:`
- [ ] SMS fallback for feature phones (Africa's Talking/Telerivet) — plan only
- [ ] School announcements (`school_announcements`) in Taarifa tab
- [ ] Driver/reporting form (`complaints`) for delays/speeding/conduct
- [ ] Parent complaints + status tracking

## 14.5 UX Polish & Notifications
- [ ] "Mwanafunzi hayuko hewani" alert when marked absent
- [ ] Fee due reminders on Home/Wasifu
- [ ] Communication history
- [ ] Alternate transport request status ("Inasubiri uthibitisho")
- [ ] Extend guardian permissions/roles as needed

**Rule:** These are post-MVP enhancements. Do not block Phase 5-13 with these items. Only add UI placeholders/schema planning if they don't interfere with the main flow.
