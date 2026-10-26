// Tests za DriverController: kupakia safari, utayari, kuanza/kumaliza.
//
// Tunatumia FakeDriverRepository — hakuna mtandao. Hii inatuwezesha
// kuangalia hali (state) na maamuzi ya controller kwa uhakika.

import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/models/bus_model.dart';
import 'package:koobus/models/route_model.dart';
import 'package:koobus/models/route_stop_model.dart';
import 'package:koobus/models/student_manifest_entry.dart';
import 'package:koobus/models/trip_model.dart';

import 'helpers/fake_driver_repository.dart';

const _route = RouteModel(id: 3, schoolId: 2, name: 'Route A');
const _bus = BusModel(
  id: 2,
  plateNumber: 'T 123 ABC',
  capacity: 40,
  schoolId: 2,
);
const _stops = [
  RouteStopModel(id: 1, routeId: 3, name: 'Kariakoo', stopOrder: 1),
  RouteStopModel(id: 2, routeId: 3, name: 'Upanga', stopOrder: 2),
];

TripModel _trip({
  int id = 10,
  int driverId = 7,
  TripStatus status = TripStatus.pending,
  DateTime? createdAt,
  DateTime? scheduledAt,
  bool startedEarly = false,
  String? earlyStartReason,
}) {
  return TripModel(
    id: id,
    routeId: 3,
    busId: 2,
    driverId: driverId,
    tripType: 'morning',
    status: status,
    createdAt: createdAt ?? DateTime.now(),
    scheduledAt: scheduledAt,
    startedEarly: startedEarly,
    earlyStartReason: earlyStartReason,
  );
}

StudentManifestEntry _student({
  int id = 20,
  String firstName = 'Asha',
  String lastName = 'Juma',
  String dropoffStopName = 'Kariakoo',
  int dropoffStopOrder = 1,
  TripAttendanceStatus status = TripAttendanceStatus.none,
}) {
  return StudentManifestEntry(
    id: id,
    firstName: firstName,
    lastName: lastName,
    className: 'Std 4',
    routeId: 3,
    pickupStopId: 1,
    pickupStopName: 'Kariakoo',
    pickupStopOrder: 1,
    dropoffStopId: 2,
    dropoffStopName: dropoffStopName,
    dropoffStopOrder: dropoffStopOrder,
    attendanceStatus: status,
  );
}

