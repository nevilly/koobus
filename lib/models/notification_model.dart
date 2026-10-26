// NotificationModel — taarifa ya mtumiaji kutoka API.
//
// Server huhifadhi `data` kama JSON yenye maelezo ya safari (route, muda,
// n.k.). UI hutumia `type` + `data` kutafsiri maandishi kwa lugha ya sasa;
// `title`/`body` ni fallback kwa aina zisizojulikana.

import 'dart:convert';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.type,
    this.data = const {},
    this.readAt,
    this.createdAt,
  });

  final int id;
  final int userId;
  final String title;
  final String body;
  final String? type;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final DateTime? createdAt;

  bool get isUnread => readAt == null;
  bool get isTripStarted =>
      type == 'trip_started' || type == 'trip_started_early';
  bool get isEarlyStart => type == 'trip_started_early';

  String? get routeName => _string(data['route_name']);
  String? get tripType => _string(data['trip_type']);
  int? get tripId => _int(data['trip_id']);
  bool get early => data['early'] == true || data['early'] == 1;

  NotificationModel copyWith({DateTime? readAt}) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      data: data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _int(json['id']) ?? 0,
      userId: _int(json['user_id']) ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      type: _string(json['type']),
      data: _map(json['data']),
      readAt: _dateTime(json['read_at']),
      createdAt: _dateTime(json['created_at']),
    );
  }

  static int? _int(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String? _string(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? _dateTime(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
  }

  static Map<String, dynamic> _map(Object? value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        // Data ya zamani au isiyo JSON — tunarudi kwenye fallback title/body.
      }
    }
    return const {};
  }
}
