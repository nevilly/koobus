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
- [ ] Run the default app.  ← BLOCKED: NDK download
- [x] Make one visible UI change.
- [ ] Run the app again and verify the change.  ← BLOCKED: NDK download
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
- [ ] Learn `Row`, `Column`, `Stack`, `Container`, `Padding` and `Expanded`.  ← Stack/Expanded bado
- [ ] Learn `ListView` and scrolling layouts.
- [x] Learn `TextField` and form validation.
- [x] Understand `StatelessWidget` versus `StatefulWidget`.
- [x] Learn navigation between screens.
- [ ] Learn reusable widgets.
- [ ] Understand loading, empty, error and success states.  ← loading ✓, empty/error bado
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

- [ ] Choose primary, secondary, background and status colors.
- [ ] Define text styles and font sizes.
- [ ] Define spacing and screen margins.
- [ ] Define standard button styles.
- [ ] Define input field styles.
- [ ] Define cards, dialogs and loading indicators.
- [ ] Define reusable error and empty-state components.
- [ ] Make the interface usable on different Android screen sizes.
- [ ] Provide readable Swahili messages.
- [ ] Ensure important actions are easy to identify.

## 4.2 Build screens

- [ ] Splash/loading screen.
- [ ] Login screen.
- [ ] Password recovery screen if supported by the chosen authentication method.
- [ ] Parent home screen.
- [ ] Child details screen.
- [ ] Bus tracking screen.
- [ ] Trip history screen.
- [ ] Parent profile screen.
- [ ] Driver home screen.
- [ ] Assigned route screen.
- [ ] Active trip screen.
- [ ] Notifications screen.
- [ ] Settings screen.
- [ ] Unauthorized-access screen.
- [ ] Offline and server-error states.

Use clearly labelled development fixtures while building UI, but do not confuse sample data with live production information.

**Deliverable:** Navigable UI for the initial Parent and Driver experiences.

**Completion gate:** The screens are consistent, understandable and usable even when data is loading or unavailable.

# PHASE 5 — DATA MODEL AND DATABASE DESIGN

## 5.1 Design the domain

- [ ] Define the school entity.
- [ ] Define users and roles.
- [ ] Define school membership and permissions.
- [ ] Define children.
- [ ] Define parent/guardian-to-child relationships.
- [ ] Define buses.
- [ ] Define driver profiles.
- [ ] Define routes.
- [ ] Define route stops.
- [ ] Define route assignments.
- [ ] Define trips.
- [ ] Define trip location records.
- [ ] Define notification events.
- [ ] Define registered device tokens.
- [ ] Define any additional tables required by validated product requirements.

## 5.2 Define the relationships

- [ ] Decide how users can belong to one or multiple schools.
- [ ] Define how guardians are authorized to access children.
- [ ] Define how drivers are assigned to buses and routes.
- [ ] Define how a trip is linked to a route, bus and driver.
- [ ] Define how a location update is linked to a trip.
- [ ] Define how a notification event relates to a parent and trip.
- [ ] Define primary keys and foreign keys.
- [ ] Add appropriate unique constraints and indexes.
- [ ] Define timestamps and timezone handling.
- [ ] Define what happens when records are deactivated or deleted.
- [ ] Document retention rules for sensitive location records.

## 5.3 Create the database

- [ ] Draw an ER diagram.
- [ ] Write a data dictionary.
- [ ] Create schema migrations.
- [ ] Create development seed data.
- [ ] Test relationships and constraints.
- [ ] Test invalid foreign keys and duplicate records.
- [ ] Create a database backup and restoration procedure.
- [ ] Verify that credentials are stored securely.

**Deliverable:** Version-controlled schema, ER diagram and data dictionary.

**Completion gate:** The database can represent schools, authorized guardians, children, buses, routes, trips and location updates without inconsistent relationships.

# PHASE 6 — PHP BACKEND AND REST API

## 6.1 Prepare the backend

- [ ] Set up the PHP development environment.
- [ ] Configure MySQL access.
- [ ] Create environment configuration for secrets.
- [ ] Establish a consistent API response format.
- [ ] Establish error handling and HTTP status codes.
- [ ] Configure request validation.
- [ ] Configure secure database access using prepared statements.
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

- [ ] Define how school staff create or approve accounts.
- [ ] Implement secure password hashing on the server.
- [ ] Implement login and logout.
- [ ] Use a suitable token/session design.
- [ ] Define token expiry and renewal.
- [ ] Store authentication material securely on the device.
- [ ] Restore a valid session appropriately.
- [ ] Handle expired tokens.
- [ ] Enforce roles and permissions on the server.
- [ ] Verify school-level access.
- [ ] Verify parent-to-child authorization.
- [ ] Verify driver-to-trip authorization.
- [ ] Prevent users from changing IDs to access another family's information.
- [ ] Avoid leaking private information in logs or error messages.

**Deliverable:** Users can authenticate and access only resources they are authorized to use.

**Completion gate:** Cross-family, cross-school and unauthorized-driver access tests fail safely.

# PHASE 8 — DRIVER AND TRIP MANAGEMENT

- [ ] Load the driver's assigned bus from the backend.
- [ ] Load the assigned route and stops.
- [ ] Display trip readiness.
- [ ] Validate that the driver is authorized to start the trip.
- [ ] Implement trip start.
- [ ] Record trip start time on the server.
- [ ] Define allowed trip state transitions.
- [ ] Implement trip pause or interruption if required.
- [ ] Implement trip completion.
- [ ] Prevent conflicting active trips.
- [ ] Handle server errors during trip actions.
- [ ] Display clear trip status.
- [ ] Test all trip state transitions.

**Deliverable:** A driver can perform an authorized trip workflow backed by server data.

**Completion gate:** Trip state is persisted on the server and remains consistent when the app restarts.

# PHASE 9 — REAL GPS AND LIVE TRACKING

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
