// CoordinatesController — hali ya nafasi na uthibitisho.
//
// Controller moja hutumika kwenye StaffShell na kwenye screen ya mzazi.
// Inapakia overview (watoto + shule), kisha save/confirm zinasasisha data
// kutoka server ili hali ya uthibitisho isionekane ya zamani.

import 'package:flutter/foundation.dart';

import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/features/coordinates/services/coordinate_service.dart';
import 'package:koobus/models/coordinate_model.dart';

class CoordinatesController extends ChangeNotifier {
  CoordinatesController({required this.repository});

  final CoordinateRepository repository;

  CoordinateOverview _overview = const CoordinateOverview();
  bool _loading = false;
  bool _busy = false;
  bool _loaded = false;
  String? _error;

  CoordinateOverview get overview => _overview;
  List<ChildCoordinateEntry> get children => _overview.children;
  List<SchoolCoordinateEntry> get schools => _overview.schools;
  bool get loading => _loading;
  bool get busy => _busy;
  bool get loaded => _loaded;
  String? get error => _error;

  SchoolCoordinateEntry? get primarySchool =>
      _overview.schools.isEmpty ? null : _overview.schools.first;

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _overview = await repository.overview();
      _loaded = true;
    } catch (error) {
      _error = _errorText(error);
      _loaded = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> saveChild({
    required int childId,
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    await _run(
      () => repository.saveChild(
        childId: childId,
        latitude: latitude,
        longitude: longitude,
        label: label,
      ),
    );
  }

  Future<void> confirmChild(int childId) async {
    await _run(() => repository.confirmChild(childId));
  }

  Future<void> saveSchool({
    required int schoolId,
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    await _run(
      () => repository.saveSchool(
        schoolId: schoolId,
        latitude: latitude,
        longitude: longitude,
        label: label,
      ),
    );
  }

  Future<void> confirmSchool(int schoolId) async {
    await _run(() => repository.confirmSchool(schoolId));
  }

  Future<void> _run(Future<CoordinateModel> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();

    try {
      await action();
      _overview = await repository.overview();
      _loaded = true;
    } catch (error) {
      _error = _errorText(error);
      rethrow;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  String _errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
