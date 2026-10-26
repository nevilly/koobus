// StaffAlertsTab — taarifa za shule/Matron/Patron kuhusu safari.

import 'package:flutter/material.dart';

import 'package:koobus/features/notifications/controllers/notifications_controller.dart';
import 'package:koobus/features/notifications/widgets/notification_feed.dart';
import 'package:koobus/l10n/app_localizations.dart';

class StaffAlertsTab extends StatelessWidget {
  const StaffAlertsTab({super.key, required this.controller});

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navAlerts)),
      body: NotificationFeed(
        controller: controller,
        header: Text(
          l10n.alertsSubtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
