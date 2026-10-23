// DATA YA MFANO (DEV ONLY) — haitumiwi kwenye production.
//
// Kwa nini ipo? Tunaunda UI kabla ya backend (Phase 6/7). Bila data,
// hatuwezi kuona wala kujaribu layout. Kanuni yetu: data ya mfano
// LAZIMA ionekane wazi kama "MFANO (DEV)" kwenye screen — kamwe
// isionekane kama taarifa halisi ya mtoto.
//
// Phase 5: tutabadilisha haya na models halisi (Child, School, Trip...).
// Phase 6/7: yatakuja kutoka API.
//
// ===========================================================================
// KANUNI YA LUGHA KWENYE DATA YA MFANO (muhimu!)
// ===========================================================================
// Data ya mfano ina aina MBILI za maneno:
//
//  (A) MAJINA/MAHALI — hayatafsiriwi KAMWE: "Amina Juma", "Mbezi Beach",
//      "Bi. Neema", "Shule ya Msingi Mlimani". Hivi ni majina halisi ya
//      watu na sehemu; hata baada ya Phase 7 yatakuja kutoka database
//      kama yalivyo. Kuyatafsiri ingekuwa kosa (mfano "Mbezi Beach" si
//      "Mbezi Beach" kwa Kiingereza).
//
//  (B) LEBU/HALI/VITENDO — hivi LAZIMA vitafsiriwe: "Anasubiri basi",
//      "Alipanda basi", "Leo", "Basi", "Matron". Hivi si majina; ni
//      maneno ambayo mtumiaji anayesoma Kiingereza anahitaji kuyaelewa.
//
// Hivyo: hali (status) na vitendo (action) HAZIHIFADHIWI kama String.
// Tunazihifadhi kama ENUM, na screen inageuza enum -> maneno kwa
// kutumia l10n. Hii inazuia hitilafu kama kutafuta neno la Kiswahili
// ("panda") kwenye String ili kujua ni kupanda au kushuka.
// ---------------------------------------------------------------------------

import 'package:koobus/l10n/app_localizations.dart';

/// Hali ya mtoto kwa sasa (kwenye safari).
enum DemoChildStatus {
  waiting,
  onboard,
  atSchool,
  atHome,
}

extension DemoChildStatusLabel on DemoChildStatus {
  /// Maandishi kwa mtumiaji kwa lugha iliyochaguliwa.
  ///
  /// NOTE: ilikuwa `String get label` (Kiswahili pekee). Sasa ni method
  /// inayopokea kamusi — hivyo hali hiyo hiyo inaonekana kwa Kiswahili
  /// au Kiingereza bila kubadilisha data yenyewe.
  String label(AppLocalizations l10n) => switch (this) {
        DemoChildStatus.waiting => l10n.statusWaitingBus,
        DemoChildStatus.onboard => l10n.statusOnTheWay,
        DemoChildStatus.atSchool => l10n.statusAtSchool,
        DemoChildStatus.atHome => l10n.statusAtHome,
      };
}

/// Kitendo kilichotokea kwenye safari (kupanda/kufika/kushuka).
///
/// KWA NINI ENUM? TripEventTile iliamua alama ya kadi (kupanda vs kushuka)
/// kwa kutafuta neno "panda" ndani ya String ya Kiswahili. Ikiwa lugha
/// inabadilika kuwa Kiingereza, utafutaji huo ungevunjika na kadi zote
/// zingeonekana kama "kushuka". Enum inatoa jibu MOJA kwa lugha zote.
enum DemoTripAction {
  boarded,
  arrivedAtSchool,
  alighted,
}

extension DemoTripActionLabel on DemoTripAction {
  String label(AppLocalizations l10n) => switch (this) {
        DemoTripAction.boarded => l10n.eventBoarded,
        DemoTripAction.arrivedAtSchool => l10n.eventArrivedSchool,
        DemoTripAction.alighted => l10n.eventAlighted,
      };

  /// Alama ya kadi: kupanda = kuingia, vingine = kutoka.
  /// Hii inategemea MAANA ya kitendo, si maneno yake.
  bool get isBoarding => this == DemoTripAction.boarded;
}

/// Siku ya tukio — "Leo" / "Jana".
///
/// Tena: enum, si String. "Leo" ni neno la kutafsiriwa, si tarehe.
enum DemoTripDay {
  today,
  yesterday,
}

extension DemoTripDayLabel on DemoTripDay {
  String label(AppLocalizations l10n) => switch (this) {
        DemoTripDay.today => l10n.dayToday,
        DemoTripDay.yesterday => l10n.dayYesterday,
      };
}

/// Mtoto mmoja — toleo la mfano.
class DemoChild {
  const DemoChild({
    required this.id,
    required this.name,
    required this.school,
    required this.className,
    required this.route,
    required this.matron,
    required this.status,
    required this.events,
  });

  final String id;

  /// Jina la mtoto — JINA HALISI, halitafsiriwi.
  final String name;

  /// Jina la shule — JINA HALISI, halitafsiriwi.
  final String school;

  final String className;

  /// Njia ya basi (mfano: "Njia A — Mbezi Beach").
  final String route;

  /// Matron (mlezi wa basi) anayemsimamia mtoto kwenye safari.
  /// Hii ni muhimu: si dereva pekee anayehusika na usalama wa watoto.
  /// "Bi. Neema" ni JINA HALISI — halitafsiriwi.
  final String matron;

