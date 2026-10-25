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
import 'package:koobus/models/trip_model.dart';

class FakeDriverRepository implements DriverRepository {
  FakeDriverRepository({
    this.active,
    List<TripModel>? trips,
    this.route,
    this.bus,
    List<RouteStopModel>? stops,
    this.startError,
    this.endError,
  })  : trips = trips ?? const [],
        stops = stops ?? const [];

  TripModel? active;
  List<TripModel> trips;
  RouteModel? route;
  BusModel? bus;
  List<RouteStopModel> stops;
  ApiException? startError;
  ApiException? endError;

  int startCalls = 0;
  int endCalls = 0;

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
  Future<void> startTrip(int tripId) async {
    startCalls++;
    final error = startError;
    if (error != null) throw error;

    final found = active?.id == tripId
        ? active!
        : trips.firstWhere((trip) => trip.id == tripId);
    active = found.copyWith(
      status: TripStatus.active,
      startedAt: DateTime.now(),
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
}
