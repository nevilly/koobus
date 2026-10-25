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
    this.startedAt,
    this.endedAt,
    this.createdAt,
  });

  final int id;
  final int routeId;
  final int busId;
  final int driverId;
  final int? matronId;

  /// `morning` au `afternoon`.
  final String tripType;
  final TripStatus status;

  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime? createdAt;

  bool get isPending => status == TripStatus.pending;
  bool get isActive => status == TripStatus.active;
  bool get isCompleted => status == TripStatus.completed;
  bool get isCancelled => status == TripStatus.cancelled;

  /// Safari imepangwa leo? (Server haina `trip_date`; tunatumia created_at.)
  bool get isToday {
    final created = createdAt;
    if (created == null) return false;
    final now = DateTime.now();
    return created.year == now.year &&
        created.month == now.month &&
        created.day == now.day;
  }

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
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return TripModel(
      id: id,
      routeId: routeId,
      busId: busId,
      driverId: driverId,
      matronId: matronId,
      tripType: tripType,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      createdAt: createdAt,
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
      startedAt: _dateTime(json['started_at']),
      endedAt: _dateTime(json['ended_at']),
      createdAt: _dateTime(json['created_at']),
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
