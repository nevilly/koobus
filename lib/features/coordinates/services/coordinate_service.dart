// CoordinateService — mawasiliano ya nafasi (GPS) na API.
//
// Service hii haijui UI. Inarudisha models tu; controller ndiyo inayosimamia
// hali ya loading/error na kuarifu screens.

import 'package:koobus/core/constants/api_endpoints.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/models/coordinate_model.dart';

abstract class CoordinateRepository {
  Future<CoordinateOverview> overview();

  Future<CoordinateModel> saveChild({
    required int childId,
    required double latitude,
    required double longitude,
    String? label,
  });

  Future<CoordinateModel> confirmChild(int childId);

  Future<CoordinateModel> saveSchool({
    required int schoolId,
    required double latitude,
    required double longitude,
    String? label,
  });

  Future<CoordinateModel> confirmSchool(int schoolId);
}

class CoordinateService implements CoordinateRepository {
  CoordinateService(this._api);

  final ApiClient _api;

  @override
  Future<CoordinateOverview> overview() async {
    final response = await _api.get(ApiEndpoints.coordinatesOverview);
    final data = response.data;
    if (data == null) return const CoordinateOverview();
    if (data is! Map) {
      throw const ApiException(
        statusCode: 500,
        message: 'Jibu la server halijaeleweka.',
      );
    }
    return CoordinateOverview.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<CoordinateModel> saveChild({
    required int childId,
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final response = await _api.post(
      ApiEndpoints.childCoordinate(childId),
      body: {
        'latitude': latitude,
        'longitude': longitude,
        if (label != null && label.trim().isNotEmpty) 'label': label.trim(),
      },
    );
    return _coordinate(response.data);
  }

  @override
  Future<CoordinateModel> confirmChild(int childId) async {
    final response = await _api.post(
      ApiEndpoints.childCoordinateConfirm(childId),
    );
    return _coordinate(response.data);
  }

  @override
  Future<CoordinateModel> saveSchool({
    required int schoolId,
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final response = await _api.post(
      ApiEndpoints.schoolCoordinate(schoolId),
      body: {
        'latitude': latitude,
        'longitude': longitude,
        if (label != null && label.trim().isNotEmpty) 'label': label.trim(),
      },
    );
    return _coordinate(response.data);
  }

  @override
  Future<CoordinateModel> confirmSchool(int schoolId) async {
    final response = await _api.post(
      ApiEndpoints.schoolCoordinateConfirm(schoolId),
    );
    return _coordinate(response.data);
  }

  CoordinateModel _coordinate(Object? data) {
    if (data is Map) {
      return CoordinateModel.fromJson(Map<String, dynamic>.from(data));
    }
    throw const ApiException(
      statusCode: 500,
      message: 'Server haikurudisha nafasi.',
    );
  }
}
