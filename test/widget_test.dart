// Test ya msingi ya KooBus.
// Inathibitisha: app inaweza kujengwa na splash screen inaonyesha
// jina la KooBus.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/main.dart';

void main() {
  testWidgets('Splash screen ya KooBus inaonyesha jina na ujumbe',
      (WidgetTester tester) async {
    // Jenga app yote
    await tester.pumpWidget(const KooBusApp());

    // Angalia kama jina la app lipo kwenye screen
    expect(find.text('KooBus'), findsOneWidget);

    // Angalia kama ujumbe wa utambulisho upo
    expect(find.text('Usalama wa safari ya shule'), findsOneWidget);

    // Angalia kama ikoni ya basi ipo
    expect(find.byIcon(Icons.directions_bus_filled), findsOneWidget);
  });
}
