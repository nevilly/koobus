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
  const StoredSession({required this.token, required this.phone});

  /// Token ya kuingia. Kwa sasa ni thamani ya majaribio (DEV ONLY) —
  /// baada ya Phase 7 kutoka kwenye API halisi.
  final String token;

  /// Namba ya simu ya mtumiaji (kwa kuonyesha home screen).
  final String phone;

  Map<String, dynamic> toJson() => {'token': token, 'phone': phone};

  factory StoredSession.fromJson(Map<String, dynamic> json) {
    return StoredSession(
      // as String? to '?? ''': kama field haipo, tusipate crash —
      // session itachukuliwa kama si sahihi na mtu atafanywa aingie tena.
      token: json['token'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
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
