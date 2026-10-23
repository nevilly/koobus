// LanguageService — hifadhi ya lugha iliyochaguliwa na mtumiaji.
//
// Muundo ni sawa na SessionService: abstract class kwanza, hifadhi halisi
// (secure storage) na hifadhi ya majaribio (memory). Hii inaruhusu
// LanguageController kujaribiwa bila kupiga simu ya Android Keystore.
//
// KWA NINI TUMIA SECURE STORAGE BADALA YA SHARED_PREFERENCES?
// Lugha si siri, kwa hiyo shared_preferences ingetosha kifundo. Lakini
// tumia ule ule mfumo uliopo ili:
//  (1) tuwe na njia MOJA ya hifadhi kwenye project (rahisi kuelewa),
//  (2) tusongeze package nyingine bila sababu,
//  (3) tuweze kuandika test kwa InMemory kama session.
// Kama baadaye ukubwa unakuwa tatizo, hii inaweza kubadilishwa kwa
// kubadilisha class moja pekee (hakuna screen itakayoguswa).

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Kanuni ya hifadhi ya lugha: code ya lugha kama "sw" au "en".
abstract class LanguageService {
  /// Soma lugha iliyohifadhiwa, au `null` kama mtumiaji hajachagua.
  Future<String?> readLanguage();

  /// Hifadhi lugha iliyochaguliwa (mfano "sw").
  Future<void> saveLanguage(String languageCode);
}

/// Hifadhi halisi ya simu (Android Keystore / iOS Keychain).
class SecureLanguageService implements LanguageService {
  SecureLanguageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'koobus_language';

  @override
  Future<String?> readLanguage() async {
    try {
      final value = await _storage.read(key: _key);
      if (value == null || value.isEmpty) return null;
      return value;
    } catch (_) {
      // Kifaa hiki hakina keystore inayofanya kazi? Sio jambo la kuangusha
      // app — tutatumia lugha ya msingi (Kiswahili).
      return null;
    }
  }
  @override
  Future<void> saveLanguage(String languageCode) async {
    await _storage.write(key: _key, value: languageCode);
  }
}

/// Hifadhi ya majaribio: memory pekee.
///
/// MATUMIZI: test za automated. Data haidumu app ikifungwa.
class InMemoryLanguageService implements LanguageService {
  InMemoryLanguageService({String? initial})
      : _language = initial;

  String? _language;

  @override
  Future<String?> readLanguage() async => _language;

  @override
  Future<void> saveLanguage(String languageCode) async {
    _language = languageCode;
  }
}
