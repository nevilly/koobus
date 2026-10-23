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
  String get errorTitle => 'Something went wrong';

  @override
  String get devBadgeLabel => 'SAMPLE (DEV)';

  @override
  String get loginTitle => 'Welcome to KooBus';

  @override
  String get loginSubtitle => 'Log in to see your children\'s trips';

  @override
  String get loginPhoneLabel => 'Phone number';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSubmit => 'Log in';

  @override
  String get loginDevNotice =>
      'TEST mode (DEV): the real server is not built yet. This login only saves a test session.';

  @override
  String get validationPhoneRequired => 'Please enter your phone number';

  @override
  String get validationPhoneInvalid => 'Invalid number. Example: 0712345678';

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
}
