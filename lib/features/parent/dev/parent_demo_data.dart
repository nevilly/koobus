// DATA YA MFANO (DEV ONLY) — haitumiwi kwenye production.
//
// Kwa nini ipo? Tunaunda UI kabla ya backend (Phase 6/7). Bila data,
// hatuwezi kuona wala kujaribu layout. Kanuni yetu: data ya mfano
// LAZIMA ionekane wazi kama "MFANO (DEV)" kwenye screen — kamwe
// isionekane kama taarifa halisi ya mtoto.
//
// Phase 5: tutabadilisha haya na models halisi (Child, School, Trip...).
// Phase 6/7: yatakuja kutoka API.

/// Hali ya mtoto kwa sasa (kwenye safari).
enum DemoChildStatus {
  waiting,
  onboard,
  atSchool,
  atHome,
}

extension DemoChildStatusLabel on DemoChildStatus {
  /// Maandishi kwa mtumiaji — Kiswahili rahisi.
  String get label => switch (this) {
        DemoChildStatus.waiting => 'Anasubiri basi',
        DemoChildStatus.onboard => 'Yupo njiani',
        DemoChildStatus.atSchool => 'Yuko shuleni',
        DemoChildStatus.atHome => 'Yuko nyumbani',
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
  final String name;
  final String school;
  final String className;

  /// Njia ya basi (mfano: "Njia A — Mbezi Beach").
  final String route;

  /// Matron (mlezi wa basi) anayemsimamia mtoto kwenye safari.
  /// Hii ni muhimu: si dereva pekee anayehusika na usalama wa watoto.
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

  final String date; // "Leo", "Jana"
  final String time; // "06:45"
  final String action; // "Alipanda basi"
  final String place;
  final String matron;
}

/// Mtu aliyeidhinishwa kumchukua mtoto (parent/guardian wa pili).
class DemoGuardian {
  const DemoGuardian({
    required this.name,
    required this.relation,
    required this.phone,
  });

  final String name;
  final String relation;
  final String phone;
}

/// Taarifa/notification ya mfano.
class DemoAlert {
  const DemoAlert({
    required this.title,
    required this.message,
    required this.time,
    required this.read,
  });

  final String title;
  final String message;
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
        date: 'Leo',
        time: '06:45',
        action: 'Alipanda basi',
        place: 'Mbezi Beach',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: 'Leo',
        time: '07:20',
        action: 'Alifika shule',
        place: 'Shule ya Msingi Mlimani',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: 'Jana',
        time: '16:05',
        action: 'Alipanda basi',
        place: 'Shule ya Msingi Mlimani',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: 'Jana',
        time: '16:40',
        action: 'Alishuka',
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
        date: 'Leo',
        time: '06:50',
        action: 'Alipanda basi',
        place: 'Mbezi Beach',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: 'Leo',
        time: '07:25',
        action: 'Alifika shule',
        place: 'Shule ya Sekondari Mwenge',
        matron: 'Bi. Neema',
      ),
      DemoTripEvent(
        date: 'Jana',
        time: '16:15',
        action: 'Alipanda basi',
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
