// Taarifa — taarifa halisi za basi kwa mzazi.
//
// Data inatoka `notifications` API. Push ya mbali (FCM) bado haijawekwa;
// app inapoll kila sekunde 30 ikiwa wazi, na hii inaonyeshwa kwa uwazi.

import 'package:flutter/material.dart';

import 'package:koobus/features/notifications/controllers/notifications_controller.dart';
import 'package:koobus/features/notifications/widgets/notification_feed.dart';
import 'package:koobus/l10n/app_localizations.dart';

class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key, required this.controller});

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    return NotificationFeed(
      controller: controller,
      header: _AlertsHeader(controller: controller),
    );
  }
}

class _AlertsHeader extends StatelessWidget {
  const _AlertsHeader({required this.controller});

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final unread = controller.unreadCount;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.alertsTabTitle, style: textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(l10n.alertsSubtitle, style: textTheme.bodySmall),
                  if (unread > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.notificationsUnread(unread),
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            TextButton.icon(
              onPressed: controller.hasUnread && !controller.busy
                  ? controller.markAllRead
                  : null,
              icon: const Icon(Icons.done_all, size: 18),
              label: Text(l10n.notificationsMarkAll),
            ),
          ],
        );
      },
    );
  }
}
