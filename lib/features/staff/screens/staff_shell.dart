// StaffShell — "nyumba" ya Matron/Patron na school admin.
//
// Tabs:
//   Wanafunzi — nafasi za wanafunzi (weka/badilisha/thibitisha)
//   Shule     — nafasi ya shule
//   Taarifa   — taarifa halisi za safari
//   Wasifu    — taarifa, lugha na logout
//
// Controller moja inatumiwa na tabs zote ili nafasi moja isipotelewe
// tab inapobadilishwa.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/features/coordinates/controllers/coordinates_controller.dart';
import 'package:koobus/features/coordinates/services/coordinate_service.dart';
import 'package:koobus/features/notifications/controllers/notifications_controller.dart';
import 'package:koobus/features/notifications/services/notification_service.dart';
import 'package:koobus/features/staff/screens/tabs/staff_alerts_tab.dart';
import 'package:koobus/features/staff/screens/tabs/staff_children_coordinates_tab.dart';
import 'package:koobus/features/staff/screens/tabs/staff_profile_tab.dart';
import 'package:koobus/features/staff/screens/tabs/staff_school_coordinate_tab.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/notification_model.dart';

class StaffShell extends StatefulWidget {
  const StaffShell({super.key, this.controller, this.notificationsController});

  /// Kwa test: controller iliyotengenezwa tayari. Kwenye app halisi ni
  /// `null`; shell itaunda controller kutoka `ApiClient`.
  final CoordinatesController? controller;

  /// Kwa test: alerts controller iliyotengenezwa tayari.
  final NotificationsController? notificationsController;

  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  int _index = 0;
  late final CoordinatesController _controller;
  late final bool _ownsController;
  late final NotificationsController _notifications;
  late final bool _ownsNotifications;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    final provided = widget.controller;
    if (provided != null) {
      _controller = provided;
      _ownsController = false;
    } else {
      _controller = CoordinatesController(
        repository: CoordinateService(context.read<ApiClient>()),
      );
      _ownsController = true;
    }

    final providedNotifications = widget.notificationsController;
    if (providedNotifications != null) {
      _notifications = providedNotifications;
      _ownsNotifications = false;
    } else {
      final auth = context.read<AuthController>();
      _notifications = NotificationsController(
        repository: NotificationService(context.read<ApiClient>()),
        userId: auth.userId ?? 0,
        onNewNotification: _onNewNotification,
      );
      _ownsNotifications = true;
    }

    _tabs = [
      StaffChildrenCoordinatesTab(controller: _controller),
      StaffSchoolCoordinateTab(controller: _controller),
      StaffAlertsTab(controller: _notifications),
      StaffProfileTab(controller: _controller),
    ];
    _controller.load();
    _notifications.addListener(_onNotificationsChanged);
    _notifications.start();
  }

  void _onNotificationsChanged() {
    if (mounted) setState(() {});
  }

  void _onNewNotification(NotificationModel notification) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final title = notification.isEarlyStart
        ? l10n.notificationsTripStartedEarlyTitle
        : notification.isTripStarted
        ? l10n.notificationsTripStartedTitle
        : notification.title;
    final body = notification.isTripStarted
        ? (notification.isEarlyStart
              ? l10n.notificationsTripStartedEarlyBody(
                  notification.routeName ?? l10n.driverNoRoute,
                )
              : l10n.notificationsTripStartedBody(
                  notification.routeName ?? l10n.driverNoRoute,
                ))
        : notification.body;

    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        content: Text('$title\n$body'),
        action: SnackBarAction(
          label: l10n.actionView,
          onPressed: () => setState(() => _index = 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notifications.removeListener(_onNotificationsChanged);
    _notifications.stop();
    if (_ownsNotifications) _notifications.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unread = _notifications.unreadCount;

    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.groups_outlined),
            selectedIcon: const Icon(Icons.groups),
            label: l10n.staffNavChildren,
            tooltip: l10n.staffNavChildren,
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_outlined),
            selectedIcon: const Icon(Icons.school),
            label: l10n.staffNavSchool,
            tooltip: l10n.staffNavSchool,
          ),
          NavigationDestination(
            icon: Badge.count(
              count: unread,
              isLabelVisible: unread > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: const Icon(Icons.notifications),
            label: l10n.staffNavAlerts,
            tooltip: l10n.staffNavAlerts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.staffNavProfile,
            tooltip: l10n.staffNavProfile,
          ),
        ],
      ),
    );
  }
}
