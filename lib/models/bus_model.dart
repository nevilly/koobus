// BusModel — basi la shule (buses table).

class BusModel {
  const BusModel({
    required this.id,
    required this.plateNumber,
    this.capacity = 0,
    this.schoolId,
    this.status,
  });

  final int id;
  final String plateNumber;
  final int capacity;
  final int? schoolId;
  final String? status;

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: _int(json['id']),
      plateNumber: json['plate_number']?.toString() ?? '',
      capacity: _int(json['capacity']),
      schoolId: _intOrNull(json['school_id']),
      status: _stringOrNull(json['status']),
    );
  }

  static int _int(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static int? _intOrNull(Object? value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    return value is num ? value.toInt() : int.tryParse('$value');
  }

  static String? _stringOrNull(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
