// RouteModel — njia ya basi (routes table).
//
// Route ina vituo (`route_stops`) na ni ya shule moja. Dereva
// anapata route kupitia safari aliyopangiwa, si kwa kuchagua mwenyewe.

class RouteModel {
  const RouteModel({
    required this.id,
    required this.schoolId,
    required this.name,
    this.description,
    this.status,
  });

  final int id;
  final int schoolId;
  final String name;
  final String? description;
  final String? status;

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: _int(json['id']),
      schoolId: _int(json['school_id']),
      name: json['name']?.toString() ?? '',
      description: _stringOrNull(json['description']),
      status: _stringOrNull(json['status']),
    );
  }

  static int _int(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static String? _stringOrNull(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
