// ParentShell — "nyumba" ya mtazamo wa mzazi.
//
// Ina bottom navigation yenye tabs 5:
//   Nyumbani  — hali ya safari leo (ETA, basi)
//   Watoto    — orodha ya watoto + historia ya kupanda/kushuka
//   Historia  — safari zote za hivi karibuni
//   Taarifa   — alerts halisi kutoka notifications API
//   Wasifu    — taarifa za mzazi, walioidhinishwa, logout
//
// IndexedStack inahifadhi hali ya kila tab (scroll position n.k.) badala
// ya kuijenga upya kila tunapobadilisha tab.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/features/notifications/controllers/notifications_controller.dart';
import 'package:koobus/features/notifications/services/notification_service.dart';
import 'package:koobus/features/parent/screens/tabs/alerts_tab.dart';
import 'package:koobus/features/parent/screens/tabs/children_tab.dart';
import 'package:koobus/features/parent/screens/tabs/history_tab.dart';
import 'package:koobus/features/parent/screens/tabs/home_tab.dart';
import 'package:koobus/features/parent/screens/tabs/profile_tab.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/notification_model.dart';

class ParentShell extends StatefulWidget {
  const ParentShell({super.key, this.notificationsController});

  /// Kwa test: controller iliyotengenezwa tayari. Kwenye app halisi ni
  /// `null`; shell itaunda controller kutoka `ApiClient`.
  final NotificationsController? notificationsController;

  @override
  State<ParentShell> createState() => _ParentShellState();
}

class _ParentShellState extends State<ParentShell> {
  int _index = 0;
  late final NotificationsController _notifications;
  late final bool _ownsNotifications;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    final provided = widget.notificationsController;
    if (provided != null) {
      _notifications = provided;
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

    _tabs = <Widget>[
      const ParentHomeTab(),
      const ChildrenTab(),
      const HistoryTab(),
      AlertsTab(controller: _notifications),
      const ProfileTab(),
    ];

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
          onPressed: () => setState(() => _index = 3),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notifications.removeListener(_onNotificationsChanged);
    _notifications.stop();
    if (_ownsNotifications) _notifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unread = _notifications.unreadCount;

    // Vichwa vya AppBar kwa kila tab.
    final titles = <String>[
      l10n.appName,
      l10n.navChildren,
      l10n.navHistory,
      l10n.navAlerts,
      l10n.navProfile,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      // IndexedStack: tabs zote zipo kwenye mti, lakini moja pekee
      // inaonekana. Hii inahifadhi state (mfano scroll position).
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.navHome,
            tooltip: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.child_care_outlined),
            selectedIcon: const Icon(Icons.child_care),
            label: l10n.navChildren,
            tooltip: l10n.navChildren,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history),
            label: l10n.navHistory,
            tooltip: l10n.navHistory,
          ),
          NavigationDestination(
            icon: Badge.count(
              count: unread,
              isLabelVisible: unread > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: const Icon(Icons.notifications),
            label: l10n.navAlerts,
            tooltip: l10n.navAlerts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
            tooltip: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
