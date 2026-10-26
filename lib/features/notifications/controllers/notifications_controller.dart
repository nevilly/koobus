// NotificationsController — hali ya taarifa za mtumiaji.
//
// Inapakia kutoka API, inahesabu unread, inaruhusu mark-read, na inapoll
// kila sekunde 30 app ikiwa wazi. Hii ni "in-app alerts" halisi; FCM
// (background push) bado haijawekwa.

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/features/notifications/services/notification_service.dart';
import 'package:koobus/models/notification_model.dart';

enum NotificationsViewState { loading, ready, empty, error }

class NotificationsController extends ChangeNotifier {
  NotificationsController({
    required this.repository,
    required this.userId,
    this.pollInterval = const Duration(seconds: 30),
    this.onNewNotification,
  });

  final NotificationRepository repository;
  final int userId;
  final Duration pollInterval;
  final void Function(NotificationModel notification)? onNewNotification;

  NotificationsViewState _state = NotificationsViewState.loading;
  List<NotificationModel> _items = const [];
  String? _errorMessage;
  int? _errorStatusCode;
  bool _busy = false;
  bool _disposed = false;
  bool _loadedOnce = false;
  Timer? _pollTimer;
  final Set<int> _knownIds = <int>{};

  NotificationsViewState get state => _state;
  List<NotificationModel> get items => List.unmodifiable(_items);
  String? get errorMessage => _errorMessage;
  int? get errorStatusCode => _errorStatusCode;
  bool get busy => _busy;
  int get unreadCount => _items.where((item) => item.isUnread).length;
  bool get hasUnread => unreadCount > 0;

  /// Pakia taarifa; `showSpinner=false` hutumika kwa poll ya nyuma.
  Future<void> load({bool showSpinner = true}) async {
    if (userId <= 0) {
      _items = const [];
      _state = NotificationsViewState.empty;
      _loadedOnce = true;
      _notify();
      return;
    }

    if (showSpinner && !_loadedOnce) {
      _state = NotificationsViewState.loading;
      _notify();
    }

    try {
      final fetched = await repository.forUser(userId);
      if (_disposed) return;

      final newUnread = <NotificationModel>[];
      if (_loadedOnce) {
        for (final item in fetched) {
          if (item.isUnread && !_knownIds.contains(item.id)) {
            newUnread.add(item);
          }
        }
      }

      _knownIds
        ..clear()
        ..addAll(fetched.map((item) => item.id));
      _items = _sorted(fetched);
      _errorMessage = null;
      _errorStatusCode = null;
      _loadedOnce = true;
      _state = _items.isEmpty
          ? NotificationsViewState.empty
          : NotificationsViewState.ready;
      _notify();

      for (final item in newUnread) {
        onNewNotification?.call(item);
      }
    } on ApiException catch (error) {
      if (_disposed) return;
      _errorMessage = error.message;
      _errorStatusCode = error.statusCode;
      if (_items.isEmpty) _state = NotificationsViewState.error;
      _notify();
    } catch (_) {
      if (_disposed) return;
      _errorMessage = '';
      _errorStatusCode = 0;
      if (_items.isEmpty) _state = NotificationsViewState.error;
      _notify();
    }
  }

  /// Pakia mara moja kisha anza poll ya kila `pollInterval`.
  void start() {
    load();
    _pollTimer?.cancel();
    _pollTimer = null;
    if (pollInterval.inMilliseconds <= 0) return;
    _pollTimer = Timer.periodic(pollInterval, (_) => load(showSpinner: false));
  }

  /// Simamisha poll (mfano shell inapofungwa) bila kuharibu data.
  void stop() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> markRead(NotificationModel notification) async {
    if (!notification.isUnread || _busy) return;
    _busy = true;
    _notify();
    try {
      await repository.markRead(
        notificationId: notification.id,
        userId: userId,
      );
      final now = DateTime.now();
      _items = _items
          .map(
            (item) =>
                item.id == notification.id ? item.copyWith(readAt: now) : item,
          )
          .toList();
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _errorStatusCode = error.statusCode;
    } catch (_) {
      _errorMessage = '';
      _errorStatusCode = 0;
    } finally {
      _busy = false;
      _notify();
    }
  }

  Future<void> markAllRead() async {
    if (!hasUnread || _busy) return;
    _busy = true;
    _notify();
    try {
      await repository.markAllRead(userId);
      final now = DateTime.now();
      _items = _items
          .map((item) => item.isUnread ? item.copyWith(readAt: now) : item)
          .toList();
    } on ApiException catch (error) {
      _errorMessage = error.message;
      _errorStatusCode = error.statusCode;
    } catch (_) {
      _errorMessage = '';
      _errorStatusCode = 0;
    } finally {
      _busy = false;
      _notify();
    }
  }

  List<NotificationModel> _sorted(List<NotificationModel> items) {
    final copy = List<NotificationModel>.of(items);
    copy.sort((a, b) {
      final at = a.createdAt;
      final bt = b.createdAt;
      if (at == null && bt == null) return b.id.compareTo(a.id);
      if (at == null) return 1;
      if (bt == null) return -1;
      final byTime = bt.compareTo(at);
      return byTime != 0 ? byTime : b.id.compareTo(a.id);
    });
    return copy;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    stop();
    super.dispose();
  }
}
