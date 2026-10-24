// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appName => 'KooBus';

  @override
  String get appTagline => 'Usalama wa safari ya shule';

  @override
  String get actionCancel => 'Bado';

  @override
  String get actionRetry => 'Jaribu tena';

  @override
  String get actionRefresh => 'Onyesha upya';

  @override
  String get emptyStateNoChildren =>
      'Hakuna watoto waliounganishwa na akaunti yako bado.';

  @override
  String get emptyStateNoChildrenSubtitle =>
      'Ikiwa watoto wako hawajaonekana, wasiliana na msimamizi wa shule ili waongezwe.';

  @override
  String get emptyStateNoHistory => 'Hakuna historia ya safari kwa sasa.';

  @override
  String get emptyStateNoHistorySubtitle =>
      'Historia itaonekana hapa mtoto anapopanda au kushuka basi.';

  @override
  String get emptyStateNoAlerts => 'Hakuna taarifa kwa sasa.';

  @override
  String get emptyStateNoAlertsSubtitle => 'Taarifa kuhusu basi zitakuja hapa.';

  @override
  String get emptyStateNoTrips => 'Hakuna safari inayofanyika leo.';

  @override
  String get emptyStateNoTripsSubtitle => 'Utaarifiwa basi linapoanza safari.';

  @override
  String get errorTitle => 'Imeshindikana';

  @override
  String get devBadgeLabel => 'MFANO (DEV)';

  @override
  String get loginTitle => 'Karibu KooBus';

  @override
  String get loginSubtitle => 'Ingia ili kuona safari za watoto wako';

  @override
  String get loginPhoneLabel => 'Namba ya simu';

  @override
  String get loginPasswordLabel => 'Nenosiri';

  @override
  String get loginSubmit => 'Ingia';

  @override
  String get loginDevNotice =>
      'Hali ya MAJARIBIO (DEV): server halisi bado haijajengwa. Kuingia huku kunahifadhi session ya majaribio pekee.';

  @override
  String get validationPhoneRequired => 'Tafadhali weka namba ya simu';

  @override
  String get validationPhoneInvalid => 'Namba si sahihi. Mfano: 0712345678';

  @override
  String get validationPasswordRequired => 'Tafadhali weka nenosiri';

  @override
  String get validationPasswordTooShort => 'Nenosiri liwe na herufi 6 au zaidi';

  @override
  String get navHome => 'Nyumbani';

  @override
  String get navChildren => 'Watoto';

  @override
  String get navHistory => 'Historia';

  @override
  String get navAlerts => 'Taarifa';

  @override
  String get navProfile => 'Wasifu';

  @override
  String tabPosition(int index, int total) {
    return 'Tab $index of $total';
  }

  @override
  String get historyTitle => 'Historia';

  @override
  String get historySubtitle =>
      'Kila kupanda na kushuka kunahifadhiwa saa na matron.';

  @override
  String get logoutButton => 'Toka kwenye akaunti';

  @override
  String get logoutDialogTitle => 'Toka?';

  @override
  String get logoutDialogBody =>
      'Ukitoka, utahitaji kuingia tena kwenye kifaa hiki.';

  @override
  String get logoutConfirm => 'Ndiyo, toka';

  @override
  String get logoutFootnote =>
      'Ukitoka, session itafutwa kwenye kifaa hiki na utahitaji kuingia tena.';

  @override
  String get profileTitle => 'Wasifu';

  @override
  String get settingsLanguage => 'Lugha';

  @override
  String get settingsNotifications => 'Taarifa za push';

  @override
  String get settingsNotificationsSubtitle => 'Zitakuja Phase 10';

  @override
  String get languageSwahili => 'Kiswahili';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChanged => 'Lugha imebadilishwa';

  @override
  String welcomeUser(String phone) {
    return 'Karibu, $phone';
  }

  @override
  String get homeTodayStatus => 'Hali ya safari leo';

  @override
  String get homeMapNotice =>
      'Ramani halisi itakuja Phase 9 — hakuna GPS bado.';

  @override
  String get homePhaseNotice =>
      'Ramani, GPS na muda halisi wa kufika vitakuja Phase 9. Taarifa zote hapa ni za MFANO (DEV).';

  @override
  String etaMinutes(int minutes) {
    return 'Dakika $minutes';
  }

  @override
  String etaDistanceFrom(String km, String place) {
    return '~$km km kutoka $place';
  }

  @override
  String busCardTitle(String plate) {
    return 'Basi $plate';
  }

  @override
  String busDriver(String name) {
    return 'Dereva: $name';
  }

  @override
  String busMatron(String name) {
    return 'Matron: $name';
  }

  @override
  String busRouteLabel(String name) {
    return 'Njia $name';
  }

  @override
  String get busCallDriverNotice =>
      'Kumpigia dereva simu kutafunguliwa Phase 9.';

  @override
  String get capacityTitle => 'Wanafunzi kwenye basi';

  @override
  String capacityCount(int onboard, int capacity) {
    return '$onboard / $capacity';
  }

  @override
  String get childrenTitle => 'Watoto wako';

  @override
  String get childrenSubtitle =>
      'Gusa mtoto kuona historia ya kupanda na kushuka.';

  @override
  String get childrenMultipleSchoolsNotice =>
      'Watoto wanaweza kuwa shule tofauti — kila mmoja ana shule, darasa na matron wake.';

  @override
  String get childrenHistoryButton => 'Historia yake';

  @override
  String childSchoolClass(String school, String className) {
    return '$school · $className';
  }

  @override
  String childHistoryTitle(String name) {
    return 'Historia ya $name';
  }

  @override
  String childRouteLabel(String route) {
    return 'Njia: $route';
  }

  @override
  String get childRecentActivity => 'Shughuli za hivi karibuni';

  @override
  String get childHistoryDevNotice =>
      'Taarifa hizi ni za MFANO (DEV). Historia halisi itatoka kwenye database kupitia API (Phase 6/7).';

  @override
  String get historyTabTitle => 'Historia ya safari';

  @override
  String get historyFilterNotice =>
      'Vichujio vya tarehe/shule na historia kamili ni Phase 9.';

  @override
  String get alertsTabTitle => 'Taarifa';

  @override
  String get alertsSubtitle => 'Taarifa za basi, kupanda, kufika na kuchelewa.';

  @override
  String get alertsPushNotice => 'Push notifications halisi (FCM) ni Phase 10.';

  @override
  String get statusWaitingBus => 'Anasubiri basi';

  @override
  String get statusOnTheWay => 'Yupo njiani';

  @override
  String get statusAtSchool => 'Yuko shuleni';

  @override
  String get statusAtHome => 'Yuko nyumbani';

  @override
  String get eventBoarded => 'Alipanda basi';

  @override
  String get eventArrivedSchool => 'Alifika shule';

  @override
  String get eventAlighted => 'Alishuka';

  @override
  String get dayToday => 'Leo';

  @override
  String get dayYesterday => 'Jana';

  @override
  String eventTitle(String action, String time) {
    return '$action — $time';
  }

  @override
  String eventSubtitle(String day, String place, String matron) {
    return '$day · $place\nMatron: $matron';
  }

  @override
  String get profileAccountTypeParent => 'Mzazi';

  @override
  String get profileAccountType => 'Aina ya akaunti';

  @override
  String get profileParentSection => 'Taarifa za mzazi';

  @override
  String get profileFullName => 'Jina';

  @override
  String profileRoleSummary(String phone) {
    return 'Mzazi · $phone';
  }

  @override
  String get profileGuardiansSection => 'Waliounganishwa kuchukua watoto';

  @override
  String get profileGuardianApproved => 'Ameidhinishwa kumchukua mtoto';

  @override
  String get profileGuardiansNotice =>
      'Wewe pekee unaweza kuongeza au kuondoa watu hawa. Usimamizi halisi ni Phase 8.';

  @override
  String get profileChildrenSection => 'Watoto na shule';

  @override
  String get profileChildrenNotice =>
      'Watoto wanaweza kuwa shule tofauti. Kila mtoto ana matron na njia yake.';

  @override
  String get profileSettingsSection => 'Mipangilio';

  @override
  String get languageDialogTitle => 'Chagua lugha';
}
