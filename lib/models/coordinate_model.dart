// CoordinateModel — nafasi ya mtoto/shule pamoja na uthibitisho wa pande mbili.
//
// Kanuni: `isValid` ni `true` pale mzazi NA shule wote wamekubali.
// Upande mmoja pekee haupaswi kutumika kwa route/ETA.

class CoordinateModel {
  const CoordinateModel({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.latitude,
    required this.longitude,
    required this.parentConfirmed,
    required this.schoolConfirmed,
    this.label,
    this.proposedBy,
    this.proposedRole,
    this.parentConfirmedAt,
    this.schoolConfirmedAt,
    this.updatedAt,
  });

  final int? id;
  final String? entityType;
  final int? entityId;
  final double latitude;
  final double longitude;
  final String? label;
  final int? proposedBy;
  final String? proposedRole;
  final bool parentConfirmed;
  final bool schoolConfirmed;
  final DateTime? parentConfirmedAt;
  final DateTime? schoolConfirmedAt;
  final DateTime? updatedAt;

  bool get isValid => parentConfirmed && schoolConfirmed;

  CoordinateModel copyWith({
    bool? parentConfirmed,
    bool? schoolConfirmed,
    DateTime? parentConfirmedAt,
    DateTime? schoolConfirmedAt,
    DateTime? updatedAt,
  }) {
    return CoordinateModel(
      id: id,
      entityType: entityType,
      entityId: entityId,
      latitude: latitude,
      longitude: longitude,
      label: label,
      proposedBy: proposedBy,
      proposedRole: proposedRole,
      parentConfirmed: parentConfirmed ?? this.parentConfirmed,
      schoolConfirmed: schoolConfirmed ?? this.schoolConfirmed,
      parentConfirmedAt: parentConfirmedAt ?? this.parentConfirmedAt,
      schoolConfirmedAt: schoolConfirmedAt ?? this.schoolConfirmedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CoordinateModel.fromJson(Map<String, dynamic> json) {
    final parentConfirmedAt = _date(json['parent_confirmed_at']);
    final schoolConfirmedAt = _date(json['school_confirmed_at']);

    return CoordinateModel(
      id: _int(json['id']),
      entityType: _string(json['entity_type']),
      entityId: _int(json['entity_id']),
      latitude: _double(json['latitude']) ?? 0,
      longitude: _double(json['longitude']) ?? 0,
      label: _string(json['label']),
      proposedBy: _int(json['proposed_by']),
      proposedRole: _string(json['proposed_role']),
      parentConfirmed:
          _bool(json['parent_confirmed']) || parentConfirmedAt != null,
      schoolConfirmed:
          _bool(json['school_confirmed']) || schoolConfirmedAt != null,
      parentConfirmedAt: parentConfirmedAt,
      schoolConfirmedAt: schoolConfirmedAt,
      updatedAt: _date(json['updated_at']),
    );
  }
}

class ChildCoordinateEntry {
  const ChildCoordinateEntry({
    required this.childId,
    required this.firstName,
    required this.lastName,
    required this.schoolId,
    this.className,
    this.schoolName,
    this.coordinate,
  });

  final int childId;
  final String firstName;
  final String lastName;
  final String? className;
  final int schoolId;
  final String? schoolName;
  final CoordinateModel? coordinate;

  String get fullName => '$firstName $lastName'.trim();

  factory ChildCoordinateEntry.fromJson(Map<String, dynamic> json) {
    final rawCoordinate = json['coordinate'];
    return ChildCoordinateEntry(
      childId: _int(json['child_id']) ?? 0,
      firstName: _string(json['first_name']) ?? '',
      lastName: _string(json['last_name']) ?? '',
      className: _string(json['class_name']),
      schoolId: _int(json['school_id']) ?? 0,
      schoolName: _string(json['school_name']),
      coordinate: rawCoordinate is Map
          ? CoordinateModel.fromJson(Map<String, dynamic>.from(rawCoordinate))
          : null,
    );
  }
}

class SchoolCoordinateEntry {
  const SchoolCoordinateEntry({
    required this.schoolId,
    required this.schoolName,
    this.coordinate,
  });

  final int schoolId;
  final String schoolName;
  final CoordinateModel? coordinate;

  factory SchoolCoordinateEntry.fromJson(Map<String, dynamic> json) {
    final rawCoordinate = json['coordinate'];
    return SchoolCoordinateEntry(
      schoolId: _int(json['school_id']) ?? 0,
      schoolName: _string(json['school_name']) ?? '',
      coordinate: rawCoordinate is Map
          ? CoordinateModel.fromJson(Map<String, dynamic>.from(rawCoordinate))
          : null,
    );
  }
}

class CoordinateOverview {
  const CoordinateOverview({this.children = const [], this.schools = const []});

  final List<ChildCoordinateEntry> children;
  final List<SchoolCoordinateEntry> schools;

  factory CoordinateOverview.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'];
    final rawSchools = json['schools'];

    return CoordinateOverview(
      children: rawChildren is List
          ? rawChildren
                .whereType<Map>()
                .map(
                  (item) => ChildCoordinateEntry.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      schools: rawSchools is List
          ? rawSchools
                .whereType<Map>()
                .map(
                  (item) => SchoolCoordinateEntry.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

int? _int(Object? value) {
  if (value is num) return value.toInt();
  if (value == null) return null;
  return int.tryParse(value.toString());
}

double? _double(Object? value) {
  if (value is num) return value.toDouble();
  if (value == null) return null;
  return double.tryParse(value.toString());
}

String? _string(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

bool _bool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase().trim();
  return text == '1' || text == 'true' || text == 'yes';
}

DateTime? _date(Object? value) {
  final text = _string(value);
  if (text == null) return null;
  return DateTime.tryParse(text);
}
