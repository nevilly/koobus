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
  /// **'Ingia ili kuona safari za watoto wako'**
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
  /// **'Hali ya MAJARIBIO (DEV): server halisi bado haijajengwa. Kuingia huku kunahifadhi session ya majaribio pekee.'**
  String get loginDevNotice;

  /// Hitilafu ikiwa field ya simu ipo wazi.
  ///
  /// In sw, this message translates to:
  /// **'Tafadhali weka namba ya simu'**
  String get validationPhoneRequired;

  /// Hitilafu ikiwa namba ya simu si sahihi.
  ///
  /// In sw, this message translates to:
  /// **'Namba si sahihi. Mfano: 0712345678'**
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
