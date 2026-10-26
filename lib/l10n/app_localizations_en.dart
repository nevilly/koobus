// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'KooBus';

  @override
  String get appTagline => 'Safety on the school journey';

  @override
  String get actionCancel => 'Not now';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get emptyStateNoChildren => 'No children linked to your account yet.';

  @override
  String get emptyStateNoChildrenSubtitle =>
      'If your children don\'t appear, contact the school administrator to have them added.';

  @override
  String get emptyStateNoHistory => 'No trip history yet.';

  @override
  String get emptyStateNoHistorySubtitle =>
      'History will appear here when a child boards or alights the bus.';

  @override
  String get emptyStateNoAlerts => 'No alerts yet.';

  @override
  String get emptyStateNoAlertsSubtitle => 'Bus alerts will appear here.';

  @override
  String get emptyStateNoTrips => 'No trip in progress today.';

  @override
  String get emptyStateNoTripsSubtitle =>
      'You\'ll be notified when the bus starts its trip.';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get devBadgeLabel => 'SAMPLE (DEV)';

  @override
  String get loginTitle => 'Welcome to KooBus';

  @override
  String get loginSubtitle => 'Welcome back. Log in to continue to KooBus';

  @override
  String get loginPhoneLabel => 'Phone number';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSubmit => 'Log in';

  @override
  String get loginDevNotice =>
      'TEST mode (DEV): this button uses a test token and sample data. It only appears in debug builds.';

  @override
  String get sessionExpiredNotice =>
      'Your session has expired. Please sign in again to continue.';

  @override
  String get validationPhoneRequired => 'Please enter your phone number';

  @override
  String get validationPhoneInvalid =>
      'Invalid number. Example: 0712345678 or 255712345678';

  @override
  String get validationPasswordRequired => 'Please enter your password';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 6 characters';

  @override
  String get navHome => 'Home';

  @override
  String get navChildren => 'Children';

  @override
  String get navHistory => 'History';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navProfile => 'Profile';

  @override
  String tabPosition(int index, int total) {
    return 'Tab $index of $total';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get historySubtitle =>
      'Every boarding and alighting is saved with the time and the matron.';

  @override
  String get logoutButton => 'Log out';

  @override
  String get logoutDialogTitle => 'Log out?';

  @override
  String get logoutDialogBody =>
      'You will need to log in again on this device.';

  @override
  String get logoutConfirm => 'Yes, log out';

  @override
  String get logoutFootnote =>
      'Logging out removes the session from this device. You will need to log in again.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Push notifications';

  @override
  String get settingsNotificationsSubtitle => 'Coming in Phase 10';

  @override
  String get languageSwahili => 'Kiswahili';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChanged => 'Language changed';

  @override
  String welcomeUser(String phone) {
    return 'Welcome, $phone';
  }

  @override
  String get homeTodayStatus => 'Today\'s trip status';

  @override
  String get homeMapNotice => 'The real map arrives in Phase 9 — no GPS yet.';

  @override
  String get homePhaseNotice =>
      'The map, GPS and live arrival time arrive in Phase 9. Everything here is SAMPLE data (DEV).';

  @override
  String etaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String etaDistanceFrom(String km, String place) {
    return '~$km km from $place';
  }

  @override
  String busCardTitle(String plate) {
    return 'Bus $plate';
  }

  @override
  String busDriver(String name) {
    return 'Driver: $name';
  }

  @override
  String busMatron(String name) {
    return 'Matron: $name';
  }

  @override
  String busRouteLabel(String name) {
    return 'Route $name';
  }

  @override
  String get busCallDriverNotice => 'Calling the driver arrives in Phase 9.';

  @override
  String get capacityTitle => 'Students on the bus';

  @override
  String capacityCount(int onboard, int capacity) {
    return '$onboard / $capacity';
  }

  @override
  String get childrenTitle => 'Your children';

  @override
  String get childrenSubtitle =>
      'Tap a child to see the boarding and alighting history.';

  @override
  String get childrenMultipleSchoolsNotice =>
      'Children can be at different schools — each one has their own school, class and matron.';

  @override
  String get childrenHistoryButton => 'Their history';

  @override
  String childSchoolClass(String school, String className) {
    return '$school · $className';
  }

  @override
  String childHistoryTitle(String name) {
    return '$name\'s history';
  }

  @override
  String childRouteLabel(String route) {
    return 'Route: $route';
  }

  @override
  String get childRecentActivity => 'Recent activity';

  @override
  String get childHistoryDevNotice =>
      'This information is SAMPLE data (DEV). The real history will come from the database through the API (Phase 6/7).';

  @override
  String get historyTabTitle => 'Trip history';

  @override
  String get historyFilterNotice =>
      'Date/school filters and the full history arrive in Phase 9.';

  @override
  String get alertsTabTitle => 'Alerts';

  @override
  String get alertsSubtitle => 'Bus alerts: boarding, arrival and delays.';

  @override
  String get alertsPushNotice =>
      'Real push notifications (FCM) arrive in Phase 10.';

  @override
  String get statusWaitingBus => 'Waiting for the bus';

  @override
  String get statusOnTheWay => 'On the way';

  @override
  String get statusAtSchool => 'At school';

  @override
  String get statusAtHome => 'At home';

  @override
  String get eventBoarded => 'Boarded the bus';

  @override
  String get eventArrivedSchool => 'Arrived at school';

  @override
  String get eventAlighted => 'Alighted';

  @override
  String get dayToday => 'Today';

  @override
  String get dayYesterday => 'Yesterday';

  @override
  String eventTitle(String action, String time) {
    return '$action — $time';
  }

  @override
  String eventSubtitle(String day, String place, String matron) {
    return '$day · $place\nMatron: $matron';
  }

  @override
  String get profileAccountTypeParent => 'Parent';

  @override
  String get profileAccountType => 'Account type';

  @override
  String get profileParentSection => 'Parent details';

  @override
  String get profileFullName => 'Name';

  @override
  String profileRoleSummary(String phone) {
    return 'Parent · $phone';
  }

  @override
  String get profileGuardiansSection => 'Approved to pick up children';

  @override
  String get profileGuardianApproved => 'Approved to pick up the child';

  @override
  String get profileGuardiansNotice =>
      'Only you can add or remove these people. The real management arrives in Phase 8.';

  @override
  String get profileChildrenSection => 'Children and schools';

  @override
  String get profileChildrenNotice =>
      'Children can be at different schools. Each child has their own matron and route.';

  @override
  String get profileSettingsSection => 'Settings';

  @override
  String get languageDialogTitle => 'Choose a language';

  @override
  String get loginErrorInvalid => 'Phone number or password is incorrect.';

  @override
  String get loginErrorNetwork =>
      'Could not reach the server. Check your connection and try again.';

  @override
  String get loginErrorGeneric => 'Sign in failed. Please try again.';

  @override
  String get loginDevButton => 'Sign in in test mode (DEV)';

  @override
  String get roleUnsupportedTitle => 'This account is not supported yet';

  @override
  String get roleUnsupportedBody =>
      'The page for this account will arrive in a later phase. For now you can sign in as a parent or driver.';

  @override
  String get roleLabel => 'Account type';

  @override
  String get roleLabelParent => 'Parent';

  @override
  String get roleLabelDriver => 'Driver';

  @override
  String get roleLabelMatron => 'Matron';

  @override
  String get roleLabelSchoolAdmin => 'School admin';

  @override
  String get roleLabelSuperAdmin => 'Super admin';

  @override
  String get roleLabelUnknown => 'Unknown';

  @override
  String get driverHomeTitle => 'Driver trips';

  @override
  String get driverHomeSubtitle => 'Your assigned trip for today';

  @override
  String driverGreeting(String name) {
    return 'Welcome, $name';
  }

  @override
  String get driverNavHome => 'Home';

  @override
  String get driverNavStudents => 'Students';

  @override
  String get driverNavMap => 'Map';

  @override
  String get driverNavProfile => 'Profile';

  @override
  String get driverNextStop => 'Next stop';

  @override
  String get driverNoNextStop => 'No stop set';

  @override
  String get driverStopsShort => 'Stops';

  @override
  String get driverTripTypeShort => 'Type';

  @override
  String get driverTripDetails => 'Trip details';

  @override
  String get driverStudentsEmptyTitle => 'No students on this route';

  @override
  String get driverStudentsEmptySubtitle =>
      'No child is assigned to this route yet. A school admin needs to assign students to the route and stops.';

  @override
  String get driverStudentsOrderNote =>
      'Ordered by drop-off stop. The next student off appears first.';

  @override
  String get driverStudentsOrderMorning =>
      'Ordered by pickup stop. The next student to board appears first.';

  @override
  String get driverStudentsOrderAfternoon =>
      'Ordered by drop-off stop. The next student off appears first.';

  @override
  String driverStudentsCount(int count) {
    return 'Students: $count';
  }

  @override
  String get driverStudentsLoading => 'Loading students...';

  @override
  String get driverStudentsSwipeHint =>
      'Swipe left or right to see all students.';

  @override
  String get driverStudentsNext => 'Next';

  @override
  String get driverStudentsFirstOff => 'First to get off';

  @override
  String get driverStudentsFirstOn => 'First to board';

  @override
  String get driverStudentsStop => 'Stop';

  @override
  String get driverStudentsClass => 'Class';

  @override
  String get driverStudentsNoStop => 'No stop set';

  @override
  String get driverStudentsErrorTitle => 'Manifest not loaded';

  @override
  String get driverStudentsError =>
      'Could not load the student list. Please try again.';

  @override
  String get driverAttendanceNone => 'Not recorded';

  @override
  String get driverAttendanceBoarded => 'Boarded';

  @override
  String get driverAttendanceAlighted => 'Alighted';

  @override
  String get driverAttendanceAbsent => 'Absent';

  @override
  String get driverAttendanceExcused => 'Excused';

  @override
  String get driverAttendanceRecord => 'Record attendance';

  @override
  String get driverAttendanceChange => 'Change attendance';

  @override
  String driverAttendanceSheetTitle(String name) {
    return 'Attendance for $name';
  }

  @override
  String get driverAttendancePendingNote =>
      'Start the trip before recording attendance.';

  @override
  String get driverAttendanceSaved => 'Attendance recorded.';

  @override
  String get driverAttendanceFailed =>
      'Could not record attendance. Please try again.';

  @override
  String get driverMapEmptyTitle => 'Map and GPS coming next';

  @override
  String get driverMapEmptySubtitle =>
      'We will connect the real bus location and stops. There is no simulated GPS.';

  @override
  String get driverMapNote =>
      'The map will use real route and bus location data.';

  @override
  String get driverProfileSection => 'Driver details';

  @override
  String get driverProfileNotice =>
      'These details come from your driver account.';

  @override
  String get driverLoadingTrip => 'Loading trip...';

  @override
  String get driverNoTripTitle => 'No trip scheduled';

  @override
  String get driverNoTripSubtitle =>
      'There is no active or scheduled trip for you right now. Pull down to refresh.';

  @override
  String get driverTripStatus => 'Trip status';

  @override
  String get driverStatusPending => 'Scheduled';

  @override
  String get driverStatusActive => 'In progress';

  @override
  String get driverStatusCompleted => 'Completed';

  @override
  String get driverStatusCancelled => 'Cancelled';

  @override
  String get driverTripType => 'Trip type';

  @override
  String get driverTripTypeMorning => 'Morning';

  @override
  String get driverTripTypeAfternoon => 'Afternoon';

  @override
  String get driverBus => 'Bus';

  @override
  String get driverRoute => 'Route';

  @override
  String get driverScheduledFor => 'Created';

  @override
  String get driverStartedAt => 'Started';

  @override
  String get driverEndedAt => 'Ended';

  @override
  String get driverNoBus => 'Bus unknown';

  @override
  String get driverNoRoute => 'Route unknown';

  @override
  String get driverReadiness => 'Trip readiness';

  @override
  String get driverReadyDriver => 'This trip is assigned to you';

  @override
  String get driverReadyBus => 'Bus is assigned';

  @override
  String get driverReadyRoute => 'Route is loaded';

  @override
  String get driverReadyStops => 'Stops are loaded';

  @override
  String get driverReadyStatus => 'Trip is ready to start';

  @override
  String get driverReadyActive => 'Trip is in progress';

  @override
  String get driverStartTrip => 'Start trip';

  @override
  String get driverEndTrip => 'End trip';

  @override
  String get driverEndTripDialogTitle => 'End trip?';

  @override
  String get driverEndTripDialogBody =>
      'Are you sure you want to end this trip? This action cannot be undone.';

  @override
  String get driverEndTripConfirm => 'Yes, end trip';

  @override
  String get driverEndTripCancel => 'No, continue';

  @override
  String get driverViewStops => 'Route stops';

  @override
  String get driverStopsTitle => 'Route stops';

  @override
  String driverStopsCount(int count) {
    return 'Stops: $count';
  }

  @override
  String get driverNoStops => 'No stops have been set on this route.';

  @override
  String get driverStopNoCoordinates => 'This stop has no location (GPS) set.';

  @override
  String get driverTripConflict =>
      'The driver already has another active trip. End or cancel it first.';

  @override
  String get driverTripStarted => 'Trip started.';

  @override
  String get driverTripEnded => 'Trip completed. Thank you.';

  @override
  String get driverTripCompletedNote =>
      'This trip is complete. Refresh to check for a new trip.';

  @override
  String get driverTripCancelledNote => 'This trip was cancelled.';

  @override
  String get driverErrorNetwork =>
      'Could not reach the server. Check your connection.';

  @override
  String get driverErrorForbidden => 'You are not allowed to view this trip.';

  @override
  String get driverErrorNotFound =>
      'The trip, bus or route could not be found.';

  @override
  String get driverServerError => 'The server failed. Please try again.';
}
