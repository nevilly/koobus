// Tests za DriverShell: bottom navigation, tabs, sticky Start/End na
// wasifu wa dereva.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';

import 'package:koobus/app/app_theme.dart';
import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/controllers/language_controller.dart';
import 'package:koobus/core/storage/language_service.dart';
import 'package:koobus/core/storage/secure_session_service.dart';
import 'package:koobus/core/storage/session_service.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/features/driver/screens/driver_shell.dart';
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

Future<AuthController> _loggedInDriver() async {
  final store = InMemorySessionService();
  await store.saveSession(
    const StoredSession(
      token: 'TEST-DRIVER-TOKEN',
      phone: '255700000003',
      role: 'driver',
      userId: 7,
      displayName: 'Test Driver',
    ),
  );
  final auth = AuthController(store);
  await auth.restoreSession();
  return auth;
}

Widget _wrap(AuthController auth, DriverController controller) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthController>.value(value: auth),
      ChangeNotifierProvider<LanguageController>(
        create: (_) => LanguageController(InMemoryLanguageService()),
      ),
    ],
    child: Consumer<LanguageController>(
      builder: (context, language, _) {
        return MaterialApp(
          theme: AppTheme.light,
          locale: language.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: DriverShell(controller: controller),
        );
      },
    ),
  );
}

Future<void> _tapTab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('bottom navigation iko na Start iko juu yake', (tester) async {
    final auth = await _loggedInDriver();
    final controller = DriverController(
      repository: FakeDriverRepository(
        trips: [_pendingTrip()],
        route: _route,
        bus: _bus,
        stops: _stops,
      ),
      driverId: 7,
      driverName: 'Test Driver',
    );

    await tester.pumpWidget(_wrap(auth, controller));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Nyumbani'), findsOneWidget);
    expect(find.text('Wanafunzi'), findsOneWidget);
    expect(find.text('Ramani'), findsOneWidget);
    expect(find.text('Wasifu'), findsOneWidget);

    final startBottom = tester
        .getBottomLeft(find.byKey(const Key('start_trip_button')))
        .dy;
    final navTop = tester.getTopLeft(find.byType(NavigationBar)).dy;
    expect(startBottom, lessThanOrEqualTo(navTop));
  });

  testWidgets('tabs za Wanafunzi, Ramani na Wasifu zinafunguka', (
    tester,
  ) async {
    final auth = await _loggedInDriver();
    final controller = DriverController(
      repository: FakeDriverRepository(
        trips: [_pendingTrip()],
        route: _route,
        bus: _bus,
        stops: _stops,
      ),
      driverId: 7,
      driverName: 'Test Driver',
    );

    await tester.pumpWidget(_wrap(auth, controller));
    await tester.pumpAndSettle();

    await _tapTab(tester, 'Wanafunzi');
    expect(find.text('Hakuna wanafunzi kwenye route hii'), findsOneWidget);

    await _tapTab(tester, 'Ramani');
    expect(find.text('Ramani na GPS inakuja'), findsOneWidget);

    await _tapTab(tester, 'Wasifu');
    expect(find.text('Taarifa za dereva'), findsOneWidget);
    expect(find.text('Test Driver'), findsWidgets);
    expect(find.text('255700000003'), findsWidgets);
  });

  testWidgets('Wasifu: lugha na logout zinafunguka', (tester) async {
    final auth = await _loggedInDriver();
    final controller = DriverController(
      repository: FakeDriverRepository(
        trips: [_pendingTrip()],
        route: _route,
        bus: _bus,
        stops: _stops,
      ),
      driverId: 7,
      driverName: 'Test Driver',
    );

    await tester.pumpWidget(_wrap(auth, controller));
    await tester.pumpAndSettle();

    await _tapTab(tester, 'Wasifu');

    await tester.ensureVisible(find.byKey(const Key('driver_language_tile')));
    await tester.tap(find.byKey(const Key('driver_language_tile')));
    await tester.pumpAndSettle();
    expect(find.text('Chagua lugha'), findsOneWidget);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Home'),
      ),
      findsOneWidget,
    );

    // Acha SnackBar ya "Language changed" itokee kabla ya kubonyeza
    // kitufe kilicho chini ya profile.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('driver_logout_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('driver_logout_button')));
    await tester.pumpAndSettle();
    expect(find.text('Log out?'), findsOneWidget);
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(find.text('Taarifa za dereva'), findsNothing);
    expect(find.text('Driver details'), findsOneWidget);
  });
}
