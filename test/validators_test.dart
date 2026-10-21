// Test za validators — kanuni za kuangalia namba ya simu na nenosiri.
// Hizi ni "unit tests": hazijengi UI, zinaangalia function pekee.

import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/core/utils/validators.dart';

void main() {
  group('Validators.phone', () {
    test('inakataa namba tupu', () {
      expect(Validators.phone(null), isNotNull);
      expect(Validators.phone(''), isNotNull);
      expect(Validators.phone('   '), isNotNull);
    });

    test('inakataa namba isiyo ya Tanzania', () {
      expect(Validators.phone('12345'), isNotNull); // fupi mno
      expect(Validators.phone('0812345678'), isNotNull); // 8 ya kwanza si 6/7
      expect(Validators.phone('abc'), isNotNull);
    });

    test('inakubali namba sahihi', () {
      expect(Validators.phone('0712345678'), isNull);
      expect(Validators.phone('0612345678'), isNull);
      expect(Validators.phone('+255712345678'), isNull);
    });
  });

  group('Validators.password', () {
    test('inakataa nenosiri tupu au fupi', () {
      expect(Validators.password(null), isNotNull);
      expect(Validators.password(''), isNotNull);
      expect(Validators.password('12345'), isNotNull); // tarakimu 5
    });

    test('inakubali nenosiri la tarakimu 6+', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('siri-ya-KooBus'), isNull);
    });
  });
}
