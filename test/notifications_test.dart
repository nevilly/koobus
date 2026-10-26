// Tests za taarifa halisi: parse, polling, unread na mark-read.

import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/features/notifications/controllers/notifications_controller.dart';
import 'package:koobus/models/notification_model.dart';

import 'helpers/fake_notification_repository.dart';

void main() {
  test('NotificationModel inasoma data ya JSON kutoka DB', () {
    final notification = NotificationModel.fromJson({
      'id': 9,
      'user_id': 7,
      'title': 'Safari imeanza',
      'body': 'Safari imeanza.',
      'type': 'trip_started',
      'data': '{"trip_id":12,"route_name":"Route A","early":1}',
      'read_at': null,
      'created_at': '2026-10-27 07:00:00',
    });

    expect(notification.isUnread, isTrue);
    expect(notification.tripId, 12);
    expect(notification.routeName, 'Route A');
    expect(notification.early, isTrue);
    expect(notification.createdAt, DateTime(2026, 10, 27, 7));
  });

  test('load ya kwanza haitoi alert ya notification ya zamani', () async {
    final repo = FakeNotificationRepository(items: [testNotification(id: 1)]);
    final seen = <NotificationModel>[];
    final controller = NotificationsController(
      repository: repo,
      userId: 7,
      pollInterval: Duration.zero,
      onNewNotification: seen.add,
    );

    await controller.load();

    expect(controller.state, NotificationsViewState.ready);
    expect(controller.unreadCount, 1);
    expect(seen, isEmpty);
  });

  test('poll inaonyesha taarifa mpya na kuita callback', () async {
    final repo = FakeNotificationRepository();
    final seen = <NotificationModel>[];
    final controller = NotificationsController(
      repository: repo,
      userId: 7,
      pollInterval: Duration.zero,
      onNewNotification: seen.add,
    );
    await controller.load();
    expect(controller.state, NotificationsViewState.empty);

    repo.items = [testNotification(id: 2, title: 'Safari imeanza')];
    await controller.load(showSpinner: false);

    expect(seen, hasLength(1));
    expect(seen.single.id, 2);
    expect(controller.unreadCount, 1);
  });

  test('markRead na markAllRead zinasasisha unread', () async {
    final repo = FakeNotificationRepository(
      items: [
        testNotification(id: 1, createdAt: DateTime(2026, 10, 27, 8)),
        testNotification(id: 2, createdAt: DateTime(2026, 10, 27, 7)),
      ],
    );
    final controller = NotificationsController(
      repository: repo,
      userId: 7,
      pollInterval: Duration.zero,
    );
    await controller.load();
    expect(controller.unreadCount, 2);

    await controller.markRead(controller.items.first);
    expect(repo.markReadCalls, contains(1));
    expect(controller.unreadCount, 1);

    await controller.markAllRead();
    expect(repo.markAllCalls, 1);
    expect(controller.unreadCount, 0);
  });
}
