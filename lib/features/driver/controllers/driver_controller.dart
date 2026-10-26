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
import 'package:koobus/models/student_manifest_entry.dart';
import 'package:koobus/models/trip_model.dart';

enum DriverViewState { loading, ready, empty, error }

/// Hali ya manifest ya wanafunzi. Tofauti na `DriverViewState`, manifest
/// inaweza kushindwa bila kuzuia dashibodi nzima kuonekana.
enum ManifestViewState { idle, loading, ready, empty, error }

class DriverController extends ChangeNotifier {
  DriverController({
    required this.repository,
    required this.driverId,
    this.driverName = '',
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final DriverRepository repository;

  /// `users.id` ya dereva aliyeingia. 0 = haijulikani (legacy session).
  final int driverId;
  final String driverName;

  /// Chanzo cha muda; tests zinaweza kuweka saa maalum.
  final DateTime Function() _clock;
  DateTime get now => _clock();

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

  List<StudentManifestEntry> _manifest = const [];
  ManifestViewState _manifestState = ManifestViewState.idle;
  String? _manifestError;
  int? _manifestStatusCode;
  int? _markingChildId;
  String? _attendanceError;
  int? _attendanceStatusCode;

  DriverViewState get state => _state;
  TripModel? get trip => _trip;
  RouteModel? get route => _route;
  BusModel? get bus => _bus;
  List<RouteStopModel> get stops => List.unmodifiable(_stops);
  String? get errorMessage => _errorMessage;
  int? get errorStatusCode => _errorStatusCode;
  bool get busy => _busy;

  List<StudentManifestEntry> get manifest => List.unmodifiable(_manifest);
  ManifestViewState get manifestState => _manifestState;
  String? get manifestError => _manifestError;
  int? get manifestStatusCode => _manifestStatusCode;
  int? get markingChildId => _markingChildId;
  String? get attendanceError => _attendanceError;
  int? get attendanceStatusCode => _attendanceStatusCode;

  bool isMarking(int childId) => _markingChildId == childId;

  bool get isAssignedToMe =>
      _trip != null && (driverId <= 0 || _trip!.driverId == driverId);

  bool get hasBus => _bus != null;
  bool get hasRoute => _route != null;
  bool get hasStops => _stops.isNotEmpty;

  bool get _hasStartResources =>
      _state == DriverViewState.ready &&
      !_busy &&
      isAssignedToMe &&
      _trip != null &&
      _trip!.isPending &&
      hasBus &&
      hasRoute;

  /// Kitufe cha kawaida cha kuanza: dirisha la saa moja lazima lifunguke.
  bool get canStart => _hasStartResources && _trip!.startWindowOpenAt(_clock());

  /// Kuanza kwa dharura: kabla ya dirisha, siku ya safari.
  bool get canEmergencyStart =>
      _hasStartResources && _trip!.canEmergencyStartAt(_clock());

  /// Ratiba ya safari ya sasa.
  DateTime? get scheduledAt => _trip?.scheduledAt;
  DateTime? get startWindowAt => _trip?.startWindowAt;
  bool get hasSchedule => _trip?.hasScheduledTime ?? false;
  bool get isStartWindowOpen =>
      _trip != null && _trip!.startWindowOpenAt(_clock());
  bool get isScheduledTimeReached =>
      _trip != null && _trip!.scheduledTimeReachedAt(_clock());
  Duration? get timeUntilStartWindow => _trip?.timeUntilStartWindow(_clock());

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
    _manifest = const [];
    _manifestState = ManifestViewState.loading;
    _manifestError = null;
    _manifestStatusCode = null;
    _attendanceError = null;
    _attendanceStatusCode = null;
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
        _manifest = const [];
        _manifestState = ManifestViewState.empty;
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

      // Manifest ni nyongeza: kama itashindwa, dashibodi inabaki kutumika
      // na tab ya wanafunzi inaonyesha kosa lake lenyewe na Retry.
      await _loadManifest(seq);
    } on ApiException catch (error) {
      if (seq != _requestSeq || _disposed) return;
      _errorMessage = error.message;
      _errorStatusCode = error.statusCode;
      _manifestState = ManifestViewState.idle;
      _setState(DriverViewState.error);
    } catch (_) {
      if (seq != _requestSeq || _disposed) return;
      _errorMessage = '';
      _errorStatusCode = 0;
      _manifestState = ManifestViewState.idle;
      _setState(DriverViewState.error);
    }
  }

