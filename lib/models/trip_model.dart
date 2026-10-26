// TripModel — safari ya basi kama inavyorudishwa na API.
//
// Hali (status) ina maana kali kwa dereva:
//   pending   -> safari imepangwa, bado haijaanza
//   active    -> safari inaendelea (dereva ameianzisha)
//   completed -> safari imemalizika
//   cancelled -> safari imeghairiwa
//
// UI haipaswi kutunga hali yake yenyewe; server ndiyo chanzo cha ukweli.

enum TripStatus { pending, active, completed, cancelled, unknown }

class TripModel {
  const TripModel({
    required this.id,
    required this.routeId,
    required this.busId,
    required this.driverId,
    required this.tripType,
    required this.status,
    this.matronId,
    this.scheduledAt,
    this.startedAt,
    this.endedAt,
    this.createdAt,
    this.startedEarly = false,
    this.earlyStartReason,
  });

  final int id;
  final int routeId;
  final int busId;
  final int driverId;
  final int? matronId;

  /// `morning` au `afternoon`.
  final String tripType;
  final TripStatus status;

  /// Muda safari ilipangwa. `null` = safari ya kizamani (DB ya awali).
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime? createdAt;

  /// Ilianza kabla ya dirisha la kawaida (dharura)?
  final bool startedEarly;
  final String? earlyStartReason;

  bool get isPending => status == TripStatus.pending;
  bool get isActive => status == TripStatus.active;
  bool get isCompleted => status == TripStatus.completed;
  bool get isCancelled => status == TripStatus.cancelled;

  bool get hasScheduledTime => scheduledAt != null;

  /// Muda unaotumika kwa kupanga. Safari za zamani zinatumia created_at.
  DateTime? get effectiveScheduledAt => scheduledAt ?? createdAt;

  /// Dirisha la kawaida hufunguka saa moja kabla ya muda uliopangwa.
  DateTime? get startWindowAt {
    final scheduled = scheduledAt;
    return scheduled?.subtract(const Duration(hours: 1));
  }

  /// Safari imepangwa leo? (Hutumia ratiba, si muda wa kuundwa.)
  bool get isToday => isTodayAt(DateTime.now());

  bool isTodayAt(DateTime now) {
    final scheduled = effectiveScheduledAt;
    return scheduled != null && _sameDay(scheduled, now);
  }

  bool startWindowOpenAt(DateTime now) {
    final window = startWindowAt;
    if (window == null) return true;
    return !now.isBefore(window);
  }

  bool startWindowOpen() => startWindowOpenAt(DateTime.now());

  bool scheduledTimeReachedAt(DateTime now) {
    final scheduled = scheduledAt;
    if (scheduled == null) return false;
    return !now.isBefore(scheduled);
  }

  bool get scheduledTimeReached => scheduledTimeReachedAt(DateTime.now());

  /// Kuanza kwa dharura kunaruhusiwa tu kabla ya dirisha, siku ya safari.
  bool canEmergencyStartAt(DateTime now) {
    final scheduled = scheduledAt;
    final window = startWindowAt;
    if (scheduled == null || window == null) return false;
    return now.isBefore(window) && _sameDay(scheduled, now);
  }

  bool get canEmergencyStart => canEmergencyStartAt(DateTime.now());

  Duration? timeUntilStartWindow(DateTime now) {
    final window = startWindowAt;
    if (window == null || !now.isBefore(window)) return null;
    return window.difference(now);
  }

  Duration? get untilStartWindow => timeUntilStartWindow(DateTime.now());

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static TripStatus parseStatus(Object? raw) {
    switch (raw?.toString().trim()) {
      case 'pending':
        return TripStatus.pending;
      case 'active':
        return TripStatus.active;
      case 'completed':
        return TripStatus.completed;
      case 'cancelled':
        return TripStatus.cancelled;
      default:
        return TripStatus.unknown;
    }
  }

  /// Nakala yenye sehemu zilizobadilishwa (test na UI ya haraka).
  TripModel copyWith({
    TripStatus? status,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? endedAt,
    bool? startedEarly,
    String? earlyStartReason,
  }) {
    return TripModel(
      id: id,
      routeId: routeId,
      busId: busId,
      driverId: driverId,
      matronId: matronId,
      tripType: tripType,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      createdAt: createdAt,
      startedEarly: startedEarly ?? this.startedEarly,
      earlyStartReason: earlyStartReason ?? this.earlyStartReason,
    );
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: _int(json['id']),
      routeId: _int(json['route_id']),
      busId: _int(json['bus_id']),
      driverId: _int(json['driver_id']),
      matronId: _intOrNull(json['matron_id']),
      tripType: json['trip_type']?.toString() ?? '',
      status: parseStatus(json['status']),
      scheduledAt: _dateTime(json['scheduled_at']),
      startedAt: _dateTime(json['started_at']),
      endedAt: _dateTime(json['ended_at']),
      createdAt: _dateTime(json['created_at']),
      startedEarly: _bool(json['started_early']),
      earlyStartReason: _stringOrNull(json['early_start_reason']),
    );
  }

  static bool _bool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().trim().toLowerCase();
    return text == '1' || text == 'true' || text == 'yes';
  }

  static String? _stringOrNull(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
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
