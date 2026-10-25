// Tests za token expiry kwenye AuthController:
//  - token iliyokwisha muda haipaswi kumwingiza mtumiaji (restoreSession)
//  - signOut(expired: true) inaweka sessionExpired = true
//  - signIn inasoma exp kutoka token na kuihifadhi

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/storage/secure_session_service.dart';
import 'package:koobus/core/storage/session_service.dart';

String _tokenWithExpiry(DateTime expiry) {
  String part(Map<String, dynamic> data) =>
      base64Url.encode(utf8.encode(jsonEncode(data))).replaceAll('=', '');

  final header = part({'typ': 'JWT', 'alg': 'HS256'});
  final payload = part({
    'exp': expiry.millisecondsSinceEpoch ~/ 1000,
    'username': 'test',
  });
  return '$header.$payload.signature';
}

void main() {
  test('restoreSession inafuta token iliyokwisha muda', () async {
    final store = InMemorySessionService();
    await store.saveSession(
      StoredSession(
        token: _tokenWithExpiry(
          DateTime.now().toUtc().subtract(const Duration(hours: 1)),
        ),
        phone: '0712345678',
      ),
    );

    final auth = AuthController(store);
    await auth.restoreSession();

    expect(auth.status, AuthStatus.loggedOut);
    expect(auth.sessionExpired, isTrue);
    expect(await store.readSession(), isNull);
  });

  test('restoreSession inakubali token halali', () async {
    final store = InMemorySessionService();
    await store.saveSession(
      StoredSession(
        token: _tokenWithExpiry(
          DateTime.now().toUtc().add(const Duration(days: 10)),
        ),
        phone: '0712345678',
      ),
    );

    final auth = AuthController(store);
    await auth.restoreSession();

    expect(auth.status, AuthStatus.loggedIn);
    expect(auth.sessionExpired, isFalse);
  });

  test('signIn inahifadhi muda wa mwisho wa token', () async {
    final store = InMemorySessionService();
    final auth = AuthController(store);
    final expiry = DateTime.now().toUtc().add(const Duration(days: 60));

    await auth.signIn(token: _tokenWithExpiry(expiry), phone: '0712345678');

    expect(auth.status, AuthStatus.loggedIn);
    expect(auth.session?.expiresAt, isNotNull);
    final stored = await store.readSession();
    expect(stored?.expiresAt, isNotNull);
  });

  test('signOut(expired: true) inaweka sessionExpired', () async {
    final store = InMemorySessionService();
    final auth = AuthController(store);
    await auth.signIn(token: 'DEV-TOKEN', phone: '0712345678');

    await auth.signOut(expired: true);

    expect(auth.status, AuthStatus.loggedOut);
    expect(auth.sessionExpired, isTrue);
  });

  test('signOut() ya kawaida haiweki sessionExpired', () async {
    final store = InMemorySessionService();
    final auth = AuthController(store);
    await auth.signIn(token: 'DEV-TOKEN', phone: '0712345678');

    await auth.signOut();

    expect(auth.status, AuthStatus.loggedOut);
    expect(auth.sessionExpired, isFalse);
  });
}
