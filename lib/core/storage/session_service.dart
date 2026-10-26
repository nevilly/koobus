// SessionService — hifadhi ya session ya mtumiaji (umeme wa kuingia).
//
// Tunatumia "abstract class" kwanza: AuthController haifahamu kama session
// inahifadhiwa wapi (keystore halisi au memory ya majaribio). Hii ni
// "Dependency Inversion" — inaturuhusu kubadilisha hifadhi bila kugusa
// business logic, na kurahisisha test (test hutumia InMemorySessionService).

/// Session moja iliyohifadhiwa: token ya kuingia na simu ya mtumiaji.
///
/// NOTE: Baada ya backend (Phase 7), hii itaongezewa field kama
/// `expiresAt` na `refreshToken`. Kwa sasa ni rahisi kwa sababu
/// hakuna API bado.
class StoredSession {
  const StoredSession({
    required this.token,
    required this.phone,
    this.expiresAt,
    this.role,
    this.userId,
    this.schoolId,
    this.displayName,
  });

  /// Token ya kuingia kutoka API (au token ya majaribio ya DEV).
  final String token;

  /// Namba ya simu ya mtumiaji (kwa kuonyesha home screen).
  final String phone;

  /// Muda wa mwisho wa token (kama unaweza kusomwa kutoka token).
  ///
  /// `null` = haijulikani; tunategemea jibu la 401 kutoka API.
  final DateTime? expiresAt;

  /// Role ya mtumiaji (`parent`, `driver`, `matron`, `school_admin`,
  /// `super_admin`). Inahifadhiwa ili app ijue pa kumpeleka mtumiaji
  /// bila kuomba API kila inapofunguliwa.
  final String? role;

  /// `users.id` — dereva anaitumia kuomba safari zake.
  final int? userId;

  /// `users.school_id` — matron/school admin wanaitumia kwa data ya shule.
  final int? schoolId;

  /// Jina la kuonyesha kwenye salamu.
  final String? displayName;

  /// Je, token imeisha muda kwa wakati huu?
  bool get isExpired {
    final expiry = expiresAt;
    if (expiry == null) return false;
    return DateTime.now().toUtc().isAfter(expiry);
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'phone': phone,
        if (expiresAt != null) 'expiresAt': expiresAt!.toUtc().toIso8601String(),
        if (role != null) 'role': role,
        if (userId != null) 'userId': userId,
        if (schoolId != null) 'schoolId': schoolId,
        if (displayName != null) 'displayName': displayName,
      };

  factory StoredSession.fromJson(Map<String, dynamic> json) {
    final rawExpiry = json['expiresAt'] as String?;
    final rawUserId = json['userId'];
    final rawSchoolId = json['schoolId'];
    return StoredSession(
      // as String? to '?? ''': kama field haipo, tusipate crash —
      // session itachukuliwa kama si sahihi na mtu atafanywa aingie tena.
      token: json['token'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      expiresAt: rawExpiry == null ? null : DateTime.tryParse(rawExpiry)?.toUtc(),
      role: json['role'] as String?,
      userId: rawUserId is num ? rawUserId.toInt() : int.tryParse('$rawUserId'),
      schoolId: rawSchoolId is num
          ? rawSchoolId.toInt()
          : int.tryParse('$rawSchoolId'),
      displayName: json['displayName'] as String?,
    );
  }
}

/// Kanuni ya hifadhi: kila hifadhi lazima iwe na njia hizi tatu.
abstract class SessionService {
  /// Soma session iliyohifadhiwa, au `null` kama hakuna.
  Future<StoredSession?> readSession();

  /// Hifadhi (au ibadilishe) session.
  Future<void> saveSession(StoredSession session);

  /// Ondoa session — hii ndiyo "logout" halisi.
  Future<void> clearSession();
}
