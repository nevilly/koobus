// LanguageController — lugha ya sasa ya app (Kiswahili / English).
//
// Ni ChangeNotifier kama AuthController: inashikilia lugha, inaisoma kutoka
// hifadhi app inapoanza, na inaarifu MaterialApp (kupitia Provider) pale
// mtumiaji anapobadilisha. Kwa sababu MaterialApp inasikiliza, app YOTE
// hubadilika lugha papo hapo — hakuna ku-restart.

import 'package:flutter/material.dart';

import 'package:koobus/core/storage/language_service.dart';

/// Lugha zinazotumika. Code hizi lazima zifanane na faili za .arb
/// (l10n/app_sw.arb -> 'sw', l10n/app_en.arb -> 'en').
class AppLanguage {
  const AppLanguage._();

  static const swahili = 'sw';
  static const english = 'en';

  /// Lugha ya msingi ikiwa mtumiaji hajachagua kitu.
  static const defaultCode = swahili;

  static const supported = <String>[swahili, english];

  /// Geuza code kuwa Locale ya Flutter.
  static List<Locale> get locales =>
      supported.map(Locale.new).toList(growable: false);
}

class LanguageController extends ChangeNotifier {
  LanguageController(this._service);

  final LanguageService _service;

  /// Lugha ya sasa. Huanza na lugha ya msingi (Kiswahili) ili app iwe na
  /// kitu cha kuonyesha kabla ya kusoma hifadhi.
  Locale _locale = const Locale(AppLanguage.defaultCode);

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  /// Ikiwa mtumiaji hajachagua bado (app imefunguliwa mara ya kwanza).
  bool get isUsingDefault => languageCode == AppLanguage.defaultCode;

  /// Soma lugha iliyohifadhiwa — huitwa mara moja wakati app inaanza.
  ///
  /// NOTE: Hatutumii notifyListeners() kama thamani haijabadilika, ili
  /// kuepuka "notify during build" (somo lililopatikana kwenye splash).
  Future<void> loadLanguage() async {
    final stored = await _service.readLanguage();
    if (stored == null || !AppLanguage.supported.contains(stored)) return;
    if (stored == _locale.languageCode) return;

    _locale = Locale(stored);
    notifyListeners();
  }

  /// Badilisha lugha na ihifadhi. Hii ndiyo njia pekee ya kubadilisha lugha.
  Future<void> setLanguage(String languageCode) async {
    if (!AppLanguage.supported.contains(languageCode)) return;
    if (languageCode == _locale.languageCode) return;

    _locale = Locale(languageCode);
    notifyListeners();
    await _service.saveLanguage(languageCode);
  }
}
