import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  /// Jina la app. Halitafsiriwi.
  ///
  /// In sw, this message translates to:
  /// **'KooBus'**
  String get appName;

  /// Mstari wa chini ya jina kwenye splash screen.
  ///
  /// In sw, this message translates to:
  /// **'Usalama wa safari ya shule'**
  String get appTagline;

  /// Kitufe cha kufunga dialog bila kufanya kitu.
  ///
  /// In sw, this message translates to:
  /// **'Bado'**
  String get actionCancel;

  /// Kitufe kwenye ErrorView ili kujaribu oparesheni tena.
  ///
  /// In sw, this message translates to:
  /// **'Jaribu tena'**
  String get actionRetry;

  /// Kitufe cha ku-refresh data.
  ///
  /// In sw, this message translates to:
  /// **'Onyesha upya'**
  String get actionRefresh;

  /// Hali tupu pale hakuna watoto.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna watoto waliounganishwa na akaunti yako bado.'**
  String get emptyStateNoChildren;

  /// Maelezo ya ziada ya hali tupu ya watoto.
  ///
  /// In sw, this message translates to:
  /// **'Ikiwa watoto wako hawajaonekana, wasiliana na msimamizi wa shule ili waongezwe.'**
  String get emptyStateNoChildrenSubtitle;

  /// Hali tupu pale hakuna historia.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna historia ya safari kwa sasa.'**
  String get emptyStateNoHistory;

  /// Maelezo ya ziada ya hali tupu ya historia.
  ///
  /// In sw, this message translates to:
  /// **'Historia itaonekana hapa mtoto anapopanda au kushuka basi.'**
  String get emptyStateNoHistorySubtitle;

  /// Hali tupu pale hakuna taarifa.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna taarifa kwa sasa.'**
  String get emptyStateNoAlerts;

  /// Maelezo ya ziada ya hali tupu ya taarifa.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa kuhusu basi zitakuja hapa.'**
  String get emptyStateNoAlertsSubtitle;

  /// Hali tupu pale hakuna safari inayoendelea.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna safari inayofanyika leo.'**
  String get emptyStateNoTrips;

  /// Maelezo ya ziada ya hali tupu ya safari.
  ///
  /// In sw, this message translates to:
  /// **'Utaarifiwa basi linapoanza safari.'**
  String get emptyStateNoTripsSubtitle;

  /// Kichwa cha kawaida cha kosa kwenye ErrorView.
  ///
  /// In sw, this message translates to:
  /// **'Imeshindikana'**
  String get errorTitle;

  /// Beji inayoonyesha data ni ya mfano, si ya server halisi.
  ///
  /// In sw, this message translates to:
  /// **'MFANO (DEV)'**
  String get devBadgeLabel;

  /// Kichwa cha screen ya kuingia.
  ///
  /// In sw, this message translates to:
  /// **'Karibu KooBus'**
  String get loginTitle;

  /// Maelezo chini ya kichwa cha login.
  ///
  /// In sw, this message translates to:
  /// **'Karibu tena. Ingia kuendelea na KooBus'**
  String get loginSubtitle;

  /// Lebo ya field ya namba ya simu.
  ///
  /// In sw, this message translates to:
  /// **'Namba ya simu'**
  String get loginPhoneLabel;

  /// Lebo ya field ya nenosiri.
  ///
  /// In sw, this message translates to:
  /// **'Nenosiri'**
  String get loginPasswordLabel;

  /// Kitufe cha kuingia.
  ///
  /// In sw, this message translates to:
  /// **'Ingia'**
  String get loginSubmit;

  /// Taarifa kwenye login ikikumbusha kuwa hakuna server bado.
  ///
  /// In sw, this message translates to:
  /// **'Hali ya MAJARIBIO (DEV): kitufe hiki kinatumia token ya majaribio na data ya mfano. Kinaonekana kwenye debug build pekee.'**
  String get loginDevNotice;

  /// Ujumbe unaoonyeshwa kwenye login pale token ilipoisha muda.
  ///
  /// In sw, this message translates to:
  /// **'Muda wa kikao umeisha. Tafadhali ingia tena ili kuendelea.'**
  String get sessionExpiredNotice;

  /// Hitilafu ikiwa field ya simu ipo wazi.
  ///
  /// In sw, this message translates to:
  /// **'Tafadhali weka namba ya simu'**
  String get validationPhoneRequired;

  /// Hitilafu ikiwa namba ya simu si sahihi.
  ///
  /// In sw, this message translates to:
  /// **'Namba si sahihi. Mfano: 0712345678 au 255712345678'**
  String get validationPhoneInvalid;

  /// Hitilafu ikiwa field ya nenosiri ipo wazi.
  ///
  /// In sw, this message translates to:
  /// **'Tafadhali weka nenosiri'**
  String get validationPasswordRequired;

  /// Hitilafu ikiwa nenosiri ni fupi mno.
  ///
  /// In sw, this message translates to:
  /// **'Nenosiri liwe na herufi 6 au zaidi'**
  String get validationPasswordTooShort;

  /// Tab ya kwanza: muhtasari wa leo.
  ///
  /// In sw, this message translates to:
  /// **'Nyumbani'**
  String get navHome;

  /// Tab ya pili: orodha ya watoto.
  ///
  /// In sw, this message translates to:
  /// **'Watoto'**
  String get navChildren;

  /// Tab ya tatu: historia ya safari.
  ///
  /// In sw, this message translates to:
  /// **'Historia'**
  String get navHistory;

  /// Tab ya nne: taarifa/alerts.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa'**
  String get navAlerts;

  /// Tab ya tano: wasifu wa mzazi.
  ///
  /// In sw, this message translates to:
  /// **'Wasifu'**
  String get navProfile;

  /// Maelezo ya screen reader kwa tab ya sasa.
  ///
  /// In sw, this message translates to:
  /// **'Tab {index} of {total}'**
  String tabPosition(int index, int total);

  /// Kichwa cha screen ya historia.
  ///
  /// In sw, this message translates to:
  /// **'Historia'**
  String get historyTitle;

  /// Maelezo chini ya kichwa cha historia.
  ///
  /// In sw, this message translates to:
  /// **'Kila kupanda na kushuka kunahifadhiwa saa na matron.'**
  String get historySubtitle;

  /// Kitufe cha kutoka kwenye akaunti.
  ///
  /// In sw, this message translates to:
  /// **'Toka kwenye akaunti'**
  String get logoutButton;

  /// Kichwa cha dialog ya kuthibitisha kutoka.
  ///
  /// In sw, this message translates to:
  /// **'Toka?'**
  String get logoutDialogTitle;

  /// Maelezo kwenye dialog ya kutoka.
  ///
  /// In sw, this message translates to:
  /// **'Ukitoka, utahitaji kuingia tena kwenye kifaa hiki.'**
  String get logoutDialogBody;

  /// Kitufe cha kuthibitisha kutoka.
  ///
  /// In sw, this message translates to:
  /// **'Ndiyo, toka'**
  String get logoutConfirm;

  /// Maelezo madogo chini ya kitufe cha kutoka.
  ///
  /// In sw, this message translates to:
  /// **'Ukitoka, session itafutwa kwenye kifaa hiki na utahitaji kuingia tena.'**
  String get logoutFootnote;

  /// Kichwa cha tab ya wasifu.
  ///
  /// In sw, this message translates to:
  /// **'Wasifu'**
  String get profileTitle;

  /// Lebo ya mipangilio ya lugha.
  ///
  /// In sw, this message translates to:
  /// **'Lugha'**
  String get settingsLanguage;

  /// Lebo ya mipangilio ya taarifa za push.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa za push'**
  String get settingsNotifications;

  /// Maelezo kuwa push notifications bado hazijajengwa.
  ///
  /// In sw, this message translates to:
  /// **'Zitakuja Phase 10'**
  String get settingsNotificationsSubtitle;

  /// Jina la lugha ya Kiswahili. Halitafsiriwi.
  ///
  /// In sw, this message translates to:
  /// **'Kiswahili'**
  String get languageSwahili;

  /// Jina la lugha ya Kiingereza. Halitafsiriwi.
  ///
  /// In sw, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Ujumbo mfupi unaothibitisha lugha imebadilishwa.
  ///
  /// In sw, this message translates to:
  /// **'Lugha imebadilishwa'**
  String get languageChanged;

  /// Salamu kwenye Nyumbani.
  ///
  /// In sw, this message translates to:
  /// **'Karibu, {phone}'**
  String welcomeUser(String phone);

  /// Maelezo chini ya salamu kwenye Nyumbani.
  ///
  /// In sw, this message translates to:
  /// **'Hali ya safari leo'**
  String get homeTodayStatus;

  /// Maandishi juu ya 'ramani' ya mfano.
  ///
  /// In sw, this message translates to:
  /// **'Ramani halisi itakuja Phase 9 — hakuna GPS bado.'**
  String get homeMapNotice;

  /// Maelezo ya chini kwenye Nyumbani.
  ///
  /// In sw, this message translates to:
  /// **'Ramani, GPS na muda halisi wa kufika vitakuja Phase 9. Taarifa zote hapa ni za MFANO (DEV).'**
  String get homePhaseNotice;

  /// Muda uliobaki hadi basi kufika (ETA).
  ///
  /// In sw, this message translates to:
  /// **'Dakika {minutes}'**
  String etaMinutes(int minutes);

  /// Umbali kutoka mahali fulani. `place` ni jina halisi.
  ///
  /// In sw, this message translates to:
  /// **'~{km} km kutoka {place}'**
  String etaDistanceFrom(String km, String place);

  /// Namba ya basi; `plate` ni jina halisi.
  ///
  /// In sw, this message translates to:
  /// **'Basi {plate}'**
  String busCardTitle(String plate);

  /// Jina la dereva; `name` ni jina halisi.
  ///
  /// In sw, this message translates to:
  /// **'Dereva: {name}'**
  String busDriver(String name);

  /// Jina la matron; `name` ni jina halisi.
  ///
  /// In sw, this message translates to:
  /// **'Matron: {name}'**
  String busMatron(String name);

  /// Lebo ya njia; `name` ni jina halisi la njia.
  ///
  /// In sw, this message translates to:
  /// **'Njia {name}'**
  String busRouteLabel(String name);

  /// Maelezo kuwa kupiga simu dereva bado hakujajengwa.
  ///
  /// In sw, this message translates to:
  /// **'Kumpigia dereva simu kutafunguliwa Phase 9.'**
  String get busCallDriverNotice;

  /// Kichwa cha kadi ya uwezo wa basi.
  ///
  /// In sw, this message translates to:
  /// **'Wanafunzi kwenye basi'**
  String get capacityTitle;

  /// Idadi iliyopo / uwezo kamili.
  ///
  /// In sw, this message translates to:
  /// **'{onboard} / {capacity}'**
  String capacityCount(int onboard, int capacity);

  /// Kichwa cha tab ya Watoto.
  ///
  /// In sw, this message translates to:
  /// **'Watoto wako'**
  String get childrenTitle;

  /// Maelezo chini ya kichwa cha Watoto.
  ///
  /// In sw, this message translates to:
  /// **'Gusa mtoto kuona historia ya kupanda na kushuka.'**
  String get childrenSubtitle;

  /// Maelezo ya chini kwenye tab ya Watoto.
  ///
  /// In sw, this message translates to:
  /// **'Watoto wanaweza kuwa shule tofauti — kila mmoja ana shule, darasa na matron wake.'**
  String get childrenMultipleSchoolsNotice;

  /// Kitufe cha kufungua historia ya mtoto mmoja.
  ///
  /// In sw, this message translates to:
  /// **'Historia yake'**
  String get childrenHistoryButton;

  /// Shule na darasa, zimetenganishwa kwa nukta.
  ///
  /// In sw, this message translates to:
  /// **'{school} · {className}'**
  String childSchoolClass(String school, String className);

  /// Kichwa cha screen ya historia; `name` ni jina halisi.
  ///
  /// In sw, this message translates to:
  /// **'Historia ya {name}'**
  String childHistoryTitle(String name);

  /// Lebo ya njia; `route` ni jina halisi la njia.
  ///
  /// In sw, this message translates to:
  /// **'Njia: {route}'**
  String childRouteLabel(String route);

  /// Kichwa cha orodha ya matukio kwenye historia ya mtoto.
  ///
  /// In sw, this message translates to:
  /// **'Shughuli za hivi karibuni'**
  String get childRecentActivity;

  /// Onyo la DEV kwenye historia ya mtoto.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa hizi ni za MFANO (DEV). Historia halisi itatoka kwenye database kupitia API (Phase 6/7).'**
  String get childHistoryDevNotice;

  /// Kichwa cha tab ya Historia.
  ///
  /// In sw, this message translates to:
  /// **'Historia ya safari'**
  String get historyTabTitle;

  /// Maelezo ya chini kwenye tab ya Historia.
  ///
  /// In sw, this message translates to:
  /// **'Vichujio vya tarehe/shule na historia kamili ni Phase 9.'**
  String get historyFilterNotice;

  /// Kichwa cha tab ya Taarifa.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa'**
  String get alertsTabTitle;

  /// Maelezo chini ya kichwa cha Taarifa.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa za basi, kupanda, kufika na kuchelewa.'**
  String get alertsSubtitle;

  /// Maelezo ya chini kwenye tab ya Taarifa.
  ///
  /// In sw, this message translates to:
  /// **'Push notifications halisi (FCM) ni Phase 10.'**
  String get alertsPushNotice;

  /// Hali ya mtoto: hasa kupanda.
  ///
  /// In sw, this message translates to:
  /// **'Anasubiri basi'**
  String get statusWaitingBus;

  /// Hali ya mtoto: yupo kwenye basi.
  ///
  /// In sw, this message translates to:
  /// **'Yupo njiani'**
  String get statusOnTheWay;

  /// Hali ya mtoto: amefika shule.
  ///
  /// In sw, this message translates to:
  /// **'Yuko shuleni'**
  String get statusAtSchool;

  /// Hali ya mtoto: amefika nyumbani.
  ///
  /// In sw, this message translates to:
  /// **'Yuko nyumbani'**
  String get statusAtHome;

  /// Tukio: mtoto alipanda basi.
  ///
  /// In sw, this message translates to:
  /// **'Alipanda basi'**
  String get eventBoarded;

  /// Tukio: mtoto alifika shule.
  ///
  /// In sw, this message translates to:
  /// **'Alifika shule'**
  String get eventArrivedSchool;

  /// Tukio: mtoto alishuka kwenye basi.
  ///
  /// In sw, this message translates to:
  /// **'Alishuka'**
  String get eventAlighted;

  /// Siku ya tukio: leo.
  ///
  /// In sw, this message translates to:
  /// **'Leo'**
  String get dayToday;

  /// Siku ya tukio: jana.
  ///
  /// In sw, this message translates to:
  /// **'Jana'**
  String get dayYesterday;

  /// Kichwa cha kadi ya tukio: kitendo na saa.
  ///
  /// In sw, this message translates to:
  /// **'{action} — {time}'**
  String eventTitle(String action, String time);

  /// Maelezo ya kadi ya tukio: siku, mahali, matron.
  ///
  /// In sw, this message translates to:
  /// **'{day} · {place}\nMatron: {matron}'**
  String eventSubtitle(String day, String place, String matron);

  /// Aina ya akaunti kwenye wasifu.
  ///
  /// In sw, this message translates to:
  /// **'Mzazi'**
  String get profileAccountTypeParent;

  /// Lebo ya aina ya akaunti.
  ///
  /// In sw, this message translates to:
  /// **'Aina ya akaunti'**
  String get profileAccountType;

  /// Kichwa cha sehemu ya taarifa za mzazi.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa za mzazi'**
  String get profileParentSection;

  /// Lebo ya jina kamili.
  ///
  /// In sw, this message translates to:
  /// **'Jina'**
  String get profileFullName;

  /// Muhtasari chini ya jina la mzazi.
  ///
  /// In sw, this message translates to:
  /// **'Mzazi · {phone}'**
  String profileRoleSummary(String phone);

  /// Kichwa cha sehemu ya walioidhinishwa.
  ///
  /// In sw, this message translates to:
  /// **'Waliounganishwa kuchukua watoto'**
  String get profileGuardiansSection;

  /// Maelezo ya alama ya uthibitisho kwa mlezi.
  ///
  /// In sw, this message translates to:
  /// **'Ameidhinishwa kumchukua mtoto'**
  String get profileGuardianApproved;

  /// Maelezo ya chini kwenye sehemu ya walioidhinishwa.
  ///
  /// In sw, this message translates to:
  /// **'Wewe pekee unaweza kuongeza au kuondoa watu hawa. Usimamizi halisi ni Phase 8.'**
  String get profileGuardiansNotice;

  /// Kichwa cha sehemu ya watoto na shule.
  ///
  /// In sw, this message translates to:
  /// **'Watoto na shule'**
  String get profileChildrenSection;

  /// Maelezo ya chini kwenye sehemu ya watoto.
  ///
  /// In sw, this message translates to:
  /// **'Watoto wanaweza kuwa shule tofauti. Kila mtoto ana matron na njia yake.'**
  String get profileChildrenNotice;

  /// Kichwa cha sehemu ya mipangilio.
  ///
  /// In sw, this message translates to:
  /// **'Mipangilio'**
  String get profileSettingsSection;

  /// Kichwa cha dialog ya kuchagua lugha.
  ///
  /// In sw, this message translates to:
  /// **'Chagua lugha'**
  String get languageDialogTitle;

  /// No description provided for @loginErrorInvalid.
  ///
  /// In sw, this message translates to:
  /// **'Namba ya simu au nenosiri si sahihi.'**
  String get loginErrorInvalid;

  /// No description provided for @loginErrorNetwork.
  ///
  /// In sw, this message translates to:
  /// **'Imeshindikana kuunganisha na server. Angalia mtandao na ujaribu tena.'**
  String get loginErrorNetwork;

  /// No description provided for @loginErrorGeneric.
  ///
  /// In sw, this message translates to:
  /// **'Kuingia hakukufanikiwa. Jaribu tena.'**
  String get loginErrorGeneric;

  /// No description provided for @loginDevButton.
  ///
  /// In sw, this message translates to:
  /// **'Ingia kwa hali ya majaribio (DEV)'**
  String get loginDevButton;

  /// No description provided for @roleUnsupportedTitle.
  ///
  /// In sw, this message translates to:
  /// **'Akaunti hii bado haitumiki'**
  String get roleUnsupportedTitle;

  /// No description provided for @roleUnsupportedBody.
  ///
  /// In sw, this message translates to:
  /// **'Ukurasa wa akaunti hii utaongezwa hatua zijazo. Kwa sasa unaweza kuingia kama mzazi, dereva, Matron/Patron au msimamizi wa shule.'**
  String get roleUnsupportedBody;

  /// No description provided for @roleLabel.
  ///
  /// In sw, this message translates to:
  /// **'Aina ya akaunti'**
  String get roleLabel;

  /// No description provided for @roleLabelParent.
  ///
  /// In sw, this message translates to:
  /// **'Mzazi'**
  String get roleLabelParent;

  /// No description provided for @roleLabelDriver.
  ///
  /// In sw, this message translates to:
  /// **'Dereva'**
  String get roleLabelDriver;

  /// No description provided for @roleLabelMatron.
  ///
  /// In sw, this message translates to:
  /// **'Matron/Patron'**
  String get roleLabelMatron;

  /// No description provided for @roleLabelSchoolAdmin.
  ///
  /// In sw, this message translates to:
  /// **'Msimamizi wa shule'**
  String get roleLabelSchoolAdmin;

  /// No description provided for @roleLabelSuperAdmin.
  ///
  /// In sw, this message translates to:
  /// **'Msimamizi mkuu'**
  String get roleLabelSuperAdmin;

  /// No description provided for @roleLabelUnknown.
  ///
  /// In sw, this message translates to:
  /// **'Haijulikani'**
  String get roleLabelUnknown;

  /// No description provided for @driverHomeTitle.
  ///
  /// In sw, this message translates to:
  /// **'Safari ya dereva'**
  String get driverHomeTitle;

  /// No description provided for @driverHomeSubtitle.
  ///
  /// In sw, this message translates to:
  /// **'Safari uliyopangiwa leo'**
  String get driverHomeSubtitle;

  /// Salamu kwa dereva.
  ///
  /// In sw, this message translates to:
  /// **'Karibu, {name}'**
  String driverGreeting(String name);

  /// Tab ya nyumbani kwenye bottom navigation ya dereva.
  ///
  /// In sw, this message translates to:
  /// **'Nyumbani'**
  String get driverNavHome;

  /// Tab ya wanafunzi kwenye bottom navigation ya dereva.
  ///
  /// In sw, this message translates to:
  /// **'Wanafunzi'**
  String get driverNavStudents;

  /// Tab ya ramani kwenye bottom navigation ya dereva.
  ///
  /// In sw, this message translates to:
  /// **'Ramani'**
  String get driverNavMap;

  /// Tab ya wasifu kwenye bottom navigation ya dereva.
  ///
  /// In sw, this message translates to:
  /// **'Wasifu'**
  String get driverNavProfile;

  /// No description provided for @driverNextStop.
  ///
  /// In sw, this message translates to:
  /// **'Kituo kifuatacho'**
  String get driverNextStop;

  /// No description provided for @driverNoNextStop.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna kituo kilichowekwa'**
  String get driverNoNextStop;

  /// No description provided for @driverStopsShort.
  ///
  /// In sw, this message translates to:
  /// **'Vituo'**
  String get driverStopsShort;

  /// No description provided for @driverTripTypeShort.
  ///
  /// In sw, this message translates to:
  /// **'Aina'**
  String get driverTripTypeShort;

  /// No description provided for @driverTripDetails.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa za safari'**
  String get driverTripDetails;

  /// No description provided for @driverStudentsEmptyTitle.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna wanafunzi kwenye route hii'**
  String get driverStudentsEmptyTitle;

  /// No description provided for @driverStudentsEmptySubtitle.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna mtoto aliyepewa route hii kwa sasa. Msimamizi wa shule anahitaji kuwaweka wanafunzi kwenye route na vituo.'**
  String get driverStudentsEmptySubtitle;

  /// No description provided for @driverStudentsOrderNote.
  ///
  /// In sw, this message translates to:
  /// **'Wamepangwa kwa kituo cha kushuka. Anayeshuka kwanza yuko mbele.'**
  String get driverStudentsOrderNote;

  /// No description provided for @driverStudentsOrderMorning.
  ///
  /// In sw, this message translates to:
  /// **'Wamepangwa kwa kituo cha kupanda. Anayepanda kwanza yuko mbele.'**
  String get driverStudentsOrderMorning;

  /// No description provided for @driverStudentsOrderAfternoon.
  ///
  /// In sw, this message translates to:
  /// **'Wamepangwa kwa kituo cha kushuka. Anayeshuka kwanza yuko mbele.'**
  String get driverStudentsOrderAfternoon;

  /// Idadi ya wanafunzi kwenye manifest ya safari.
  ///
  /// In sw, this message translates to:
  /// **'Wanafunzi {count}'**
  String driverStudentsCount(int count);

  /// No description provided for @driverStudentsLoading.
  ///
  /// In sw, this message translates to:
  /// **'Inapakia wanafunzi...'**
  String get driverStudentsLoading;

  /// No description provided for @driverStudentsSwipeHint.
  ///
  /// In sw, this message translates to:
  /// **'Sogeza kushoto au kuume kuona wanafunzi wote.'**
  String get driverStudentsSwipeHint;

  /// No description provided for @driverStudentsNext.
  ///
  /// In sw, this message translates to:
  /// **'Kifuatacho'**
  String get driverStudentsNext;

  /// No description provided for @driverStudentsFirstOff.
  ///
  /// In sw, this message translates to:
  /// **'Wa kwanza kushuka'**
  String get driverStudentsFirstOff;

  /// No description provided for @driverStudentsFirstOn.
  ///
  /// In sw, this message translates to:
  /// **'Wa kwanza kupanda'**
  String get driverStudentsFirstOn;

  /// No description provided for @driverStudentsStop.
  ///
  /// In sw, this message translates to:
  /// **'Kituo'**
  String get driverStudentsStop;

  /// No description provided for @driverStudentsClass.
  ///
  /// In sw, this message translates to:
  /// **'Darasa'**
  String get driverStudentsClass;

  /// No description provided for @driverStudentsNoStop.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna kituo kilichowekwa'**
  String get driverStudentsNoStop;

  /// No description provided for @driverStudentsErrorTitle.
  ///
  /// In sw, this message translates to:
  /// **'Manifest haijapakiwa'**
  String get driverStudentsErrorTitle;

  /// No description provided for @driverStudentsError.
  ///
  /// In sw, this message translates to:
  /// **'Imeshindikana kupakia orodha ya wanafunzi. Jaribu tena.'**
  String get driverStudentsError;

  /// No description provided for @driverAttendanceNone.
  ///
  /// In sw, this message translates to:
  /// **'Hajarekodiwa'**
  String get driverAttendanceNone;

  /// No description provided for @driverAttendanceBoarded.
  ///
  /// In sw, this message translates to:
  /// **'Amepanda'**
  String get driverAttendanceBoarded;

  /// No description provided for @driverAttendanceAlighted.
  ///
  /// In sw, this message translates to:
  /// **'Ameshuka'**
  String get driverAttendanceAlighted;

  /// No description provided for @driverAttendanceAbsent.
  ///
  /// In sw, this message translates to:
  /// **'Hayupo'**
  String get driverAttendanceAbsent;

  /// No description provided for @driverAttendanceExcused.
  ///
  /// In sw, this message translates to:
  /// **'Ameondolewa'**
  String get driverAttendanceExcused;

  /// No description provided for @driverAttendanceRecord.
  ///
  /// In sw, this message translates to:
  /// **'Rekodi mahudhurio'**
  String get driverAttendanceRecord;

  /// No description provided for @driverAttendanceChange.
  ///
  /// In sw, this message translates to:
  /// **'Badilisha mahudhurio'**
  String get driverAttendanceChange;

  /// Kichwa cha sheet ya kurekodi mahudhurio.
  ///
  /// In sw, this message translates to:
  /// **'Mahudhurio ya {name}'**
  String driverAttendanceSheetTitle(String name);

  /// No description provided for @driverAttendancePendingNote.
  ///
  /// In sw, this message translates to:
  /// **'Anzisha safari kwanza ili kurekodi mahudhurio.'**
  String get driverAttendancePendingNote;

  /// No description provided for @driverAttendanceSaved.
  ///
  /// In sw, this message translates to:
  /// **'Mahudhurio yamerekodiwa.'**
  String get driverAttendanceSaved;

  /// No description provided for @driverAttendanceFailed.
  ///
  /// In sw, this message translates to:
  /// **'Imeshindikana kurekodi mahudhurio. Jaribu tena.'**
  String get driverAttendanceFailed;

  /// No description provided for @driverMapEmptyTitle.
  ///
  /// In sw, this message translates to:
  /// **'Ramani na GPS inakuja'**
  String get driverMapEmptyTitle;

  /// No description provided for @driverMapEmptySubtitle.
  ///
  /// In sw, this message translates to:
  /// **'Tutaunganisha eneo halisi la basi na vituo. Hakuna GPS ya kufikirika.'**
  String get driverMapEmptySubtitle;

  /// No description provided for @driverMapNote.
  ///
  /// In sw, this message translates to:
  /// **'Ramani itatumia data halisi ya route na eneo la basi.'**
  String get driverMapNote;

  /// No description provided for @driverMapTitle.
  ///
  /// In sw, this message translates to:
  /// **'Ramani'**
  String get driverMapTitle;

  /// No description provided for @driverMapLive.
  ///
  /// In sw, this message translates to:
  /// **'Moja kwa moja'**
  String get driverMapLive;

  /// No description provided for @driverMapStale.
  ///
  /// In sw, this message translates to:
  /// **'Eneo la zamani'**
  String get driverMapStale;

  /// No description provided for @driverMapLocating.
  ///
  /// In sw, this message translates to:
  /// **'Inatafuta GPS...'**
  String get driverMapLocating;

  /// No description provided for @driverMapInaccurate.
  ///
  /// In sw, this message translates to:
  /// **'Signal ya GPS ni hafifu'**
  String get driverMapInaccurate;

  /// No description provided for @driverMapGpsOff.
  ///
  /// In sw, this message translates to:
  /// **'GPS imezimwa'**
  String get driverMapGpsOff;

  /// No description provided for @driverMapPermissionDenied.
  ///
  /// In sw, this message translates to:
  /// **'Ruhusa ya eneo imekataliwa'**
  String get driverMapPermissionDenied;

  /// No description provided for @driverMapPermissionDeniedForever.
  ///
  /// In sw, this message translates to:
  /// **'Ruhusa ya eneo imezuiwa kabisa'**
  String get driverMapPermissionDeniedForever;

  /// No description provided for @driverMapOpenSettings.
  ///
  /// In sw, this message translates to:
  /// **'Fungua mipangilio'**
  String get driverMapOpenSettings;

  /// No description provided for @driverMapRetry.
  ///
  /// In sw, this message translates to:
  /// **'Jaribu tena'**
  String get driverMapRetry;

  /// No description provided for @driverMapRecenter.
  ///
  /// In sw, this message translates to:
  /// **'Nionyeshe hapa'**
  String get driverMapRecenter;

  /// GPS accuracy in metres.
  ///
  /// In sw, this message translates to:
  /// **'Usahihi {meters} m'**
  String driverMapAccuracy(int meters);

  /// Time of the last GPS update.
  ///
  /// In sw, this message translates to:
  /// **'Ilisasishwa {time}'**
  String driverMapLastUpdate(String time);

  /// No description provided for @driverMapNoActiveTrip.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna safari inayoendelea'**
  String get driverMapNoActiveTrip;

  /// No description provided for @driverMapStartToTrack.
  ///
  /// In sw, this message translates to:
  /// **'GPS huanza safari inapoanzishwa.'**
  String get driverMapStartToTrack;

  /// No description provided for @driverMapUploadFailed.
  ///
  /// In sw, this message translates to:
  /// **'Eneo halijatumwa kwa server. Tutajaribu tena.'**
  String get driverMapUploadFailed;

  /// No description provided for @driverMapAttribution.
  ///
  /// In sw, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get driverMapAttribution;

  /// No description provided for @driverMapWaitingTrip.
  ///
  /// In sw, this message translates to:
  /// **'Safari hii haijaanza. Ramani inaonyesha vituo pekee.'**
  String get driverMapWaitingTrip;

  /// No description provided for @driverMapNoStopsHint.
  ///
  /// In sw, this message translates to:
  /// **'Vituo havina mahali (GPS).'**
  String get driverMapNoStopsHint;

  /// No description provided for @driverProfileSection.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa za dereva'**
  String get driverProfileSection;

  /// No description provided for @driverProfileNotice.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa hizi zinatoka kwenye akaunti yako ya dereva.'**
  String get driverProfileNotice;

  /// No description provided for @driverLoadingTrip.
  ///
  /// In sw, this message translates to:
  /// **'Inapakia safari...'**
  String get driverLoadingTrip;

  /// No description provided for @driverNoTripTitle.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna safari iliyopangwa'**
  String get driverNoTripTitle;

  /// No description provided for @driverNoTripSubtitle.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna safari inayoendelea au iliyopangwa kwako kwa sasa. Vuta chini kuonyesha upya.'**
  String get driverNoTripSubtitle;

  /// No description provided for @driverTripStatus.
  ///
  /// In sw, this message translates to:
  /// **'Hali ya safari'**
  String get driverTripStatus;

  /// No description provided for @driverStatusPending.
  ///
  /// In sw, this message translates to:
  /// **'Imepangwa'**
  String get driverStatusPending;

  /// No description provided for @driverStatusActive.
  ///
  /// In sw, this message translates to:
  /// **'Inaendelea'**
  String get driverStatusActive;

  /// No description provided for @driverStatusCompleted.
  ///
  /// In sw, this message translates to:
  /// **'Imekamilika'**
  String get driverStatusCompleted;

  /// No description provided for @driverStatusCancelled.
  ///
  /// In sw, this message translates to:
  /// **'Imeghairiwa'**
  String get driverStatusCancelled;

  /// No description provided for @driverTripType.
  ///
  /// In sw, this message translates to:
  /// **'Aina ya safari'**
  String get driverTripType;

  /// No description provided for @driverTripTypeMorning.
  ///
  /// In sw, this message translates to:
  /// **'Asubuhi'**
  String get driverTripTypeMorning;

  /// No description provided for @driverTripTypeAfternoon.
  ///
  /// In sw, this message translates to:
  /// **'Mchana'**
  String get driverTripTypeAfternoon;

  /// No description provided for @driverBus.
  ///
  /// In sw, this message translates to:
  /// **'Basi'**
  String get driverBus;

  /// No description provided for @driverRoute.
  ///
  /// In sw, this message translates to:
  /// **'Route'**
  String get driverRoute;

  /// No description provided for @driverScheduledFor.
  ///
  /// In sw, this message translates to:
  /// **'Imeundwa'**
  String get driverScheduledFor;

  /// No description provided for @driverStartedAt.
  ///
  /// In sw, this message translates to:
  /// **'Ilianza'**
  String get driverStartedAt;

  /// No description provided for @driverEndedAt.
  ///
  /// In sw, this message translates to:
  /// **'Ilikamilika'**
  String get driverEndedAt;

  /// No description provided for @driverNoBus.
  ///
  /// In sw, this message translates to:
  /// **'Basi halijulikani'**
  String get driverNoBus;

  /// No description provided for @driverNoRoute.
  ///
  /// In sw, this message translates to:
  /// **'Route haijulikani'**
  String get driverNoRoute;

  /// No description provided for @driverReadiness.
  ///
  /// In sw, this message translates to:
  /// **'Utayari wa safari'**
  String get driverReadiness;

  /// No description provided for @driverReadyDriver.
  ///
  /// In sw, this message translates to:
  /// **'Wewe umepewa safari hii'**
  String get driverReadyDriver;

  /// No description provided for @driverReadyBus.
  ///
  /// In sw, this message translates to:
  /// **'Basi limepangwa'**
  String get driverReadyBus;

  /// No description provided for @driverReadyRoute.
  ///
  /// In sw, this message translates to:
  /// **'Route imepakiwa'**
  String get driverReadyRoute;

  /// No description provided for @driverReadyStops.
  ///
  /// In sw, this message translates to:
  /// **'Vituo vimepakiwa'**
  String get driverReadyStops;

  /// No description provided for @driverReadyStatus.
  ///
  /// In sw, this message translates to:
  /// **'Safari iko tayari kuanza'**
  String get driverReadyStatus;

  /// No description provided for @driverReadyActive.
  ///
  /// In sw, this message translates to:
  /// **'Safari inaendelea'**
  String get driverReadyActive;

  /// No description provided for @driverStartTrip.
  ///
  /// In sw, this message translates to:
  /// **'Anza safari'**
  String get driverStartTrip;

  /// No description provided for @driverEndTrip.
  ///
  /// In sw, this message translates to:
  /// **'Maliza safari'**
  String get driverEndTrip;

  /// Kichwa cha dialog ya kuthibitisha kumaliza safari.
  ///
  /// In sw, this message translates to:
  /// **'Maliza safari?'**
  String get driverEndTripDialogTitle;

  /// Maelezo ya dialog ya kuthibitisha kumaliza safari.
  ///
  /// In sw, this message translates to:
  /// **'Una uhakika unataka kumaliza safari hii? Hatua hii haiwezi kutenduliwa.'**
  String get driverEndTripDialogBody;

  /// Kitufe cha kuthibitisha kumaliza safari.
  ///
  /// In sw, this message translates to:
  /// **'Ndiyo, maliza'**
  String get driverEndTripConfirm;

  /// Kitufe cha kuacha kumaliza safari.
  ///
  /// In sw, this message translates to:
  /// **'Hapana, endelea'**
  String get driverEndTripCancel;

  /// No description provided for @driverViewStops.
  ///
  /// In sw, this message translates to:
  /// **'Vituo vya route'**
  String get driverViewStops;

  /// No description provided for @driverStopsTitle.
  ///
  /// In sw, this message translates to:
  /// **'Vituo vya route'**
  String get driverStopsTitle;

  /// Idadi ya vituo kwenye route.
  ///
  /// In sw, this message translates to:
  /// **'Vituo {count}'**
  String driverStopsCount(int count);

  /// No description provided for @driverNoStops.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna vituo vilivyowekwa kwenye route hii.'**
  String get driverNoStops;

  /// No description provided for @driverStopNoCoordinates.
  ///
  /// In sw, this message translates to:
  /// **'Kituo hiki hakina mahali (GPS) kilichowekwa.'**
  String get driverStopNoCoordinates;

  /// No description provided for @driverTripConflict.
  ///
  /// In sw, this message translates to:
  /// **'Dereva ana safari nyingine inayoendelea. Maliza au ghairi kwanza.'**
  String get driverTripConflict;

  /// No description provided for @driverTripStarted.
  ///
  /// In sw, this message translates to:
  /// **'Safari imeanza.'**
  String get driverTripStarted;

  /// No description provided for @driverTripEnded.
  ///
  /// In sw, this message translates to:
  /// **'Safari imekamilika. Asante.'**
  String get driverTripEnded;

  /// No description provided for @driverTripCompletedNote.
  ///
  /// In sw, this message translates to:
  /// **'Safari hii imekamilika. Onyesha upya kama kuna safari mpya.'**
  String get driverTripCompletedNote;

  /// No description provided for @driverTripCancelledNote.
  ///
  /// In sw, this message translates to:
  /// **'Safari hii imeghairiwa.'**
  String get driverTripCancelledNote;

  /// No description provided for @driverErrorNetwork.
  ///
  /// In sw, this message translates to:
  /// **'Imeshindikana kuunganisha na server. Angalia mtandao.'**
  String get driverErrorNetwork;

  /// No description provided for @driverErrorForbidden.
  ///
  /// In sw, this message translates to:
  /// **'Huna ruhusa kuona safari hii.'**
  String get driverErrorForbidden;

  /// No description provided for @driverErrorNotFound.
  ///
  /// In sw, this message translates to:
  /// **'Safari, basi au route haipatikani.'**
  String get driverErrorNotFound;

  /// No description provided for @driverServerError.
  ///
  /// In sw, this message translates to:
  /// **'Server imeshindikana. Jaribu tena.'**
  String get driverServerError;

  /// No description provided for @staffNavChildren.
  ///
  /// In sw, this message translates to:
  /// **'Wanafunzi'**
  String get staffNavChildren;

  /// No description provided for @staffNavSchool.
  ///
  /// In sw, this message translates to:
  /// **'Shule'**
  String get staffNavSchool;

  /// No description provided for @staffNavProfile.
  ///
  /// In sw, this message translates to:
  /// **'Wasifu'**
  String get staffNavProfile;

  /// No description provided for @staffProfileSection.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa za mfanyakazi'**
  String get staffProfileSection;

  /// No description provided for @staffProfileNotice.
  ///
  /// In sw, this message translates to:
  /// **'Taarifa hizi zinatoka kwenye akaunti yako ya shule.'**
  String get staffProfileNotice;

  /// No description provided for @staffProfileSchool.
  ///
  /// In sw, this message translates to:
  /// **'Shule'**
  String get staffProfileSchool;

  /// No description provided for @staffProfileNoSchool.
  ///
  /// In sw, this message translates to:
  /// **'Shule haijulikani'**
  String get staffProfileNoSchool;

  /// No description provided for @coordinatesTitle.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi (GPS)'**
  String get coordinatesTitle;

  /// No description provided for @coordinatesParentEntryTitle.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi na uthibitisho'**
  String get coordinatesParentEntryTitle;

  /// No description provided for @coordinatesParentEntryBody.
  ///
  /// In sw, this message translates to:
  /// **'Weka nafasi ya mtoto na uthibitisha nafasi ya shule.'**
  String get coordinatesParentEntryBody;

  /// No description provided for @coordinatesChildrenTitle.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi za wanafunzi'**
  String get coordinatesChildrenTitle;

  /// No description provided for @coordinatesChildrenSubtitle.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi ni halali pale mzazi na shule wote wamekubali.'**
  String get coordinatesChildrenSubtitle;

  /// No description provided for @coordinatesSchoolTitle.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi ya shule'**
  String get coordinatesSchoolTitle;

  /// No description provided for @coordinatesSchoolSubtitle.
  ///
  /// In sw, this message translates to:
  /// **'Weka lango au eneo la shule. Mzazi huthibitisha upande wake.'**
  String get coordinatesSchoolSubtitle;

  /// No description provided for @coordinatesInfo.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi ya upande mmoja haitumiki kwa route au ETA. Upande wa pili lazima uthibitishe.'**
  String get coordinatesInfo;

  /// No description provided for @coordinatesEmptyTitle.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna wanafunzi'**
  String get coordinatesEmptyTitle;

  /// No description provided for @coordinatesEmptyBody.
  ///
  /// In sw, this message translates to:
  /// **'Wanafunzi wataonekana hapa baada ya kusajiliwa shuleni.'**
  String get coordinatesEmptyBody;

  /// No description provided for @coordinatesEmptyParentTitle.
  ///
  /// In sw, this message translates to:
  /// **'Hakuna watoto waliounganishwa'**
  String get coordinatesEmptyParentTitle;

  /// No description provided for @coordinatesEmptyParentBody.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi zitaonekana hapa baada ya msimamizi wa shule kuunganisha mtoto na akaunti yako.'**
  String get coordinatesEmptyParentBody;

  /// No description provided for @coordinatesNoCoordinate.
  ///
  /// In sw, this message translates to:
  /// **'Haijawasilishwa'**
  String get coordinatesNoCoordinate;

  /// No description provided for @coordinatesParentConfirmed.
  ///
  /// In sw, this message translates to:
  /// **'Mzazi amethibitisha'**
  String get coordinatesParentConfirmed;

  /// No description provided for @coordinatesSchoolConfirmed.
  ///
  /// In sw, this message translates to:
  /// **'Shule imethibitisha'**
  String get coordinatesSchoolConfirmed;

  /// No description provided for @coordinatesValid.
  ///
  /// In sw, this message translates to:
  /// **'Imethibitishwa na wote'**
  String get coordinatesValid;

  /// No description provided for @coordinatesWaitingParent.
  ///
  /// In sw, this message translates to:
  /// **'Inasubiri mzazi'**
  String get coordinatesWaitingParent;

  /// No description provided for @coordinatesWaitingSchool.
  ///
  /// In sw, this message translates to:
  /// **'Inasubiri shule'**
  String get coordinatesWaitingSchool;

  /// Kichwa cha sheet ya nafasi ya mtoto.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi ya {name}'**
  String coordinatesChildSheetTitle(String name);

  /// No description provided for @coordinatesSchoolSheetTitle.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi ya shule'**
  String get coordinatesSchoolSheetTitle;

  /// No description provided for @coordinatesLatitude.
  ///
  /// In sw, this message translates to:
  /// **'Latitude'**
  String get coordinatesLatitude;

  /// No description provided for @coordinatesLongitude.
  ///
  /// In sw, this message translates to:
  /// **'Longitude'**
  String get coordinatesLongitude;

  /// No description provided for @coordinatesLabel.
  ///
  /// In sw, this message translates to:
  /// **'Maelezo (si lazima)'**
  String get coordinatesLabel;

  /// No description provided for @coordinatesLabelHint.
  ///
  /// In sw, this message translates to:
  /// **'Mfano: Nyumbani, lango la shule'**
  String get coordinatesLabelHint;

  /// No description provided for @coordinatesLatitudeHint.
  ///
  /// In sw, this message translates to:
  /// **'Mfano: -6.792354'**
  String get coordinatesLatitudeHint;

  /// No description provided for @coordinatesLongitudeHint.
  ///
  /// In sw, this message translates to:
  /// **'Mfano: 39.208328'**
  String get coordinatesLongitudeHint;

  /// No description provided for @coordinatesUseGps.
  ///
  /// In sw, this message translates to:
  /// **'Tumia GPS yangu'**
  String get coordinatesUseGps;

  /// No description provided for @coordinatesLocating.
  ///
  /// In sw, this message translates to:
  /// **'Inatafuta GPS...'**
  String get coordinatesLocating;

  /// No description provided for @coordinatesSave.
  ///
  /// In sw, this message translates to:
  /// **'Hifadhi nafasi'**
  String get coordinatesSave;

  /// No description provided for @coordinatesEdit.
  ///
  /// In sw, this message translates to:
  /// **'Badilisha nafasi'**
  String get coordinatesEdit;

  /// No description provided for @coordinatesSet.
  ///
  /// In sw, this message translates to:
  /// **'Weka nafasi'**
  String get coordinatesSet;

  /// No description provided for @coordinatesConfirm.
  ///
  /// In sw, this message translates to:
  /// **'Thibitisha'**
  String get coordinatesConfirm;

  /// No description provided for @coordinatesConfirmParentTitle.
  ///
  /// In sw, this message translates to:
  /// **'Thibitisha nafasi hii?'**
  String get coordinatesConfirmParentTitle;

  /// No description provided for @coordinatesConfirmParentBody.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi hii itatumika kwa route/ETA pale shule pia itakapothibitisha.'**
  String get coordinatesConfirmParentBody;

  /// No description provided for @coordinatesConfirmSchoolTitle.
  ///
  /// In sw, this message translates to:
  /// **'Thibitisha nafasi hii?'**
  String get coordinatesConfirmSchoolTitle;

  /// No description provided for @coordinatesConfirmSchoolBody.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi hii itatumika kwa route/ETA pale mzazi pia atakapothibitisha.'**
  String get coordinatesConfirmSchoolBody;

  /// No description provided for @coordinatesSaved.
  ///
  /// In sw, this message translates to:
  /// **'Nafasi imehifadhiwa. Inasubiri uthibitisho wa upande wa pili.'**
  String get coordinatesSaved;

  /// No description provided for @coordinatesConfirmed.
  ///
  /// In sw, this message translates to:
  /// **'Uthibitisho wako umehifadhiwa.'**
  String get coordinatesConfirmed;

  /// No description provided for @coordinatesErrorLoad.
  ///
  /// In sw, this message translates to:
  /// **'Imeshindikana kupakia nafasi.'**
  String get coordinatesErrorLoad;

  /// No description provided for @coordinatesErrorSave.
  ///
  /// In sw, this message translates to:
  /// **'Imeshindikana kuhifadhi nafasi. Jaribu tena.'**
  String get coordinatesErrorSave;

  /// No description provided for @coordinatesErrorConfirm.
  ///
  /// In sw, this message translates to:
  /// **'Imeshindikana kuthibitisha nafasi. Jaribu tena.'**
  String get coordinatesErrorConfirm;

  /// No description provided for @coordinatesInvalidLatitude.
  ///
  /// In sw, this message translates to:
  /// **'Latitude lazima iwe kati ya -90 na 90.'**
  String get coordinatesInvalidLatitude;

  /// No description provided for @coordinatesInvalidLongitude.
  ///
  /// In sw, this message translates to:
  /// **'Longitude lazima iwe kati ya -180 na 180.'**
  String get coordinatesInvalidLongitude;

  /// No description provided for @coordinatesRequired.
  ///
  /// In sw, this message translates to:
  /// **'Weka latitude na longitude.'**
  String get coordinatesRequired;

  /// No description provided for @coordinatesGpsDenied.
  ///
  /// In sw, this message translates to:
  /// **'Ruhusa ya eneo haijatolewa.'**
  String get coordinatesGpsDenied;

  /// No description provided for @coordinatesGpsDeniedForever.
  ///
  /// In sw, this message translates to:
  /// **'Ruhusa ya eneo imezuiwa. Fungua mipangilio.'**
  String get coordinatesGpsDeniedForever;

  /// No description provided for @coordinatesGpsOff.
  ///
  /// In sw, this message translates to:
  /// **'GPS imezimwa.'**
  String get coordinatesGpsOff;

  /// No description provided for @coordinatesGpsWeak.
  ///
  /// In sw, this message translates to:
  /// **'GPS signal ni hafifu. Jaribu tena.'**
  String get coordinatesGpsWeak;

  /// No description provided for @coordinatesGpsError.
  ///
  /// In sw, this message translates to:
  /// **'Imeshindikana kupata eneo la GPS.'**
  String get coordinatesGpsError;

  /// No description provided for @coordinatesOpenSettings.
  ///
  /// In sw, this message translates to:
  /// **'Fungua mipangilio'**
  String get coordinatesOpenSettings;

  /// No description provided for @coordinatesSchoolNoCoordinate.
  ///
  /// In sw, this message translates to:
  /// **'Shule haijaweka nafasi bado.'**
  String get coordinatesSchoolNoCoordinate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
