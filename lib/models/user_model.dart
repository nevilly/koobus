// UserModel — mtumiaji kama anavyorudishwa na API.
//
// Role ndiyo inayoamua mtumiaji anaenda ukurasa gani baada ya kuingia:
//   parent      -> ParentShell
//   driver      -> DriverHomeScreen
//   matron/admin-> ukurasa wa "bado haujatengenezwa" (kwa uwazi)
//
// Server inarudisha `role` kama string; tunaiweka kwenye enum ili
// typo isisababisha tabia isiyojulikana.

enum UserRole {
  parent,
  driver,
  matron,
  schoolAdmin,
  superAdmin,
  unknown,
}

class UserModel {
  const UserModel({
    required this.id,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.username,
    this.schoolId,
  });

  final int id;
  final UserRole role;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? username;
  final int? schoolId;

  bool get isParent => role == UserRole.parent;
  bool get isDriver => role == UserRole.driver;
  bool get isMatron => role == UserRole.matron;
  bool get isSchoolAdmin => role == UserRole.schoolAdmin;
  bool get isSuperAdmin => role == UserRole.superAdmin;

  /// Jina la kuonyesha. Hutumia jina kamili, kisha username, kisha simu.
  String get displayName {
    final parts = [firstName, lastName]
        .where((part) => part != null && part.trim().isNotEmpty)
        .cast<String>();
    final full = parts.join(' ').trim();
    if (full.isNotEmpty) return full;
    if (username != null && username!.trim().isNotEmpty) return username!.trim();
    if (phone != null && phone!.trim().isNotEmpty) return phone!.trim();
    return '';
  }

  /// Thamani ya role kama inavyotumwa/kuhifadhiwa kwenye API.
  String get roleValue {
    switch (role) {
      case UserRole.parent:
        return 'parent';
      case UserRole.driver:
        return 'driver';
      case UserRole.matron:
        return 'matron';
      case UserRole.schoolAdmin:
        return 'school_admin';
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.unknown:
        return 'unknown';
    }
  }

  /// Badilisha string ya API kuwa enum. Thamani isiyojulikana = unknown.
  static UserRole parseRole(Object? raw) {
    switch (raw?.toString().trim()) {
      case 'parent':
        return UserRole.parent;
      case 'driver':
        return UserRole.driver;
      case 'matron':
        return UserRole.matron;
      case 'school_admin':
        return UserRole.schoolAdmin;
      case 'super_admin':
        return UserRole.superAdmin;
      default:
        return UserRole.unknown;
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawSchool = json['school_id'];

    return UserModel(
      id: rawId is num ? rawId.toInt() : int.tryParse('$rawId') ?? 0,
      role: parseRole(json['role'] ?? json['privilege']),
      firstName: _stringOrNull(json['first_name']),
      lastName: _stringOrNull(json['last_name']),
      phone: _stringOrNull(json['phone']),
      email: _stringOrNull(json['email']),
      username: _stringOrNull(json['username']),
      schoolId: rawSchool is num
          ? rawSchool.toInt()
          : int.tryParse('$rawSchool'),
    );
  }

  static String? _stringOrNull(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
