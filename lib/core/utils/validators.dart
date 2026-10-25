// Validators — kanuni za kuangalia data ya mtumiaji kabla ya kutuma.
// Hizi ni "business rules" ndogo: zinatumika na login na screens zote
// zinazohitaji kuangalia format ya data.
//
// KWA NINI TUNAPOKEA `AppLocalizations`?
// Ujumbe wa hitilafu unaonekana kwa mtumiaji, hivyo lazima uwe kwa lugha
// aliyochagua. Kanuni yenyewe ni ile ile kila lugha (mstari mmoja hapa),
// lakini MANENO yanatoka kwenye kamusi. Hii ina maana:
//  - Kanuni ipo mahali MOJA (hapa) — rahisi kuijaribu.
//  - Tafsiri zote zipo kwenye l10n/*.arb — rahisi kwa mtafsiri.
// Kama tungeweka ujumbe kwenye .arb tu bila function hii, tungelazimika
// kurudia check ya RegExp kwenye kila screen.

import 'package:koobus/l10n/app_localizations.dart';

class Validators {
  const Validators._(); // class hii haijengwi (static pekee)

  // Simu ya Tanzania: inaanza na +255, 255 au 0, ikifuatiwa na 6 au 7
  // (mtandao wa simu), jumla ya tarakimu 9 baada ya prefix.
  // Mfano halisi: +255712345678, 255712345678 au 0712345678.
  //
  // DB yetu inaweza kuhifadhi namba kwa format ya kimataifa (255...)
  // bila alama ya plus, hivyo login lazima ikubali format zote tatu.
  static final RegExp _phonePattern = RegExp(r'^(?:\+?255|0)[67]\d{8}$');

  /// Inarudisha function ya validator inayotumia lugha iliyochaguliwa.
  ///
  /// Matumizi: `validator: Validators.phone(l10n)`.
  /// Hii ni "factory": inatengeneza function inayokumbuka `l10n`.
  static String? Function(String?) phone(AppLocalizations l10n) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.validationPhoneRequired;
      }
      // Ondoa nafasi za mbele/nyuma kabla ya kuangalia
      final normalized = value.trim();
      if (!_phonePattern.hasMatch(normalized)) {
        return l10n.validationPhoneInvalid;
      }
      return null; // null = hakuna hitilafu (imepita)
    };
  }

  static String? Function(String?) password(AppLocalizations l10n) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return l10n.validationPasswordRequired;
      }
      if (value.length < 6) {
        return l10n.validationPasswordTooShort;
      }
      return null;
    };
  }

  /// Namba ya simu ni sahihi? (kwa code isiyo na UI, mfano API layer)
  static bool isPhoneValid(String value) =>
      _phonePattern.hasMatch(value.trim());
}
