// NotificationService — taarifa halisi za mtumiaji kutoka API.
//
// Push ya mbali (FCM) bado haijawekwa; kwa sasa app inapoll API hii
// inapokuwa wazi. Hii inaruhusu wazazi/shule kuona taarifa za kuanza
// safari mara moja bila kudai kuwa background push imekamilika.

import 'package:koobus/core/constants/api_endpoints.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> forUser(int userId);

  Future<void> markRead({required int notificationId, required int userId});

  Future<void> markAllRead(int userId);
}

class NotificationService implements NotificationRepository {
  NotificationService(this._api);

  final ApiClient _api;

  @override
  Future<List<NotificationModel>> forUser(int userId) async {
    if (userId <= 0) return const [];
    final response = await _api.get(ApiEndpoints.notificationsByUser(userId));
    return _listOfMaps(response.data).map(NotificationModel.fromJson).toList();
  }

  @override
  Future<void> markRead({
    required int notificationId,
    required int userId,
  }) async {
    await _api.post(
      ApiEndpoints.notificationMarkRead,
      body: {'id': notificationId, 'user_id': userId},
    );
  }

  @override
  Future<void> markAllRead(int userId) async {
    if (userId <= 0) return;
    await _api.post(
      ApiEndpoints.notificationMarkAllRead,
      body: {'user_id': userId},
    );
  }

  List<Map<String, dynamic>> _listOfMaps(Object? data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (data is Map) return [Map<String, dynamic>.from(data)];
    return const [];
  }
}
