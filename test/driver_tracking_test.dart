// Tests za GPS tracking: ruhusa, GPS imezimwa, usahihi, stale na upload.
//
// Hatuandiki eneo la mfano kwenye app; hapa `FakeLocationSource` ni ya
// tests pekee.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/features/driver/controllers/driver_tracking_controller.dart';
import 'package:koobus/services/location_service.dart';

import 'helpers/fake_driver_repository.dart';

class FakeLocationSource implements LocationSource {
  bool enabled = true;
  LocationPermissionState permission = LocationPermissionState.granted;
  LocationFix? current;
  final StreamController<LocationFix> _stream =
      StreamController<LocationFix>.broadcast();

  int appSettingsCalls = 0;
  int locationSettingsCalls = 0;

  @override
  Future<bool> isServiceEnabled() async => enabled;

  @override
  Future<LocationPermissionState> ensurePermission() async => permission;

  @override
  Future<LocationFix> currentFix() async {
    final fix = current;
    if (fix == null) throw StateError('no fix');
    return fix;
  }

  @override
  Stream<LocationFix> watchFixes() => _stream.stream;

  void emit(LocationFix fix) => _stream.add(fix);

  @override
  Future<void> openAppSettings() async {
    appSettingsCalls++;
  }

  @override
  Future<void> openLocationSettings() async {
    locationSettingsCalls++;
  }

  Future<void> close() => _stream.close();
}

LocationFix _fix({
  double latitude = -6.8,
  double longitude = 39.2,
  double accuracy = 8,
  Duration age = Duration.zero,
}) {
  return LocationFix(
    latitude: latitude,
    longitude: longitude,
    accuracy: accuracy,
    timestamp: DateTime.now().subtract(age),
    speed: 6.4,
  );
}

void main() {
  test('GPS imezimwa: state ni serviceDisabled na hakuna upload', () async {
    final source = FakeLocationSource()..enabled = false;
    final repository = FakeDriverRepository();
    final controller = DriverTrackingController(
      source: source,
      repository: repository,
    );

    await controller.start(10);

    expect(controller.state, TrackingState.serviceDisabled);
    expect(repository.locations, isEmpty);

    controller.dispose();
    await source.close();
  });

  test('ruhusa imekataliwa: state ni permissionDenied', () async {
    final source = FakeLocationSource()
      ..permission = LocationPermissionState.denied;
    final controller = DriverTrackingController(
      source: source,
      repository: FakeDriverRepository(),
    );

    await controller.start(10);

    expect(controller.state, TrackingState.permissionDenied);
    expect(controller.isTrackingTrip(10), isFalse);

    controller.dispose();
    await source.close();
  });

  test('ruhusa imezuiwa kabisa: state ni permissionDeniedForever', () async {
    final source = FakeLocationSource()
      ..permission = LocationPermissionState.deniedForever;
    final controller = DriverTrackingController(
      source: source,
      repository: FakeDriverRepository(),
    );

    await controller.start(10);

    expect(controller.state, TrackingState.permissionDeniedForever);

    controller.dispose();
    await source.close();
  });

  test('fix nzuri inaonyesha live na inatumwa kwa server', () async {
    final source = FakeLocationSource()..current = _fix();
    final repository = FakeDriverRepository();
    final controller = DriverTrackingController(
      source: source,
      repository: repository,
    );

    await controller.start(10);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state, TrackingState.live);
    expect(repository.locations, hasLength(1));
    expect(repository.locations.first['trip_id'], 10);
    expect(repository.locations.first['latitude'], -6.8);
    expect(repository.locations.first['longitude'], 39.2);

    controller.dispose();
    await source.close();
  });

  test('fix isiyo sahihi haitumwi na inaonyesha inaccurate', () async {
    final source = FakeLocationSource()..current = _fix(accuracy: 120);
    final repository = FakeDriverRepository();
    final controller = DriverTrackingController(
      source: source,
      repository: repository,
    );

    await controller.start(10);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state, TrackingState.inaccurate);
    expect(repository.locations, isEmpty);

    controller.dispose();
    await source.close();
  });

  test('fix ya zamani inaonyeshwa kama stale na haitumwi', () async {
    final source = FakeLocationSource()
      ..current = _fix(age: const Duration(minutes: 2));
    final repository = FakeDriverRepository();
    final controller = DriverTrackingController(
      source: source,
      repository: repository,
    );

    await controller.start(10);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state, TrackingState.stale);
    expect(repository.locations, isEmpty);

    controller.dispose();
    await source.close();
  });

  test('upload ikishindikana, ramani inabaki live na kosa linaonekana',
      () async {
    final source = FakeLocationSource()..current = _fix();
    final repository = FakeDriverRepository()
      ..locationError = const _LocationError();
    final controller = DriverTrackingController(
      source: source,
      repository: repository,
    );

    await controller.start(10);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state, TrackingState.live);
    expect(controller.uploadError, 'upload_failed');
    expect(controller.lastFix, isNotNull);

    controller.dispose();
    await source.close();
  });

  test('stop inasafisha hali na kuacha stream', () async {
    final source = FakeLocationSource()..current = _fix();
    final controller = DriverTrackingController(
      source: source,
      repository: FakeDriverRepository(),
    );

    await controller.start(10);
    expect(controller.isTrackingTrip(10), isTrue);

    await controller.stop(clearFix: true);

    expect(controller.state, TrackingState.idle);
    expect(controller.isTracking, isFalse);
    expect(controller.lastFix, isNull);

    controller.dispose();
    await source.close();
  });
}

class _LocationError implements Exception {
  const _LocationError();
}
