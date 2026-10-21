// Hifadhi halisi kwa simu: FlutterSecureStorage.
//
// Kwa nini si shared_preferences? Session token ni siri:
// - shared_preferences huhifadhi kwa maandishi wazi (XML) — mtu mwenye
//   simu na ufikiaji wa faili anaweza kusoma.
// - FlutterSecureStorage inatumia Android Keystore: data imesimbwa na
//   hardware ya simu, hivyo hata kama mtu anafungua faili, hanaufahamu.

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:koobus/core/storage/session_service.dart';

/// Hifadhi ya kweli ya simu (Keystore/Keychain).
class SecureSessionService implements SessionService {
  SecureSessionService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  // Somo kimoja pekee — uhakika wa usalama: nenda ukaone sana.
  static const _key = 'koobus_session';

  @override
  Future<StoredSession?> readSession() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null || raw.isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      final session = StoredSession.fromJson(decoded);
      // Session tupu haifai — itachukuliwa kama hakuna.
      if (session.token.isEmpty) return null;
      return session;
    } catch (_) {
      // Kama hifadhi haifanyi kazi (mfano keystore imefungwa),
      // tusipate crash — mtu atafanywa aingie tena.
      return null;
    }
  }

  @override
  Future<void> saveSession(StoredSession session) async {
    // object ya Dart -> JSON string ya kuhifadhi
    await _storage.write(key: _key, value: jsonEncode(session.toJson()));
  }

  @override
  Future<void> clearSession() async {
    await _storage.delete(key: _key);
  }
}

/// Hifadhi ya majaribio: inahifadhi kwenye memory ya process.
///
/// MATUMIZI: test za automated pekee. Hii SI hifadhi ya kweli —
/// data inapotea app inapofungwa, na haifanyi kazi kwenye simu halisi.
class InMemorySessionService implements SessionService {
  StoredSession? _session;

  @override
  Future<StoredSession?> readSession() async => _session;

  @override
  Future<void> saveSession(StoredSession session) async {
    _session = session;
  }

  @override
  Future<void> clearSession() async {
    _session = null;
  }
}
