// Widget tests za manifest ya wanafunzi na mahudhurio.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/app/app_theme.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/features/driver/screens/tabs/driver_students_tab.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/bus_model.dart';
import 'package:koobus/models/route_model.dart';
import 'package:koobus/models/route_stop_model.dart';
import 'package:koobus/models/student_manifest_entry.dart';
import 'package:koobus/models/trip_model.dart';

import 'helpers/fake_driver_repository.dart';

const _route = RouteModel(id: 3, schoolId: 2, name: 'Route A');
const _bus = BusModel(id: 2, plateNumber: 'T 123 ABC', schoolId: 2);
const _stops = [
  RouteStopModel(id: 1, routeId: 3, name: 'Mbezi', stopOrder: 1),
  RouteStopModel(id: 2, routeId: 3, name: 'Kivukoni', stopOrder: 2),
];

TripModel _trip({
  TripStatus status = TripStatus.active,
  String tripType = 'afternoon',
}) {
  return TripModel(
    id: 10,
    routeId: 3,
    busId: 2,
    driverId: 7,
    tripType: tripType,
    status: status,
    createdAt: DateTime.now(),
  );
}

StudentManifestEntry _student({
  required int id,
  required String firstName,
  required int dropoffOrder,
  required String stop,
  TripAttendanceStatus attendance = TripAttendanceStatus.none,
}) {
  return StudentManifestEntry(
    id: id,
    firstName: firstName,
    lastName: 'Juma',
    className: 'Std 4',
    routeId: 3,
    pickupStopId: 1,
    pickupStopName: 'Mbezi',
    pickupStopOrder: 1,
    dropoffStopId: dropoffOrder,
    dropoffStopName: stop,
    dropoffStopOrder: dropoffOrder,
    attendanceStatus: attendance,
  );
}

Widget _wrap(DriverController controller) {
  return MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('sw'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: DriverStudentsTab(controller: controller),
  );
}

void main() {
  testWidgets('orodha ni mlalo na inafuata mpangilio wa drop-off', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = FakeDriverRepository(
      active: _trip(),
      route: _route,
      bus: _bus,
      stops: _stops,
      manifest: [
        _student(id: 21, firstName: 'Neema', dropoffOrder: 1, stop: 'Mbezi'),
        _student(
          id: 22,
          firstName: 'Baraka',
          dropoffOrder: 2,
          stop: 'Kivukoni',
        ),
      ],
    );
    final controller = DriverController(repository: repository, driverId: 7);
    await controller.load();

    await tester.pumpWidget(_wrap(controller));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('student_manifest_list')), findsOneWidget);
    expect(find.text('Wanafunzi 2'), findsOneWidget);
    expect(find.text('Wa kwanza kushuka'), findsOneWidget);

    final first = tester.getTopLeft(find.byKey(const Key('student_card_21')));
    final second = tester.getTopLeft(find.byKey(const Key('student_card_22')));
    expect(first.dx, lessThan(second.dx));
    expect(find.text('Neema Juma'), findsOneWidget);
    expect(find.text('Baraka Juma'), findsOneWidget);
  });

  testWidgets('kurekodi mahudhurio kunatuma event kwa API', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = FakeDriverRepository(
      active: _trip(),
      route: _route,
      bus: _bus,
      stops: _stops,
      manifest: [
        _student(id: 21, firstName: 'Neema', dropoffOrder: 1, stop: 'Mbezi'),
      ],
    );
    final controller = DriverController(repository: repository, driverId: 7);
    await controller.load();

    await tester.pumpWidget(_wrap(controller));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('attendance_button_21')));
    await tester.pumpAndSettle();
    expect(find.text('Mahudhurio ya Neema Juma'), findsOneWidget);

    await tester.tap(find.byKey(const Key('attendance_option_alight')));
    await tester.pumpAndSettle();

    expect(repository.events, hasLength(1));
    expect(repository.events.first['event_type'], 'alight');
    expect(repository.events.first['stop_id'], 1);
    expect(find.text('Mahudhurio yamerekodiwa.'), findsOneWidget);
  });

  testWidgets('safari ambayo haijaanza inazuia kurekodi', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = FakeDriverRepository(
      trips: [_trip(status: TripStatus.pending)],
      route: _route,
      bus: _bus,
      stops: _stops,
      manifest: [
        _student(id: 21, firstName: 'Neema', dropoffOrder: 1, stop: 'Mbezi'),
      ],
    );
    final controller = DriverController(repository: repository, driverId: 7);
    await controller.load();

    await tester.pumpWidget(_wrap(controller));
    await tester.pumpAndSettle();

    expect(
      find.text('Anzisha safari kwanza ili kurekodi mahudhurio.'),
      findsOneWidget,
    );
    final button = tester.widget<FilledButton>(
      find.byKey(const Key('attendance_button_21')),
    );
    expect(button.onPressed, isNull);
  });
}
