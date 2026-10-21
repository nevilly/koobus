// Tests za splash, navigation, na SESSION PERSISTENCE.
//
// Session persistence = mtu akiingia, akifunga app akirudi, asingie tena.
// Hapa tunasimulia hali hii kwa kutumia InMemorySessionService.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/core/storage/secure_session_service.dart';
import 'package:koobus/main.dart';

void main() {
  testWidgets('Splash inaonyesha jina la KooBus kwanza',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      KooBusApp(sessionService: InMemorySessionService()),
    );

    expect(find.text('KooBus'), findsOneWidget);
    expect(find.text('Usalama wa safari ya shule'), findsOneWidget);
    expect(find.byIcon(Icons.directions_bus_filled), findsOneWidget);

    // Maliza timer ya splash na navigation ili test isikose
    // "pending timer".
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('Mtu hajawa kuingia -> anaona login', (tester) async {
    await tester.pumpWidget(
      KooBusApp(sessionService: InMemorySessionService()),
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Hakuna session -> login
    expect(find.text('Karibu KooBus'), findsOneWidget);
  });

  testWidgets('SESSION PERSISTENCE: akiingia na kurudi, haliingii tena',
      (tester) async {
    // Hifadhi moja inayoshirikiana — inawakilisha "keystore ya simu".
    // App mbili (mara ya kwanza na ya pili) zitaitumia hii hii.
    final sharedStorage = InMemorySessionService();

    // ---- APP YA KWANZA ----
    await tester.pumpWidget(KooBusApp(sessionService: sharedStorage));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Karibu KooBus'), findsOneWidget); // login

    // Ingia: weka namba na nenosiri
    await tester.enterText(find.byType(TextFormField).at(0), '0712345678');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Ingia'));
    await tester.pumpAndSettle();

    // Sasa yuko home
    expect(find.text('Karibu, 0712345678'), findsOneWidget);

    // ---- APP YA PILI (baada ya kufunga na kufungua tena) ----
    // Tunajenga widget tree mpya kabisa (kama simu imezimwa na kuwasha),
    // lakini tunatumia hifadhi YENYELE — session inapaswa kusomeka.
    await tester.pumpWidget(KooBusApp(sessionService: sharedStorage));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // HII NDIO TEST KUU: hajalingia tena — anaona home moja kwa moja.
    expect(find.text('Karibu, 0712345678'), findsOneWidget);
    expect(find.text('Karibu KooBus'), findsNothing); // login haipo
  });

  testWidgets('Kutoka (logout) kunafuta session — akirudi atalingia tena',
      (tester) async {
    final sharedStorage = InMemorySessionService();

    // Ingia
    await tester.pumpWidget(KooBusApp(sessionService: sharedStorage));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '0712345678');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Ingia'));
    await tester.pumpAndSettle();
    expect(find.text('Karibu, 0712345678'), findsOneWidget);

    // Toka: bonyeza ikoni ya logout kwenye AppBar kisha thibitisha
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Toka'));
    await tester.pumpAndSettle();

    // Sasa yuko login tena
    expect(find.text('Karibu KooBus'), findsOneWidget);

    // App ya pili (baada ya kufunga): session imefutwa -> login tena
    await tester.pumpWidget(KooBusApp(sessionService: sharedStorage));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Karibu KooBus'), findsOneWidget); // login, si home
  });
}
