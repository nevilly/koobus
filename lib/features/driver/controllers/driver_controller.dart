// DriverController — hali ya ukurasa wa dereva.
//
// Mtiririko:
//   1. Omba safari inayoendelea (`active_by_driver`).
//   2. Kama hakuna, chukua safari iliyopangwa (`by_driver` + pending).
//   3. Pakia basi, route na vituo kwa safari hiyo.
//   4. Anzisha / maliza safari kwa API, kisha pakia upya kutoka server.
//
// Kanuni: server ndiyo chanzo cha ukweli. Hatubadilishi status kwenye
// simu pekee — kila kitendo kinasubiri jibu la server kisha tunapakia
// upya. Hii inahakikisha hali inabaki sawa hata app ikifunguliwa tena.

import 'package:flutter/foundation.dart';

import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/features/driver/services/driver_service.dart';
import 'package:koobus/models/bus_model.dart';
import 'package:koobus/models/route_model.dart';
import 'package:koobus/models/route_stop_model.dart';
import 'package:koobus/models/trip_model.dart';

enum DriverViewState { loading, ready, empty, error }

class DriverController extends ChangeNotifier {
  DriverController({
    required this.repository,
    required this.driverId,
    this.driverName = '',
  });

  final DriverRepository repository;

  /// `users.id` ya dereva aliyeingia. 0 = haijulikani (legacy session).
  final int driverId;
  final String driverName;

  DriverViewState _state = DriverViewState.loading;
  TripModel? _trip;
  RouteModel? _route;
  BusModel? _bus;
  List<RouteStopModel> _stops = const [];
  String? _errorMessage;
  int? _errorStatusCode;
  bool _busy = false;
  bool _disposed = false;
  int _requestSeq = 0;

  DriverViewState get state => _state;
  TripModel? get trip => _trip;
  RouteModel? get route => _route;
  BusModel? get bus => _bus;
  List<RouteStopModel> get stops => List.unmodifiable(_stops);
  String? get errorMessage => _errorMessage;
  int? get errorStatusCode => _errorStatusCode;
  bool get busy => _busy;

  bool get isAssignedToMe =>
      _trip != null && (driverId <= 0 || _trip!.driverId == driverId);

  bool get hasBus => _bus != null;
  bool get hasRoute => _route != null;
  bool get hasStops => _stops.isNotEmpty;

  bool get canStart =>
      _state == DriverViewState.ready &&
      !_busy &&
      isAssignedToMe &&
      _trip != null &&
      _trip!.isPending &&
      hasBus &&
      hasRoute;

  bool get canEnd =>
      _state == DriverViewState.ready &&
      !_busy &&
      isAssignedToMe &&
      _trip != null &&
      _trip!.isActive;

  /// Pakia kila kitu kutoka server.
  Future<void> load() async {
    final seq = ++_requestSeq;
    _setState(DriverViewState.loading);
    _errorMessage = null;
    _errorStatusCode = null;
    _notify();

    try {
      final active = await repository.activeTrip(driverId);
      TripModel? target = active;

      if (target == null) {
        final trips = await repository.tripsForDriver(driverId);
        target = _pickNext(trips);
      }

      if (seq != _requestSeq || _disposed) return;

      if (target == null) {
        _trip = null;
        _route = null;
        _bus = null;
        _stops = const [];
        _setState(DriverViewState.empty);
        return;
      }

      // Ulinzi wa ziada upande wa client; server pia inathibitisha.
      if (driverId > 0 && target.driverId != driverId) {
        _trip = null;
        _setState(DriverViewState.error);
        _errorStatusCode = 403;
        _errorMessage = '';
        return;
      }

      final results = await Future.wait<dynamic>([
        repository.loadRoute(target.routeId),
        repository.loadBus(target.busId),
        repository.loadStops(target.routeId),
      ]);

      if (seq != _requestSeq || _disposed) return;

      _trip = target;
      _route = results[0] as RouteModel;
      _bus = results[1] as BusModel;
      _stops = (results[2] as List<RouteStopModel>);
      _setState(DriverViewState.ready);
    } on ApiException catch (error) {
      if (seq != _requestSeq || _disposed) return;
      _errorMessage = error.message;
      _errorStatusCode = error.statusCode;
      _setState(DriverViewState.error);
    } catch (_) {
      if (seq != _requestSeq || _disposed) return;
      _errorMessage = '';
      _errorStatusCode = 0;
      _setState(DriverViewState.error);
    }
  }

  /// Anzisha safari. Inarudisha `true` kama server ilikubali.
  Future<bool> startTrip() async {
    if (!canStart) return false;
    final trip = _trip!;
    _busy = true;
    _errorMessage = null;
    _errorStatusCode = null;
    _notify();

    try {
      await repository.startTrip(trip.id);
      await load();
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _errorStatusCode = error.statusCode;
      return false;
    } finally {
      _busy = false;
      _notify();
    }
  }

  /// Maliza safari. Inarudisha `true` kama server ilikubali.
  Future<bool> endTrip() async {
    if (!canEnd) return false;
    final trip = _trip!;
    _busy = true;
    _errorMessage = null;
    _errorStatusCode = null;
    _notify();

    try {
      await repository.endTrip(trip.id);
      await load();
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _errorStatusCode = error.statusCode;
      return false;
    } finally {
      _busy = false;
      _notify();
    }
  }

  /// Chagua safari: ile ya leo kwanza, kisha ya hivi karibuni.
  TripModel? _pickNext(List<TripModel> trips) {
    final pending = trips.where((trip) => trip.isPending).toList();
    if (pending.isEmpty) return null;

    final today = pending.where((trip) => trip.isToday).toList();
    return today.isNotEmpty ? today.first : pending.first;
  }

  void _setState(DriverViewState next) {
    _state = next;
    _notify();
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
