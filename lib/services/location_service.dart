// LocationService �?" GPS halisi ya kifaa.
//
// Kanuni: hatutumii eneo la mfano. Kila nafasi inatoka kwenye GPS ya
// simu. Service hii ni nyembamba kwa makusudi ili controller iweze
// kujaribiwa kwa `LocationSource` ya kufikirika.
//
// Phase 9.1 inashughulikia:
//   - ruhusa (granted/denied/deniedForever),
//   - huduma ya location ikiwa imezimwa,
//   - usahihi (accuracy), muda (timestamp) na umbali wa update.

import 'package:geolocator/geolocator.dart';

/// Jibu la ruhusa ya eneo.
enum LocationPermissionState {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

/// Nafasi moja ya GPS, imetolewa kwenye `Position` ili controller na
/// tests zisitegemee package ya geolocator.
class LocationFix {
  const LocationFix({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    this.speed,
    this.heading,
  });

  final double latitude;
  final double longitude;

  /// Usahihi kwa mita (kadiri inavyopungua, ndivyo ilivyo bora).
  final double accuracy;
  final DateTime timestamp;
  final double? speed;
  final double? heading;

  /// Zaidi ya mita 50 ni hafifu kwa ETA/geofence.
  static const double maxAccuracyMeters = 50;

  bool get isAccurate => accuracy >= 0 && accuracy <= maxAccuracyMeters;

  /// GPS ya zamani haipaswi kuonyeshwa kama "live".
  bool isStaleAt(
    DateTime now, {
    Duration maxAge = const Duration(seconds: 30),
  }) {
    return now.difference(timestamp) > maxAge;
  }
}

/// Kiolesura kinachotumika na `DriverTrackingController` (na tests).
abstract class LocationSource {
  Future<bool> isServiceEnabled();
  Future<LocationPermissionState> ensurePermission();
  Future<LocationFix> currentFix();
  Stream<LocationFix> watchFixes();
  Future<void> openAppSettings();
  Future<void> openLocationSettings();
}

/// Implementesheni halisi inayotumia geolocator.
class GeolocatorLocationSource implements LocationSource {
  const GeolocatorLocationSource();

  @override
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermissionState> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationPermissionState.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionState.granted;
      case LocationPermission.deniedForever:
        return LocationPermissionState.deniedForever;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return LocationPermissionState.denied;
    }
  }

  @override
  Future<LocationFix> currentFix() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return _toFix(position);
  }

  @override
  Stream<LocationFix> watchFixes() {
    // Mita 10 / sekunde 5: maandamano ya basi hayahitaji update za
    // sekunde moja; hii inapunguza data na betri (Phase 9.1).
    final settings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      intervalDuration: Duration(seconds: 5),
      forceLocationManager: false,
    );
    return Geolocator.getPositionStream(locationSettings: settings)
        .map(_toFix);
  }

  @override
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  @override
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  LocationFix _toFix(Position position) {
    return LocationFix(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp,
      speed: position.speed,
      heading: position.heading,
    );
  }
}
