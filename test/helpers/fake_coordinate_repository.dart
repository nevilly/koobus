// FakeCoordinateRepository — hifadhi ya kufikirika kwa tests za nafasi.
//
// Inatekeleza mkataba ule ule wa `CoordinateRepository` bila mtandao.
// Inaweza kuiga upande unaohifadhi/unaothibitisha (mzazi au shule) ili
// tests zithibitishe kanuni ya uthibitisho wa pande mbili.

import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/features/coordinates/services/coordinate_service.dart';
import 'package:koobus/models/coordinate_model.dart';

class FakeCoordinateRepository implements CoordinateRepository {
  FakeCoordinateRepository({
    CoordinateOverview? overview,
    this.overviewError,
    this.saveChildError,
    this.confirmChildError,
    this.saveSchoolError,
    this.confirmSchoolError,
    this.saveChildSide = 'parent',
    this.confirmChildSide = 'parent',
    this.saveSchoolSide = 'school',
    this.confirmSchoolSide = 'parent',
  }) : _overview = overview ?? const CoordinateOverview();

  CoordinateOverview _overview;

  Object? overviewError;
  Object? saveChildError;
  Object? confirmChildError;
  Object? saveSchoolError;
  Object? confirmSchoolError;

  /// Upande unaohifadhi nafasi ya mtoto (`parent` au `school`).
  String saveChildSide;

  /// Upande unaothibitisha nafasi ya mtoto (`parent` au `school`).
  String confirmChildSide;

  /// Upande unaohifadhi nafasi ya shule (kawaida `school`).
  String saveSchoolSide;

  /// Upande unaothibitisha nafasi ya shule (kawaida `parent`).
  String confirmSchoolSide;

  int overviewCalls = 0;
  final List<String> calls = [];

  CoordinateOverview get state => _overview;

  @override
  Future<CoordinateOverview> overview() async {
    overviewCalls++;
    calls.add('overview');
    if (overviewError != null) throw overviewError!;
    return _overview;
  }

  @override
  Future<CoordinateModel> saveChild({
    required int childId,
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    calls.add('saveChild:$childId');
    if (saveChildError != null) throw saveChildError!;

    final parentSide = saveChildSide == 'parent';
    final now = DateTime.now();
    final coordinate = CoordinateModel(
      id: 100,
      entityType: 'child',
      entityId: childId,
      latitude: latitude,
      longitude: longitude,
      label: label,
      proposedBy: 1,
      proposedRole: parentSide ? 'parent' : 'school_admin',
      parentConfirmed: parentSide,
      schoolConfirmed: !parentSide,
      parentConfirmedAt: parentSide ? now : null,
      schoolConfirmedAt: parentSide ? null : now,
    );
    _replaceChild(childId, coordinate);
    return coordinate;
  }

  @override
  Future<CoordinateModel> confirmChild(int childId) async {
    calls.add('confirmChild:$childId');
    if (confirmChildError != null) throw confirmChildError!;

    final current = _childCoordinate(childId);
    if (current == null) {
      throw const ApiException(
        statusCode: 404,
        message: 'Coordinate not found',
      );
    }

    final parentSide = confirmChildSide == 'parent';
    final now = DateTime.now();
    final updated = current.copyWith(
      parentConfirmed: parentSide ? true : current.parentConfirmed,
      schoolConfirmed: parentSide ? current.schoolConfirmed : true,
      parentConfirmedAt: parentSide ? now : current.parentConfirmedAt,
      schoolConfirmedAt: parentSide ? current.schoolConfirmedAt : now,
    );
    _replaceChild(childId, updated);
    return updated;
  }

  @override
  Future<CoordinateModel> saveSchool({
    required int schoolId,
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    calls.add('saveSchool:$schoolId');
    if (saveSchoolError != null) throw saveSchoolError!;

    final parentSide = saveSchoolSide == 'parent';
    final now = DateTime.now();
    final coordinate = CoordinateModel(
      id: 200,
      entityType: 'school',
      entityId: schoolId,
      latitude: latitude,
      longitude: longitude,
      label: label,
      proposedBy: 1,
      proposedRole: parentSide ? 'parent' : 'school_admin',
      parentConfirmed: parentSide,
      schoolConfirmed: !parentSide,
      parentConfirmedAt: parentSide ? now : null,
      schoolConfirmedAt: parentSide ? null : now,
    );
    _replaceSchool(schoolId, coordinate);
    return coordinate;
  }

  @override
  Future<CoordinateModel> confirmSchool(int schoolId) async {
    calls.add('confirmSchool:$schoolId');
    if (confirmSchoolError != null) throw confirmSchoolError!;

    final current = _schoolCoordinate(schoolId);
    if (current == null) {
      throw const ApiException(
        statusCode: 404,
        message: 'Coordinate not found',
      );
    }

    final parentSide = confirmSchoolSide == 'parent';
    final now = DateTime.now();
    final updated = current.copyWith(
      parentConfirmed: parentSide ? true : current.parentConfirmed,
      schoolConfirmed: parentSide ? current.schoolConfirmed : true,
      parentConfirmedAt: parentSide ? now : current.parentConfirmedAt,
      schoolConfirmedAt: parentSide ? current.schoolConfirmedAt : now,
    );
    _replaceSchool(schoolId, updated);
    return updated;
  }

  CoordinateModel? _childCoordinate(int childId) {
    for (final entry in _overview.children) {
      if (entry.childId == childId) return entry.coordinate;
    }
    return null;
  }

  CoordinateModel? _schoolCoordinate(int schoolId) {
    for (final entry in _overview.schools) {
      if (entry.schoolId == schoolId) return entry.coordinate;
    }
    return null;
  }

  void _replaceChild(int childId, CoordinateModel coordinate) {
    final children = [
      for (final entry in _overview.children)
        if (entry.childId == childId)
          ChildCoordinateEntry(
            childId: entry.childId,
            firstName: entry.firstName,
            lastName: entry.lastName,
            className: entry.className,
            schoolId: entry.schoolId,
            schoolName: entry.schoolName,
            coordinate: coordinate,
          )
        else
          entry,
    ];
    _overview = CoordinateOverview(
      children: children,
      schools: _overview.schools,
    );
  }

  void _replaceSchool(int schoolId, CoordinateModel coordinate) {
    final schools = [
      for (final entry in _overview.schools)
        if (entry.schoolId == schoolId)
          SchoolCoordinateEntry(
            schoolId: entry.schoolId,
            schoolName: entry.schoolName,
            coordinate: coordinate,
          )
        else
          entry,
    ];
    _overview = CoordinateOverview(
      children: _overview.children,
      schools: schools,
    );
  }
}
