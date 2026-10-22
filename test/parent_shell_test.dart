// Tests za ParentShell: bottom navigation, tabs na logout.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';

import 'package:koobus/app/app_theme.dart';
import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/storage/secure_session_service.dart';
import 'package:koobus/core/storage/session_service.dart';
import 'package:koobus/features/parent/screens/parent_shell.dart';
import 'package:koobus/features/parent/screens/tabs/home_tab.dart';
import 'package:koobus/features/parent/screens/tabs/profile_tab.dart';

/// Tengeneza AuthController iliyoingia tayari (kwa test).
Future<AuthController> _loggedInAuth() async {
  final store = InMemorySessionService();
  await store.saveSession(
    const StoredSession(token: 'DEV-TEST-TOKEN', phone: '0712345678'),
  );
  final auth = AuthController(store);
  await auth.restoreSession();
  return auth;
}

Widget _wrap(AuthController auth) {
  return ChangeNotifierProvider<AuthController>.value(
    value: auth,
    child: MaterialApp(
      theme: AppTheme.light,
      home: const ParentShell(),
    ),
  );
}

/// Bonyeza tab kwenye NavigationBar pekee (si maandishi mengine ya screen).
Future<void> _tapTab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(label),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Nyumbani: inaonyesha salamu, ETA na taarifa ya basi',
      (tester) async {
    final auth = await _loggedInAuth();
    await tester.pumpWidget(_wrap(auth));

    expect(find.text('Karibu, 0712345678'), findsOneWidget);
    expect(find.text('Dakika 5'), findsOneWidget);
    expect(find.text('Basi T 123 ABC'), findsOneWidget);

    // Data ya mfano LAZIMA ionekane wazi (iko juu, kabla ya kusogeza).
    expect(find.text('MFANO (DEV)'), findsWidgets);

    // Kadi ya uwezo iko chini — scroll kwanza.
    await tester.scrollUntilVisible(
      find.text('Wanafunzi kwenye basi'),
      250,
      scrollable: find.descendant(
        of: find.byType(ParentHomeTab),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Wanafunzi kwenye basi'), findsOneWidget);
  });

  testWidgets('Watoto: orodha + historia ya mtoto', (tester) async {
    final auth = await _loggedInAuth();
    await tester.pumpWidget(_wrap(auth));

    await _tapTab(tester, 'Watoto');

    expect(find.text('Watoto wako'), findsOneWidget);
    expect(find.text('Amina Juma'), findsWidgets);
    expect(find.text('Baraka Juma'), findsWidgets);

    // Fungua historia ya mtoto wa kwanza
    await tester.tap(find.text('Historia yake').first);
    await tester.pumpAndSettle();

    expect(find.text('Historia ya Amina Juma'), findsOneWidget);
    expect(find.text('Shughuli za hivi karibuni'), findsOneWidget);
    expect(find.textContaining('Alipanda basi'), findsWidgets);

    // Rudi kwenye shell
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Watoto wako'), findsOneWidget);
  });

  testWidgets('Historia na Taarifa zinaonyesha data ya mfano',
      (tester) async {
    final auth = await _loggedInAuth();
    await tester.pumpWidget(_wrap(auth));

    await _tapTab(tester, 'Historia');
    expect(find.text('Historia ya safari'), findsOneWidget);

    await _tapTab(tester, 'Taarifa');
    expect(find.text('Amina amepanda basi'), findsOneWidget);
    expect(find.textContaining('Push notifications halisi'), findsOneWidget);
  });

  testWidgets('Wasifu: taarifa, walioidhinishwa na logout', (tester) async {
    final auth = await _loggedInAuth();
    await tester.pumpWidget(_wrap(auth));

    await _tapTab(tester, 'Wasifu');

    expect(find.text('Taarifa za mzazi'), findsOneWidget);
    expect(find.text('Waliounganishwa kuchukua watoto'), findsOneWidget);

    // Sehemu za chini zinaonekana baada ya kusogeza.
    await tester.scrollUntilVisible(
      find.text('Watoto na shule'),
      250,
      scrollable: find.descendant(
        of: find.byType(ProfileTab),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Watoto na shule'), findsOneWidget);

    // Logout iko chini ya orodha — scroll hadi ionekane
    await tester.scrollUntilVisible(
      find.byKey(const Key('logout_button')),
      300,
      scrollable: find.descendant(
        of: find.byType(ProfileTab),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('logout_button')));
    await tester.pumpAndSettle();

    // Dialog ya uthibitisho
    expect(find.text('Toka?'), findsOneWidget);
    await tester.tap(find.text('Ndiyo, toka'));
    await tester.pumpAndSettle();

    // Sasa tuko login na session imefutwa
    expect(find.text('Karibu KooBus'), findsOneWidget);
    expect(auth.status, AuthStatus.loggedOut);
  });
}
