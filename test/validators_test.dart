// Test za validators — kanuni za kuangalia namba ya simu na nenosiri.
// Hizi ni "unit tests": hazijengi UI, zinaangalia function pekee.
//
// NOTE: validators sasa zinapokea AppLocalizations (maneno ya lugha).
// Kwa sababu tunaangalia KANUNI (si maneno), tunatumia kamusi ya kweli
// ya Kiswahili — hii pia inathibitisha keys za l10n zipo.

import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/core/utils/validators.dart';
import 'package:koobus/l10n/app_localizations_sw.dart';

void main() {
  // Kamusi halisi ya Kiswahili (ile ile inayotumika kwenye app).
  final l10n = AppLocalizationsSw();

  group('Validators.phone', () {
    test('inakataa namba tupu', () {
      expect(Validators.phone(l10n)(null), isNotNull);
      expect(Validators.phone(l10n)(''), isNotNull);
      expect(Validators.phone(l10n)('   '), isNotNull);
    });

    test('inakataa namba isiyo ya Tanzania', () {
      expect(Validators.phone(l10n)('12345'), isNotNull); // fupi mno
      expect(Validators.phone(l10n)('0812345678'), isNotNull); // ya kwanza si 6/7
      expect(Validators.phone(l10n)('abc'), isNotNull);
    });

    test('inakubali namba sahihi', () {
      expect(Validators.phone(l10n)('0712345678'), isNull);
      expect(Validators.phone(l10n)('0612345678'), isNull);
      expect(Validators.phone(l10n)('+255712345678'), isNull);
      // DB yetu inahifadhi namba za kimataifa bila plus.
      expect(Validators.phone(l10n)('255712345678'), isNull);
    });

    test('ujumbe wa hitilafu unatoka kwenye kamusi', () {
      expect(
        Validators.phone(l10n)(null),
        l10n.validationPhoneRequired,
      );
      expect(
        Validators.phone(l10n)('12345'),
        l10n.validationPhoneInvalid,
      );
    });
  });

  group('Validators.password', () {
    test('inakataa nenosiri tupu au fupi', () {
      expect(Validators.password(l10n)(null), isNotNull);
      expect(Validators.password(l10n)(''), isNotNull);
      expect(Validators.password(l10n)('12345'), isNotNull); // tarakimu 5
    });

    test('inakubali nenosiri la tarakimu 6+', () {
      expect(Validators.password(l10n)('123456'), isNull);
      expect(Validators.password(l10n)('siri-ya-KooBus'), isNull);
    });
  });

  group('Validators.isPhoneValid', () {
    test('inafanya kazi bila UI (kwa API layer)', () {
      expect(Validators.isPhoneValid('0712345678'), isTrue);
      expect(Validators.isPhoneValid(' 0712345678 '), isTrue);
      expect(Validators.isPhoneValid('123'), isFalse);
    });
  });
}
