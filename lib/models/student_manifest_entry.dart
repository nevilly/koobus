// StudentManifestEntry — mwanafunzi mmoja kwenye manifest ya safari.
//
// Server inarudisha wanafunzi wakiwa wamepangwa tayari kwa kituo cha
// safari (asubuhi: pickup; mchana: drop-off). Client hailipangi upya
// ili mpangilio wa dereva uwe sawa na route halisi.
//
// `attendanceStatus` ni event ya MWISHO ya mtoto kwenye safari hii.
// Hatuweki hali ya mfano: kama hakuna event, ni `none`.

enum TripAttendanceStatus {
  none,
  boarded,
  alighted,
  absent,
  excused,
  unknown;

  static TripAttendanceStatus fromApi(Object? raw) {
    switch (raw?.toString().trim()) {
      case 'board':
        return TripAttendanceStatus.boarded;
      case 'alight':
        return TripAttendanceStatus.alighted;
      case 'absent':
        return TripAttendanceStatus.absent;
      case 'excused':
        return TripAttendanceStatus.excused;
      case null:
        return TripAttendanceStatus.none;
      case '':
        return TripAttendanceStatus.none;
      default:
        return TripAttendanceStatus.unknown;
    }
  }
}

enum TripAttendanceAction {
  board,
  alight,
  absent,
  excused;

  String get apiValue => name;
}

class StudentManifestEntry {
  const StudentManifestEntry({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.routeId,
    this.className = '',
    this.pickupStopId,
    this.pickupStopName = '',
    this.pickupStopOrder,
    this.dropoffStopId,
    this.dropoffStopName = '',
    this.dropoffStopOrder,
    this.attendanceStatus = TripAttendanceStatus.none,
    this.attendanceAt,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String className;
  final int routeId;

  final int? pickupStopId;
  final String pickupStopName;
  final int? pickupStopOrder;

  final int? dropoffStopId;
  final String dropoffStopName;
  final int? dropoffStopOrder;

  final TripAttendanceStatus attendanceStatus;
  final DateTime? attendanceAt;

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? '—' : name;
  }

  String get initials {
    final first = firstName.trim();
    final last = lastName.trim();
    if (first.isEmpty && last.isEmpty) return '?';
    final a = first.isEmpty ? '' : first[0];
    final b = last.isEmpty ? '' : last[0];
    return '$a$b'.toUpperCase();
  }

  /// Kituo kinachotumika kwenye safari hii.
  String stopNameFor(String tripType) {
    if (tripType == 'morning') {
      return pickupStopName.trim();
    }
    return dropoffStopName.trim();
  }

  int? stopOrderFor(String tripType) {
    return tripType == 'morning' ? pickupStopOrder : dropoffStopOrder;
  }

  int? stopIdFor(String tripType) {
    return tripType == 'morning' ? pickupStopId : dropoffStopId;
  }

  bool get isAbsent =>
      attendanceStatus == TripAttendanceStatus.absent ||
      attendanceStatus == TripAttendanceStatus.excused;

  bool get hasAttendance => attendanceStatus != TripAttendanceStatus.none;

  factory StudentManifestEntry.fromJson(Map<String, dynamic> json) {
    return StudentManifestEntry(
      id: _int(json['id']),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      className: json['class_name']?.toString() ?? '',
      routeId: _int(json['route_id']),
      pickupStopId: _intOrNull(json['pickup_stop_id']),
      pickupStopName: json['pickup_stop_name']?.toString() ?? '',
      pickupStopOrder: _intOrNull(json['pickup_stop_order']),
      dropoffStopId: _intOrNull(json['dropoff_stop_id']),
      dropoffStopName: json['dropoff_stop_name']?.toString() ?? '',
      dropoffStopOrder: _intOrNull(json['dropoff_stop_order']),
      attendanceStatus: TripAttendanceStatus.fromApi(json['attendance_status']),
      attendanceAt: _dateTime(json['attendance_at']),
    );
  }

  static int _int(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static int? _intOrNull(Object? value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    return value is num ? value.toInt() : int.tryParse('$value');
  }

  static DateTime? _dateTime(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
  }
}