  /// Pakia manifest ya trip ya sasa (mfano baada ya kurekodi mahudhurio).
  Future<void> loadManifest() => _loadManifest(_requestSeq);

  Future<void> _loadManifest(int seq) async {
    final trip = _trip;
    if (trip == null) {
      _manifest = const [];
      _manifestState = ManifestViewState.empty;
      _manifestError = null;
      _manifestStatusCode = null;
      _notify();
      return;
    }

    _manifestState = ManifestViewState.loading;
    _manifestError = null;
    _manifestStatusCode = null;
    _notify();

    try {
      final entries = await repository.loadManifest(trip.id);
      if (seq != _requestSeq || _disposed) return;
      _manifest = entries;
      _manifestState = entries.isEmpty
          ? ManifestViewState.empty
          : ManifestViewState.ready;
    } on ApiException catch (error) {
      if (seq != _requestSeq || _disposed) return;
      _manifestError = error.message;
      _manifestStatusCode = error.statusCode;
      _manifestState = ManifestViewState.error;
    } catch (_) {
      if (seq != _requestSeq || _disposed) return;
      _manifestError = '';
      _manifestStatusCode = 0;
      _manifestState = ManifestViewState.error;
    }
    _notify();
  }

  /// Rekodi mahudhurio ya mwanafunzi kwa API, kisha pakia manifest upya.
  Future<bool> markAttendance({
    required int childId,
    required TripAttendanceAction action,
  }) async {
    final trip = _trip;
    if (trip == null || !trip.isActive || _markingChildId != null) {
      return false;
    }

    StudentManifestEntry? entry;
    for (final item in _manifest) {
      if (item.id == childId) {
        entry = item;
        break;
      }
    }
    if (entry == null) return false;

    _markingChildId = childId;
    _attendanceError = null;
    _attendanceStatusCode = null;
    _notify();

    try {
      await repository.addTripEvent(
        tripId: trip.id,
        childId: childId,
        eventType: action.apiValue,
        stopId: entry.stopIdFor(trip.tripType),
      );
      await _loadManifest(_requestSeq);
      return true;
    } on ApiException catch (error) {
      _attendanceError = error.message;
      _attendanceStatusCode = error.statusCode;
      return false;
    } catch (_) {
      _attendanceError = '';
      _attendanceStatusCode = 0;
      return false;
    } finally {
      _markingChildId = null;
      _notify();
    }
  }

  /// Anzisha safari. Inarudisha `true` kama server ilikubali.
  ///
  /// `emergency` inatumika pale dereva anapoona wanafunzi wametolewa
  /// mapema. Server ndiyo inathibitisha na kurekodi dharura.
  Future<bool> startTrip({bool emergency = false, String? reason}) async {
    if (!_hasStartResources) return false;
    final trip = _trip!;
    final time = _clock();
    final windowOpen = trip.startWindowOpenAt(time);
    if (!windowOpen && !(emergency && trip.canEmergencyStartAt(time))) {
      return false;
    }
    final isEmergency = !windowOpen;
    final normalizedReason = (reason ?? '').trim();

    _busy = true;
    _errorMessage = null;
    _errorStatusCode = null;
    _notify();

    try {
      await repository.startTrip(
        trip.id,
        emergency: isEmergency,
        reason: isEmergency ? normalizedReason : null,
      );
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

  /// Chagua safari inayofuata: leo/baadaye kwa ratiba, sio ya siku zilizopita.
  ///
  /// Safari za zamani zisizo na ratiba zinaachwa kama hazina effective time;
  /// hii inaendelea kuunga mkono data ya DB ya awali.
  TripModel? _pickNext(List<TripModel> trips) {
    final now = _clock();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final pending = trips.where((trip) => trip.isPending).toList();
    if (pending.isEmpty) return null;

    final candidates = pending.where((trip) {
      final when = trip.effectiveScheduledAt;
      return when == null || !when.isBefore(startOfToday);
    }).toList();

    // Kama server ina pending za zamani pekee, usianze safari ya jana
    // kimya kimya. Dereva anaona "hakuna safari" hadi shule ipange mpya.
    if (candidates.isEmpty) return null;

    candidates.sort((a, b) {
      final at = a.effectiveScheduledAt;
      final bt = b.effectiveScheduledAt;
      if (at == null && bt == null) return a.id.compareTo(b.id);
      if (at == null) return 1;
      if (bt == null) return -1;
      final byTime = at.compareTo(bt);
      return byTime != 0 ? byTime : a.id.compareTo(b.id);
    });
    return candidates.first;
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
