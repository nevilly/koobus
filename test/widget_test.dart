// Test ya splash screen na navigation yake kwenda login.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/main.dart';

void main() {
  testWidgets('Splash inaonyesha jina la KooBus kwanza',
      (WidgetTester tester) async {
    await tester.pumpWidget(const KooBusApp());

    expect(find.text('KooBus'), findsOneWidget);
    expect(find.text('Usalama wa safari ya shule'), findsOneWidget);
    expect(find.byIcon(Icons.directions_bus_filled), findsOneWidget);

    // Splash ina timer ya sekunde 2 (kwa navigation). Test framework
    // inadai hakuna timer iliyobaki baada ya test — hivyo tunaimaliza
    // hapa kwa "kuifanya muda kupita" bila kusubiri halisi.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('Splash inaondoka na inaonyesha login baada ya sekunde 2',
      (WidgetTester tester) async {
    await tester.pumpWidget(const KooBusApp());

    // pumpDuration = "songesha muda wa widget" — hii inafanya
    // Future.delayed ya sekunde 2 itimize bila kusubiri halisi.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(); // subiri animation ya navigation ikamilike

    // Login screen sasa ionekane
    expect(find.text('Karibu KooBus'), findsOneWidget);
    expect(find.text('Ingia'), findsOneWidget);
  });
}
