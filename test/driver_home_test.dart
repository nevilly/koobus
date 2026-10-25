// Widget test ya DriverHomeScreen.
//
// Tunatumia DriverController yenye FakeDriverRepository, hivyo test
// inaendesha bila server. Tunaangalia: safari inaonekana, utayari,
// kuanza safari, na orodha ya vituo.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/app/app_theme.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/features/driver/screens/driver_home_screen.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/bus_model.dart';
import 'package:koobus/models/route_model.dart';
import 'package:koobus/models/route_stop_model.dart';
import 'package:koobus/models/trip_model.dart';

import 'helpers/fake_driver_repository.dart';

const _route = RouteModel(id: 3, schoolId: 2, name: 'Route A');
const _bus = BusModel(id: 2, plateNumber: 'T 123 ABC', schoolId: 2);
const _stops = [
  RouteStopModel(id: 1, routeId: 3, name: 'Kariakoo', stopOrder: 1),
  RouteStopModel(id: 2, routeId: 3, name: 'Upanga', stopOrder: 2),
];

TripModel _pendingTrip() {
  return TripModel(
    id: 10,
    routeId: 3,
    busId: 2,
    driverId: 7,
    tripType: 'morning',
    status: TripStatus.pending,
    createdAt: DateTime.now(),
  );
}

Widget _wrap(DriverController controller) {
  return MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('sw'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: DriverHomeScreen(controller: controller),
  );
}

void main() {
  testWidgets('inaonyesha safari, utayari na kuanza safari', (tester) async {
    final repository = FakeDriverRepository(
      trips: [_pendingTrip()],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(
      repository: repository,
      driverId: 7,
      driverName: 'Juma',
    );

    await tester.pumpWidget(_wrap(controller));
    await tester.pumpAndSettle();

    expect(find.text('Karibu, Juma'), findsOneWidget);
    expect(find.text('Route A'), findsWidgets);
    expect(find.text('T 123 ABC'), findsWidgets);
    expect(find.text('Utayari wa safari'), findsOneWidget);
    expect(find.text('Vituo vimepakiwa'), findsOneWidget);

    // Kitufe kiko chini ya orodha — sogeza hadi kionekane.
    await tester.scrollUntilVisible(
      find.byKey(const Key('start_trip_button')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('start_trip_button')));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Maliza safari'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Maliza safari'), findsOneWidget);
    expect(find.text('Safari imeanza.'), findsOneWidget);

    // Acha SnackBar itokee ili kuondoa timer inayosubiri.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('kitufe cha vituo kinafungua orodha ya vituo', (tester) async {
    final repository = FakeDriverRepository(
      trips: [_pendingTrip()],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(repository: repository, driverId: 7);

    await tester.pumpWidget(_wrap(controller));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('view_stops_button')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('view_stops_button')));
    await tester.pumpAndSettle();

    expect(find.text('Kariakoo'), findsOneWidget);
    expect(find.text('Upanga'), findsOneWidget);
    expect(find.text('Vituo 2'), findsOneWidget);
  });

  testWidgets('hakuna safari -> empty state', (tester) async {
    final repository = FakeDriverRepository();
    final controller = DriverController(repository: repository, driverId: 7);

    await tester.pumpWidget(_wrap(controller));
    await tester.pumpAndSettle();

    expect(find.text('Hakuna safari iliyopangwa'), findsOneWidget);
    expect(find.text('Anza safari'), findsNothing);
  });
}
