// FakeNotificationRepository — taarifa za kufikirika kwa widget/controller tests.

import 'package:koobus/features/notifications/services/notification_service.dart';
import 'package:koobus/models/notification_model.dart';

class FakeNotificationRepository implements NotificationRepository {
  FakeNotificationRepository({List<NotificationModel>? items})
    : items = items ?? <NotificationModel>[];

  List<NotificationModel> items;
  int fetchCalls = 0;
  final List<int> markReadCalls = <int>[];
  int markAllCalls = 0;

  @override
  Future<List<NotificationModel>> forUser(int userId) async {
    fetchCalls++;
    return List<NotificationModel>.of(items);
  }

  @override
  Future<void> markRead({
    required int notificationId,
    required int userId,
  }) async {
    markReadCalls.add(notificationId);
    final now = DateTime.now();
    items = items
        .map(
          (item) =>
              item.id == notificationId ? item.copyWith(readAt: now) : item,
        )
        .toList();
  }

  @override
  Future<void> markAllRead(int userId) async {
    markAllCalls++;
    final now = DateTime.now();
    items = items.map((item) => item.copyWith(readAt: now)).toList();
  }
}

NotificationModel testNotification({
  int id = 1,
  int userId = 7,
  String type = 'trip_started',
  String title = 'Safari imeanza',
  String body = 'Safari ya Route A imeanza.',
  DateTime? readAt,
  DateTime? createdAt,
  Map<String, dynamic>? data,
}) {
  return NotificationModel(
    id: id,
    userId: userId,
    title: title,
    body: body,
    type: type,
    data:
        data ??
        const {
          'trip_id': 12,
          'route_name': 'Route A',
          'trip_type': 'morning',
          'early': 0,
        },
    readAt: readAt,
    createdAt: createdAt ?? DateTime(2026, 10, 27, 7, 0),
  );
}