void main() {
  test('load inapakia safari iliyopangwa, route, basi na vituo', () async {
    final repository = FakeDriverRepository(
      trips: [_trip()],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(
      repository: repository,
      driverId: 7,
      driverName: 'Juma',
    );

    await controller.load();

    expect(controller.state, DriverViewState.ready);
    expect(controller.trip?.id, 10);
    expect(controller.route?.name, 'Route A');
    expect(controller.bus?.plateNumber, 'T 123 ABC');
    expect(controller.stops, hasLength(2));
    expect(controller.isAssignedToMe, isTrue);
    expect(controller.canStart, isTrue);
    expect(controller.canEnd, isFalse);
  });

  test('safari inayoendelea inaruhusu kumaliza tu', () async {
    final repository = FakeDriverRepository(
      active: _trip(status: TripStatus.active),
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(repository: repository, driverId: 7);

    await controller.load();

    expect(controller.state, DriverViewState.ready);
    expect(controller.trip?.isActive, isTrue);
    expect(controller.canStart, isFalse);
    expect(controller.canEnd, isTrue);
  });

  test('safari ya dereva mwingine inakataliwa', () async {
    final repository = FakeDriverRepository(
      trips: [_trip(driverId: 99)],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(repository: repository, driverId: 7);

    await controller.load();

    expect(controller.state, DriverViewState.error);
    expect(controller.errorStatusCode, 403);
    expect(controller.trip, isNull);
  });

  test('hakuna safari -> empty', () async {
    final repository = FakeDriverRepository();
    final controller = DriverController(repository: repository, driverId: 7);

    await controller.load();

    expect(controller.state, DriverViewState.empty);
    expect(controller.trip, isNull);
  });

  test('startTrip inatuma kwa server na kupakia upya', () async {
    final repository = FakeDriverRepository(
      trips: [_trip()],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(repository: repository, driverId: 7);
    await controller.load();

    final ok = await controller.startTrip();

    expect(ok, isTrue);
    expect(repository.startCalls, 1);
    expect(controller.state, DriverViewState.ready);
    expect(controller.trip?.isActive, isTrue);
    expect(controller.trip?.startedAt, isNotNull);
    expect(controller.canEnd, isTrue);
  });

  test('safari ya baadaye inafunguka saa moja kabla', () async {
    final now = DateTime(2026, 10, 27, 6, 30);
    final repository = FakeDriverRepository(
      trips: [_trip(scheduledAt: DateTime(2026, 10, 27, 8, 0))],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(
      repository: repository,
      driverId: 7,
      clock: () => now,
    );
    await controller.load();

    expect(controller.canStart, isFalse);
    expect(controller.canEmergencyStart, isTrue);
    expect(controller.startWindowAt, DateTime(2026, 10, 27, 7, 0));
    expect(controller.timeUntilStartWindow, const Duration(minutes: 30));

    final atWindow = DriverController(
      repository: repository,
      driverId: 7,
      clock: () => DateTime(2026, 10, 27, 7, 1),
    );
    await atWindow.load();
    expect(atWindow.canStart, isTrue);
    expect(atWindow.canEmergencyStart, isFalse);
  });

  test('kuanza kwa dharura kunatuma sababu kwa server', () async {
    final repository = FakeDriverRepository(
      trips: [_trip(scheduledAt: DateTime(2026, 10, 27, 8, 0))],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(
      repository: repository,
      driverId: 7,
      clock: () => DateTime(2026, 10, 27, 6, 0),
    );
    await controller.load();

    expect(controller.canStart, isFalse);
    expect(controller.canEmergencyStart, isTrue);

    final ok = await controller.startTrip(
      emergency: true,
      reason: 'Wanafunzi wametolewa mapema',
    );

    expect(ok, isTrue);
    expect(repository.startCalls, 1);
    expect(repository.lastStartEmergency, isTrue);
    expect(repository.lastStartReason, 'Wanafunzi wametolewa mapema');
    expect(controller.trip?.isActive, isTrue);
    expect(controller.trip?.startedEarly, isTrue);
  });

  test('kuanza kwa dharura hakuruhusiwi siku nyingine', () async {
    final repository = FakeDriverRepository(
      trips: [_trip(scheduledAt: DateTime(2026, 10, 28, 8, 0))],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(
      repository: repository,
      driverId: 7,
      clock: () => DateTime(2026, 10, 27, 8, 0),
    );
    await controller.load();

    expect(controller.canStart, isFalse);
    expect(controller.canEmergencyStart, isFalse);
    final ok = await controller.startTrip(emergency: true, reason: 'Dharura');
    expect(ok, isFalse);
    expect(repository.startCalls, 0);
  });

  test('baada ya kumaliza, dereva anaona safari inayofuata', () async {
    final now = DateTime(2026, 10, 27, 7, 0);
    final repository = FakeDriverRepository(
      trips: [
        _trip(id: 10, scheduledAt: DateTime(2026, 10, 27, 7, 30)),
        _trip(id: 11, scheduledAt: DateTime(2026, 10, 27, 14, 0)),
      ],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(
      repository: repository,
      driverId: 7,
      clock: () => now,
    );
    await controller.load();
    expect(controller.trip?.id, 10);

    await controller.startTrip();
    expect(controller.trip?.isActive, isTrue);

    await controller.endTrip();
    expect(controller.trip?.id, 11);
    expect(controller.trip?.isPending, isTrue);
  });

  test('safari ya jana iliyoachwa pending haionyeshwi', () async {
    final repository = FakeDriverRepository(
      trips: [_trip(id: 10, scheduledAt: DateTime(2026, 10, 26, 7, 0))],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(
      repository: repository,
      driverId: 7,
      clock: () => DateTime(2026, 10, 27, 7, 0),
    );
    await controller.load();

    expect(controller.state, DriverViewState.empty);
    expect(controller.trip, isNull);
  });

  test(
    'startTrip yenye 409 inaonyesha kosa na kuacha safari pending',
    () async {
      final repository = FakeDriverRepository(
        trips: [_trip()],
        route: _route,
        bus: _bus,
        stops: _stops,
        startError: const ApiException(
          statusCode: 409,
          message: 'Driver already has an active trip',
        ),
      );
      final controller = DriverController(repository: repository, driverId: 7);
      await controller.load();

      final ok = await controller.startTrip();

      expect(ok, isFalse);
      expect(controller.errorStatusCode, 409);
      expect(controller.state, DriverViewState.ready);
      expect(controller.trip?.isPending, isTrue);
      expect(controller.busy, isFalse);
    },
  );

  test('endTrip inamaliza safari na kurudi empty', () async {
    final repository = FakeDriverRepository(
      active: _trip(status: TripStatus.active),
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(repository: repository, driverId: 7);
    await controller.load();

    final ok = await controller.endTrip();

    expect(ok, isTrue);
    expect(repository.endCalls, 1);
    expect(controller.state, DriverViewState.empty);
    expect(controller.trip, isNull);
  });

  test('load inapakia manifest kwa mpangilio wa server', () async {
    final repository = FakeDriverRepository(
      trips: [_trip()],
      route: _route,
      bus: _bus,
      stops: _stops,
      manifest: [
        _student(id: 21, firstName: 'Neema', dropoffStopOrder: 1),
        _student(id: 22, firstName: 'Baraka', dropoffStopOrder: 2),
      ],
    );
    final controller = DriverController(repository: repository, driverId: 7);

    await controller.load();

    expect(controller.state, DriverViewState.ready);
    expect(controller.manifestState, ManifestViewState.ready);
    expect(controller.manifest, hasLength(2));
    expect(controller.manifest.first.firstName, 'Neema');
    expect(repository.manifestCalls, 1);
  });

  test('manifest tupu ina hali yake bila kuangusha dashibodi', () async {
    final repository = FakeDriverRepository(
      trips: [_trip()],
      route: _route,
      bus: _bus,
      stops: _stops,
    );
    final controller = DriverController(repository: repository, driverId: 7);

    await controller.load();

    expect(controller.state, DriverViewState.ready);
    expect(controller.manifestState, ManifestViewState.empty);
    expect(controller.manifest, isEmpty);
  });

  test('kosa la manifest halizuii dashibodi', () async {
    final repository = FakeDriverRepository(
      trips: [_trip()],
      route: _route,
      bus: _bus,
      stops: _stops,
      manifestError: const ApiException(statusCode: 500, message: 'Failed'),
    );
    final controller = DriverController(repository: repository, driverId: 7);

    await controller.load();

    expect(controller.state, DriverViewState.ready);
    expect(controller.manifestState, ManifestViewState.error);
    expect(controller.manifestStatusCode, 500);
  });

  test('markAttendance inatuma event na kupakia manifest upya', () async {
    final repository = FakeDriverRepository(
      active: _trip(status: TripStatus.active),
      route: _route,
      bus: _bus,
      stops: _stops,
      manifest: [_student()],
    );
    final controller = DriverController(repository: repository, driverId: 7);
    await controller.load();

    final ok = await controller.markAttendance(
      childId: 20,
      action: TripAttendanceAction.board,
    );

    expect(ok, isTrue);
    expect(repository.events, hasLength(1));
    expect(repository.events.first['trip_id'], 10);
    expect(repository.events.first['child_id'], 20);
    expect(repository.events.first['event_type'], 'board');
    expect(repository.events.first['stop_id'], 1);
    expect(repository.manifestCalls, 2);
    expect(controller.markingChildId, isNull);
  });

  test('markAttendance haifanyiki kwenye safari ambayo haijaanza', () async {
    final repository = FakeDriverRepository(
      trips: [_trip()],
      route: _route,
      bus: _bus,
      stops: _stops,
      manifest: [_student()],
    );
    final controller = DriverController(repository: repository, driverId: 7);
    await controller.load();

    final ok = await controller.markAttendance(
      childId: 20,
      action: TripAttendanceAction.board,
    );

    expect(ok, isFalse);
    expect(repository.events, isEmpty);
  });
}