  final DemoChildStatus status;

  /// Historia ya kupanda/kushuka — ya mfano.
  final List<DemoTripEvent> events;
}

/// Tukio moja la safari: kupanda, kufika shule, kushuka...
class DemoTripEvent {
  const DemoTripEvent({
    required this.date,
    required this.time,
    required this.action,
    required this.place,
    required this.matron,
  });

  /// Siku (Leo/Jana) — inatafsiriwa kupitia `date.label(l10n)`.
  final DemoTripDay date;

  /// Saa — "06:45". Namba; haitafsiriwi.
  final String time;

  /// Kitendo — enum; maneno yanatoka kamusi.
  final DemoTripAction action;

  /// Mahali — JINA HALISI la eneo, halitafsiriwi.
  final String place;

  /// Jina la matron — JINA HALISI, halitafsiriwi.
  final String matron;
}

/// Mtu aliyeidhinishwa kumchukua mtoto (parent/guardian wa pili).
class DemoGuardian {
  const DemoGuardian({
    required this.name,
    required this.relation,
    required this.phone,
  });

  /// JINA HALISI — halitafsiriwi.
  final String name;

  /// Uhusiano ("Baba", "Shangazi"). NOTE: kwa sasa ni String ya Kiswahili;
  /// itakuwa enum pindi tuunganishe guardians wa kweli (Phase 5/7).
  /// Kwa data ya mfano tunaiacha hivi ili tusiandike kamusi kwa maneno
  /// ambayo hayajatengenezwa bado.
  final String relation;

  final String phone;
}

/// Taarifa/notification ya mfano.
///
/// NOTE: title/message ni sentensi kamili za mfano. Kwa Phase 10 (FCM)
/// titakuwa na template za server (mfano "child_boarded" + jina + saa),
/// hivyo sentensi hizi zitatolewa na mfumo wa templates, si kamusi ya
/// upande wa kifaa. Kwa sasa tunaonyesha kama zilivyo pamoja na beji ya DEV.
class DemoAlert {
  const DemoAlert({
    required this.title,
    required this.message,
    required this.time,
    required this.read,
  });

  final String title;
  final String message;

  /// Muda wa mfano ("Dakika 25 zilizopita"). Kama relation ya guardian,
  /// hii ni sentensi — itatoka server baadaye.
  final String time;

  final bool read;
}

// ---------------------------------------------------------------------------
// Taarifa za mfano
// ---------------------------------------------------------------------------

const demoChildren = <DemoChild>[
  DemoChild(
    id: 'dev-child-1',
    name: 'Amina Juma',
    school: 'Shule ya Msingi Mlimani',
    className: 'Darasa la 4',
    route: 'Njia A — Mbezi Beach',
    matron: 'Bi. Neema',
    status: DemoChildStatus.onboard,
    events: [
      DemoTripEvent(
        date: DemoTripDay.today,
        time: '06:45',
        action: DemoTripAction.boarded,
        place: 'Mbezi Beach',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: DemoTripDay.today,
        time: '07:20',
        action: DemoTripAction.arrivedAtSchool,
        place: 'Shule ya Msingi Mlimani',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: DemoTripDay.yesterday,
        time: '16:05',
        action: DemoTripAction.boarded,
        place: 'Shule ya Msingi Mlimani',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: DemoTripDay.yesterday,
        time: '16:40',
        action: DemoTripAction.alighted,
        place: 'Mbezi Beach',
        matron: 'Bi. Neema',
      ),
    ],
  ),
  DemoChild(
    id: 'dev-child-2',
    name: 'Baraka Juma',
    school: 'Shule ya Sekondari Mwenge',
    className: 'Kidato cha 1',
    route: 'Njia A — Mbezi Beach',
    matron: 'Bi. Neema',
    status: DemoChildStatus.atSchool,
    events: [
      DemoTripEvent(
        date: DemoTripDay.today,
        time: '06:50',
        action: DemoTripAction.boarded,
        place: 'Mbezi Beach',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: DemoTripDay.today,
        time: '07:25',
        action: DemoTripAction.arrivedAtSchool,
        place: 'Shule ya Sekondari Mwenge',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: DemoTripDay.yesterday,
        time: '16:15',
        action: DemoTripAction.boarded,
        place: 'Shule ya Sekondari Mwenge',
        matron: 'Bi. Neema',
      ),
    ],
  ),
];

const demoGuardians = <DemoGuardian>[
  DemoGuardian(
    name: 'Juma Hamisi',
    relation: 'Baba',
    phone: '0712 000 111',
  ),
  DemoGuardian(
    name: 'Zainabu Ali',
    relation: 'Shangazi',
    phone: '0754 000 222',
  ),
];

const demoAlerts = <DemoAlert>[
  DemoAlert(
    title: 'Amina amepanda basi',
    message: 'Saa 06:45 — Njia A, chini ya Bi. Neema.',
    time: 'Dakika 25 zilizopita',
    read: false,
  ),
  DemoAlert(
    title: 'Baraka amefika shuleni',
    message: 'Saa 07:25 — Shule ya Sekondari Mwenge.',
    time: 'Dakika 10 zilizopita',
    read: false,
  ),
  DemoAlert(
    title: 'Basi liko njiani kuja nyumbani',
    message: 'Dakika 5 hadi kufika Mbezi Beach.',
    time: 'Sasa hivi',
    read: true,
  ),
];
