// ignore_for_file: prefer_initializing_formals

// DriverTrackingController �?" GPS halisi wakati safari inaendelea.
//
// Mtiririko:
//   1. Hakikisha location service imewaka na ruhusa imetolewa.
//   2. Pata nafasi ya sasa, kisha sikiliza stream ya GPS.
//   3. Tuma nafasi kwenye API ikiwa safari ni active.
//   4. Weka alama ya "stale" kama hakuna update mpya kwa sekunde 30.
//
// Hatuonyeshi eneo la mfano. Kama GPS haipatikani, UI inaonyesha hali
// halisi (imezimwa, ruhusa imekataliwa, au signal hafifu).

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:koobus/features/driver/services/driver_service.dart';
import 'package:koobus/services/location_service.dart';

enum TrackingState {
  idle,
  requesting,
  permissionDenied,
  permissionDeniedForever,
  serviceDisabled,
  locating,
  live,
  stale,
  inaccurate,
  error,
}

class DriverTrackingController extends ChangeNotifier {
  DriverTrackingController({
    required LocationSource source,
    required DriverRepository repository,
    DateTime Function()? now,
  }) : _source = source,
       _repository = repository,
       _now = now ?? DateTime.now;

  final LocationSource _source;
  final DriverRepository _repository;
  final DateTime Function() _now;

  StreamSubscription<LocationFix>? _subscription;
  Timer? _staleTimer;
  int? _tripId;
  LocationFix? _lastFix;
  DateTime? _lastFixAt;
  DateTime? _lastUploadAt;
  bool _uploading = false;
  bool _disposed = false;

  TrackingState _state = TrackingState.idle;
  String? _uploadError;

  TrackingState get state => _state;
  int? get tripId => _tripId;
  LocationFix? get lastFix => _lastFix;
  DateTime? get lastFixAt => _lastFixAt;
  DateTime? get lastUploadAt => _lastUploadAt;
  String? get uploadError => _uploadError;
  bool get isTracking => _subscription != null;
  bool get hasFix => _lastFix != null;

  bool isTrackingTrip(int tripId) => _tripId == tripId && _subscription != null;

  /// Anza kufuatilia trip. Inaweza kuitwa tena kwa trip hiyo hiyo ili
  /// kujaribu ruhusa/GPS tena.
  Future<void> start(int tripId) async {
    if (isTrackingTrip(tripId)) return;

    await stop(clearFix: true);
    _tripId = tripId;
    _uploadError = null;
    _setState(TrackingState.requesting);

    try {
      if (!await _source.isServiceEnabled()) {
        if (_disposed) return;
        _setState(TrackingState.serviceDisabled);
        return;
      }

      final permission = await _source.ensurePermission();
      if (_disposed) return;
      switch (permission) {
        case LocationPermissionState.granted:
          break;
        case LocationPermissionState.denied:
          _setState(TrackingState.permissionDenied);
          return;
        case LocationPermissionState.deniedForever:
          _setState(TrackingState.permissionDeniedForever);
          return;
        case LocationPermissionState.serviceDisabled:
          _setState(TrackingState.serviceDisabled);
          return;
      }

      if (!await _source.isServiceEnabled()) {
        if (_disposed) return;
        _setState(TrackingState.serviceDisabled);
        return;
      }

      _setState(TrackingState.locating);

      // Stream ndiyo chanzo kikuu; currentFix ni jaribio la haraka ili
      // ramani ionyeshe kitu mara moja.
      _subscription = _source.watchFixes().listen(
        _handleFix,
        onError: (Object error) => _handleError(error),
      );

      try {
        final fix = await _source.currentFix();
        _handleFix(fix);
      } catch (_) {
        // Stream inaendelea kusubiri; hakuna haja ya kuonyesha kosa
        // papo hapo kama GPS bado inatafuta signal.
      }

      _staleTimer?.cancel();
      _staleTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => _checkStale(),
      );
    } catch (error) {
      if (_disposed) return;
      _uploadError = null;
      _setState(TrackingState.error);
    }
  }

  Future<void> stop({bool clearFix = false}) async {
    await _subscription?.cancel();
    _subscription = null;
    _staleTimer?.cancel();
    _staleTimer = null;
    _tripId = null;
    _uploadError = null;
    if (clearFix) {
      _lastFix = null;
      _lastFixAt = null;
      _lastUploadAt = null;
    }
    _setState(TrackingState.idle);
  }

  Future<void> openAppSettings() => _source.openAppSettings();

  Future<void> openLocationSettings() => _source.openLocationSettings();

  void _handleFix(LocationFix fix) {
    if (_disposed || _tripId == null) return;

    if (!fix.isAccurate) {
      // Tunabaki na fix ya mwisho nzuri (kama ipo) na kuonyesha onyo.
      _setState(TrackingState.inaccurate);
      return;
    }

    if (fix.isStaleAt(_now())) {
      _setState(TrackingState.stale);
      return;
    }

    _lastFix = fix;
    _lastFixAt = _now();
    _setState(TrackingState.live);
    unawaited(_upload(fix));
  }

  Future<void> _upload(LocationFix fix) async {
    final tripId = _tripId;
    if (tripId == null || _uploading) return;

    _uploading = true;
    try {
      await _repository.uploadLocation(
        tripId: tripId,
        latitude: fix.latitude,
        longitude: fix.longitude,
        speed: fix.speed,
        accuracy: fix.accuracy,
      );
      if (_disposed) return;
      _lastUploadAt = _now();
      _uploadError = null;
      _notify();
    } catch (_) {
      if (_disposed) return;
      // Ramani inaendelea kuonyesha eneo la simu; upload itajaribiwa
      // tena kwenye fix inayofuata.
      _uploadError = 'upload_failed';
      _notify();
    } finally {
      _uploading = false;
    }
  }

  void _checkStale() {
    if (_disposed || _tripId == null) return;
    final fix = _lastFix;
    if (fix == null) {
      if (_state == TrackingState.live ||
          _state == TrackingState.inaccurate ||
          _state == TrackingState.stale) {
        _setState(TrackingState.locating);
      }
      return;
    }
    if (fix.isStaleAt(_now())) {
      _setState(TrackingState.stale);
    }
  }

  void _handleError(Object error) {
    if (_disposed) return;
    _setState(TrackingState.error);
  }

  void _setState(TrackingState next) {
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
    _subscription?.cancel();
    _staleTimer?.cancel();
    super.dispose();
  }
}
