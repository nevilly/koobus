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
  String get loginSubtitle => 'Karibu tena. Ingia kuendelea na KooBus';

  @override
  String get loginPhoneLabel => 'Namba ya simu';

  @override
  String get loginPasswordLabel => 'Nenosiri';

  @override
  String get loginSubmit => 'Ingia';

  @override
  String get loginDevNotice =>
      'Hali ya MAJARIBIO (DEV): kitufe hiki kinatumia token ya majaribio na data ya mfano. Kinaonekana kwenye debug build pekee.';

  @override
  String get sessionExpiredNotice =>
      'Muda wa kikao umeisha. Tafadhali ingia tena ili kuendelea.';

  @override
  String get validationPhoneRequired => 'Tafadhali weka namba ya simu';

  @override
  String get validationPhoneInvalid =>
      'Namba si sahihi. Mfano: 0712345678 au 255712345678';

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

  @override
  String get loginErrorInvalid => 'Namba ya simu au nenosiri si sahihi.';

  @override
  String get loginErrorNetwork =>
      'Imeshindikana kuunganisha na server. Angalia mtandao na ujaribu tena.';

  @override
  String get loginErrorGeneric => 'Kuingia hakukufanikiwa. Jaribu tena.';

  @override
  String get loginDevButton => 'Ingia kwa hali ya majaribio (DEV)';

  @override
  String get roleUnsupportedTitle => 'Akaunti hii bado haitumiki';

  @override
  String get roleUnsupportedBody =>
      'Ukurasa wa akaunti hii utaongezwa hatua zijazo. Kwa sasa unaweza kuingia kama mzazi au dereva.';

  @override
  String get roleLabel => 'Aina ya akaunti';

  @override
  String get roleLabelParent => 'Mzazi';

  @override
  String get roleLabelDriver => 'Dereva';

  @override
  String get roleLabelMatron => 'Matron';

  @override
  String get roleLabelSchoolAdmin => 'Msimamizi wa shule';

  @override
  String get roleLabelSuperAdmin => 'Msimamizi mkuu';

  @override
  String get roleLabelUnknown => 'Haijulikani';

  @override
  String get driverHomeTitle => 'Safari ya dereva';

  @override
  String get driverHomeSubtitle => 'Safari uliyopangiwa leo';

  @override
  String driverGreeting(String name) {
    return 'Karibu, $name';
  }

  @override
  String get driverNavHome => 'Nyumbani';

  @override
  String get driverNavStudents => 'Wanafunzi';

  @override
  String get driverNavMap => 'Ramani';

  @override
  String get driverNavProfile => 'Wasifu';

  @override
  String get driverNextStop => 'Kituo kifuatacho';

  @override
  String get driverNoNextStop => 'Hakuna kituo kilichowekwa';

  @override
  String get driverStopsShort => 'Vituo';

  @override
  String get driverTripTypeShort => 'Aina';

  @override
  String get driverTripDetails => 'Taarifa za safari';

  @override
  String get driverStudentsEmptyTitle => 'Hakuna wanafunzi kwenye route hii';

  @override
  String get driverStudentsEmptySubtitle =>
      'Hakuna mtoto aliyepewa route hii kwa sasa. Msimamizi wa shule anahitaji kuwaweka wanafunzi kwenye route na vituo.';

  @override
  String get driverStudentsOrderNote =>
      'Wamepangwa kwa kituo cha kushuka. Anayeshuka kwanza yuko mbele.';

  @override
  String get driverStudentsOrderMorning =>
      'Wamepangwa kwa kituo cha kupanda. Anayepanda kwanza yuko mbele.';

  @override
  String get driverStudentsOrderAfternoon =>
      'Wamepangwa kwa kituo cha kushuka. Anayeshuka kwanza yuko mbele.';

  @override
  String driverStudentsCount(int count) {
    return 'Wanafunzi $count';
  }

  @override
  String get driverStudentsLoading => 'Inapakia wanafunzi...';

  @override
  String get driverStudentsSwipeHint =>
      'Sogeza kushoto au kuume kuona wanafunzi wote.';

  @override
  String get driverStudentsNext => 'Kifuatacho';

  @override
  String get driverStudentsFirstOff => 'Wa kwanza kushuka';

  @override
  String get driverStudentsFirstOn => 'Wa kwanza kupanda';

  @override
  String get driverStudentsStop => 'Kituo';

  @override
  String get driverStudentsClass => 'Darasa';

  @override
  String get driverStudentsNoStop => 'Hakuna kituo kilichowekwa';

  @override
  String get driverStudentsErrorTitle => 'Manifest haijapakiwa';

  @override
  String get driverStudentsError =>
      'Imeshindikana kupakia orodha ya wanafunzi. Jaribu tena.';

  @override
  String get driverAttendanceNone => 'Hajarekodiwa';

  @override
  String get driverAttendanceBoarded => 'Amepanda';

  @override
  String get driverAttendanceAlighted => 'Ameshuka';

  @override
  String get driverAttendanceAbsent => 'Hayupo';

  @override
  String get driverAttendanceExcused => 'Ameondolewa';

  @override
  String get driverAttendanceRecord => 'Rekodi mahudhurio';

  @override
  String get driverAttendanceChange => 'Badilisha mahudhurio';

  @override
  String driverAttendanceSheetTitle(String name) {
    return 'Mahudhurio ya $name';
  }

  @override
  String get driverAttendancePendingNote =>
      'Anzisha safari kwanza ili kurekodi mahudhurio.';

  @override
  String get driverAttendanceSaved => 'Mahudhurio yamerekodiwa.';

  @override
  String get driverAttendanceFailed =>
      'Imeshindikana kurekodi mahudhurio. Jaribu tena.';

  @override
  String get driverMapEmptyTitle => 'Ramani na GPS inakuja';

  @override
  String get driverMapEmptySubtitle =>
      'Tutaunganisha eneo halisi la basi na vituo. Hakuna GPS ya kufikirika.';

  @override
  String get driverMapNote =>
      'Ramani itatumia data halisi ya route na eneo la basi.';

  @override
  String get driverProfileSection => 'Taarifa za dereva';

  @override
  String get driverProfileNotice =>
      'Taarifa hizi zinatoka kwenye akaunti yako ya dereva.';

  @override
  String get driverLoadingTrip => 'Inapakia safari...';

  @override
  String get driverNoTripTitle => 'Hakuna safari iliyopangwa';

  @override
  String get driverNoTripSubtitle =>
      'Hakuna safari inayoendelea au iliyopangwa kwako kwa sasa. Vuta chini kuonyesha upya.';

  @override
  String get driverTripStatus => 'Hali ya safari';

  @override
  String get driverStatusPending => 'Imepangwa';

  @override
  String get driverStatusActive => 'Inaendelea';

  @override
  String get driverStatusCompleted => 'Imekamilika';

  @override
  String get driverStatusCancelled => 'Imeghairiwa';

  @override
  String get driverTripType => 'Aina ya safari';

  @override
  String get driverTripTypeMorning => 'Asubuhi';

  @override
  String get driverTripTypeAfternoon => 'Mchana';

  @override
  String get driverBus => 'Basi';

  @override
  String get driverRoute => 'Route';

  @override
  String get driverScheduledFor => 'Imeundwa';

  @override
  String get driverStartedAt => 'Ilianza';

  @override
  String get driverEndedAt => 'Ilikamilika';

  @override
  String get driverNoBus => 'Basi halijulikani';

  @override
  String get driverNoRoute => 'Route haijulikani';

  @override
  String get driverReadiness => 'Utayari wa safari';

  @override
  String get driverReadyDriver => 'Wewe umepewa safari hii';

  @override
  String get driverReadyBus => 'Basi limepangwa';

  @override
  String get driverReadyRoute => 'Route imepakiwa';

  @override
  String get driverReadyStops => 'Vituo vimepakiwa';

  @override
  String get driverReadyStatus => 'Safari iko tayari kuanza';

  @override
  String get driverReadyActive => 'Safari inaendelea';

  @override
  String get driverStartTrip => 'Anza safari';

  @override
  String get driverEndTrip => 'Maliza safari';

  @override
  String get driverEndTripDialogTitle => 'Maliza safari?';

  @override
  String get driverEndTripDialogBody =>
      'Una uhakika unataka kumaliza safari hii? Hatua hii haiwezi kutenduliwa.';

  @override
  String get driverEndTripConfirm => 'Ndiyo, maliza';

  @override
  String get driverEndTripCancel => 'Hapana, endelea';

  @override
  String get driverViewStops => 'Vituo vya route';

  @override
  String get driverStopsTitle => 'Vituo vya route';

  @override
  String driverStopsCount(int count) {
    return 'Vituo $count';
  }

  @override
  String get driverNoStops => 'Hakuna vituo vilivyowekwa kwenye route hii.';

  @override
  String get driverStopNoCoordinates =>
      'Kituo hiki hakina mahali (GPS) kilichowekwa.';

  @override
  String get driverTripConflict =>
      'Dereva ana safari nyingine inayoendelea. Maliza au ghairi kwanza.';

  @override
  String get driverTripStarted => 'Safari imeanza.';

  @override
  String get driverTripEnded => 'Safari imekamilika. Asante.';

  @override
  String get driverTripCompletedNote =>
      'Safari hii imekamilika. Onyesha upya kama kuna safari mpya.';

  @override
  String get driverTripCancelledNote => 'Safari hii imeghairiwa.';

  @override
  String get driverErrorNetwork =>
      'Imeshindikana kuunganisha na server. Angalia mtandao.';

  @override
  String get driverErrorForbidden => 'Huna ruhusa kuona safari hii.';

  @override
  String get driverErrorNotFound => 'Safari, basi au route haipatikani.';

  @override
  String get driverServerError => 'Server imeshindikana. Jaribu tena.';
}
