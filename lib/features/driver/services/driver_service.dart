// DriverService — data za dereva kutoka API.
//
// Tunaweka interface (`DriverRepository`) ili tests ziweze kutumia data
// ya kufikirika bila mtandao. `DriverService` ndiyo implementesheni
// halisi inayotumia ApiClient.

import 'package:koobus/core/constants/api_endpoints.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/models/bus_model.dart';
import 'package:koobus/models/route_model.dart';
import 'package:koobus/models/route_stop_model.dart';
import 'package:koobus/models/student_manifest_entry.dart';
import 'package:koobus/models/trip_model.dart';

/// Njia zote ambazo DriverController inahitaji.
abstract class DriverRepository {
  Future<TripModel?> activeTrip(int driverId);
  Future<List<TripModel>> tripsForDriver(int driverId);
  Future<RouteModel> loadRoute(int routeId);
  Future<BusModel> loadBus(int busId);
  Future<List<RouteStopModel>> loadStops(int routeId);
  Future<void> startTrip(int tripId);
  Future<void> endTrip(int tripId);
  Future<List<StudentManifestEntry>> loadManifest(int tripId);
  Future<void> addTripEvent({
    required int tripId,
    required int childId,
    required String eventType,
    int? stopId,
  });
  Future<void> uploadLocation({
    required int tripId,
    required double latitude,
    required double longitude,
    double? speed,
    double? accuracy,
  });
}

class DriverService implements DriverRepository {
  DriverService(this._api);

  final ApiClient _api;

  @override
  Future<TripModel?> activeTrip(int driverId) async {
    final response = await _api.get(ApiEndpoints.activeTripByDriver(driverId));
    final trips = _listOfMaps(response.data);
    if (trips.isEmpty) return null;
    return TripModel.fromJson(trips.first);
  }

  @override
  Future<List<TripModel>> tripsForDriver(int driverId) async {
    final response = await _api.get(ApiEndpoints.tripsByDriver(driverId));
    return _listOfMaps(response.data).map(TripModel.fromJson).toList();
  }

  @override
  Future<RouteModel> loadRoute(int routeId) async {
    final response = await _api.get(ApiEndpoints.route(routeId));
    final data = _mapOrNull(response.data);
    if (data == null) {
      throw const ApiException(statusCode: 404, message: '');
    }
    return RouteModel.fromJson(data);
  }

  @override
  Future<BusModel> loadBus(int busId) async {
    final response = await _api.get(ApiEndpoints.bus(busId));
    final data = _mapOrNull(response.data);
    if (data == null) {
      throw const ApiException(statusCode: 404, message: '');
    }
    return BusModel.fromJson(data);
  }

  @override
  Future<List<RouteStopModel>> loadStops(int routeId) async {
    final response = await _api.get(ApiEndpoints.routeStops(routeId));
    return _listOfMaps(response.data).map(RouteStopModel.fromJson).toList();
  }

  @override
  Future<void> startTrip(int tripId) async {
    await _api.post(ApiEndpoints.tripStart, body: {'trip_id': tripId});
  }

  @override
  Future<void> endTrip(int tripId) async {
    await _api.post(ApiEndpoints.tripEnd, body: {'trip_id': tripId});
  }

  @override
  Future<List<StudentManifestEntry>> loadManifest(int tripId) async {
    final response = await _api.get(ApiEndpoints.tripManifest(tripId));
    return _listOfMaps(response.data)
        .map(StudentManifestEntry.fromJson)
        .toList();
  }

  @override
  Future<void> addTripEvent({
    required int tripId,
    required int childId,
    required String eventType,
    int? stopId,
  }) async {
    await _api.post(
      ApiEndpoints.tripEventAdd,
      body: {
        'trip_id': tripId,
        'child_id': childId,
        'event_type': eventType,
        'stop_id': ?stopId,
      },
    );
  }

  @override
  Future<void> uploadLocation({
    required int tripId,
    required double latitude,
    required double longitude,
    double? speed,
    double? accuracy,
  }) async {
    await _api.post(
      ApiEndpoints.locationUpload,
      body: {
        'trip_id': tripId,
        'latitude': latitude,
        'longitude': longitude,
        'speed': ?speed,
        'accuracy': ?accuracy,
      },
    );
  }

  /// API inaweza kurudisha list, object moja, au `null` (204).
  List<Map<String, dynamic>> _listOfMaps(Object? data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (data is Map) {
      return [Map<String, dynamic>.from(data)];
    }
    return const [];
  }

  Map<String, dynamic>? _mapOrNull(Object? data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }
}
