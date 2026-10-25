// ApiConfig — mipangilio ya msingi ya mawasiliano na API ya KooBus.
//
// Base URL inatoka kwenye `--dart-define=API_BASE_URL=...` ili tusiweke
// anwani za server kwenye code. Hii inaturuhusu kutumia server tofauti
// kwa development, staging na production bila kubadilisha code.

class ApiConfig {
  const ApiConfig._();

  /// Base URL ya API. Mfano:
  /// `flutter run --dart-define=API_BASE_URL=http://192.168.1.10/api/v1`
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost/api/v1',
  );

  /// Kichwa cha Authorization kinachotumika na API (Owest/ Owesis scheme).
  ///
  /// Server inasoma token kwa muundo: `Authorization: Owesis <token>`.
  /// Tena token hiyo ni ile ile iliyotolewa na `/users/login`.
  static const String authScheme = 'Owesis';

  /// Muda wa kusubiri jibu la API kabla ya kukata tamaa.
  static const Duration timeout = Duration(seconds: 20);
}
