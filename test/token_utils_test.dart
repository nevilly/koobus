// Tests za TokenUtils: kusoma `exp` kutoka JWT na kuamua kama imeisha.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/core/utils/token_utils.dart';

String _tokenWithExpiry(DateTime expiry) {
  String part(Map<String, dynamic> data) =>
      base64Url.encode(utf8.encode(jsonEncode(data))).replaceAll('=', '');

  final header = part({'typ': 'JWT', 'alg': 'HS256'});
  final payload = part({
    'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    'exp': expiry.millisecondsSinceEpoch ~/ 1000,
    'username': 'test',
  });
  return '$header.$payload.signature';
}

void main() {
  group('TokenUtils', () {
    test('inarudisha null kwa token isiyo JWT', () {
      expect(TokenUtils.expiryOf('DEV-TOKEN-DO-NOT-USE'), isNull);
      expect(TokenUtils.isExpired(null), isFalse);
    });

    test('inasoma exp ya token halali', () {
      final expiry = DateTime.now().toUtc().add(const Duration(days: 30));
      final token = _tokenWithExpiry(expiry);

      final parsed = TokenUtils.expiryOf(token);
      expect(parsed, isNotNull);
      expect(parsed!.difference(expiry).inSeconds.abs(), lessThanOrEqualTo(1));
      expect(TokenUtils.isExpired(token), isFalse);
    });

    test('inatambua token iliyokwisha muda', () {
      final expiry = DateTime.now().toUtc().subtract(const Duration(minutes: 5));
      final token = _tokenWithExpiry(expiry);

      expect(TokenUtils.isExpired(token), isTrue);
    });
  });
}
