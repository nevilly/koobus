// FakeDriverRepository — data ya kufikirika kwa tests za dereva.
//
// Hii inatekeleza `DriverRepository` bila mtandao. Kila test inaweza
// kuweka safari, route, basi na vituo anavyotaka, na kuangalia ni
// maombi gani yalifanyika.

import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/features/driver/services/driver_service.dart';
import 'package:koobus/models/bus_model.dart';
import 'package:koobus/models/route_model.dart';
import 'package:koobus/models/route_stop_model.dart';
import 'package:koobus/models/student_manifest_entry.dart';
import 'package:koobus/models/trip_model.dart';

class FakeDriverRepository implements DriverRepository {
  FakeDriverRepository({
    this.active,
    List<TripModel>? trips,
    this.route,
    this.bus,
    List<RouteStopModel>? stops,
    List<StudentManifestEntry>? manifest,
    this.startError,
    this.endError,
    this.manifestError,
    this.eventError,
  }) : trips = trips ?? const [],
       stops = stops ?? const [],
       manifest = manifest ?? const [];

  TripModel? active;
  List<TripModel> trips;
  RouteModel? route;
  BusModel? bus;
  List<RouteStopModel> stops;
  List<StudentManifestEntry> manifest;
  ApiException? startError;
  ApiException? endError;
  ApiException? manifestError;
  ApiException? eventError;
  Object? locationError;

  int startCalls = 0;
  int endCalls = 0;
  int manifestCalls = 0;
  bool lastStartEmergency = false;
  String? lastStartReason;
  final List<Map<String, Object?>> events = [];
  final List<Map<String, Object?>> locations = [];

  @override
  Future<TripModel?> activeTrip(int driverId) async => active;

  @override
  Future<List<TripModel>> tripsForDriver(int driverId) async => List.of(trips);

  @override
  Future<RouteModel> loadRoute(int routeId) async {
    final value = route;
    if (value == null) {
      throw const ApiException(statusCode: 404, message: '');
    }
    return value;
  }

  @override
  Future<BusModel> loadBus(int busId) async {
    final value = bus;
    if (value == null) {
      throw const ApiException(statusCode: 404, message: '');
    }
    return value;
  }

  @override
  Future<List<RouteStopModel>> loadStops(int routeId) async => List.of(stops);

  @override
  Future<void> startTrip(
    int tripId, {
    bool emergency = false,
    String? reason,
  }) async {
    startCalls++;
    lastStartEmergency = emergency;
    lastStartReason = reason;
    final error = startError;
    if (error != null) throw error;

    final found = active?.id == tripId
        ? active!
        : trips.firstWhere((trip) => trip.id == tripId);
    active = found.copyWith(
      status: TripStatus.active,
      startedAt: DateTime.now(),
      startedEarly: emergency,
      earlyStartReason: emergency ? reason : null,
    );
    trips = trips.where((trip) => trip.id != tripId).toList();
  }

  @override
  Future<void> endTrip(int tripId) async {
    endCalls++;
    final error = endError;
    if (error != null) throw error;

    active = null;
    trips = trips.where((trip) => trip.id != tripId).toList();
  }

  @override
  Future<List<StudentManifestEntry>> loadManifest(int tripId) async {
    manifestCalls++;
    final error = manifestError;
    if (error != null) throw error;
    return List.of(manifest);
  }

  @override
  Future<void> addTripEvent({
    required int tripId,
    required int childId,
    required String eventType,
    int? stopId,
  }) async {
    final error = eventError;
    if (error != null) throw error;
    events.add({
      'trip_id': tripId,
      'child_id': childId,
      'event_type': eventType,
      'stop_id': stopId,
    });
  }

  @override
  Future<void> uploadLocation({
    required int tripId,
    required double latitude,
    required double longitude,
    double? speed,
    double? accuracy,
  }) async {
    final error = locationError;
    if (error != null) throw error;
    locations.add({
      'trip_id': tripId,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'accuracy': accuracy,
    });
  }
}
