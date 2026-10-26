// NotificationFeed — orodha ya taarifa halisi zinazotumika kwa mzazi na staff.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/utils/formatters.dart';
import 'package:koobus/core/widgets/app_loader.dart';
import 'package:koobus/core/widgets/error_view.dart';
import 'package:koobus/features/notifications/controllers/notifications_controller.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/notification_model.dart';

class NotificationFeed extends StatelessWidget {
  const NotificationFeed({
    super.key,
    required this.controller,
    this.header,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final NotificationsController controller;
  final Widget? header;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.state == NotificationsViewState.loading) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            children: [
              if (header != null) ...[
                header!,
                const SizedBox(height: AppSpacing.md),
              ],
              const SizedBox(height: 80),
              AppLoader(message: l10n.notificationsLoading),
            ],
          );
        }

        if (controller.state == NotificationsViewState.error) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            children: [
              if (header != null) ...[
                header!,
                const SizedBox(height: AppSpacing.md),
              ],
              const SizedBox(height: 50),
              ErrorView(
                message: l10n.notificationsLoadError,
                onRetry: controller.load,
              ),
            ],
          );
        }

        final items = controller.items;
        return RefreshIndicator(
          onRefresh: () => controller.load(showSpinner: false),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            children: [
              if (header != null) ...[
                header!,
                const SizedBox(height: AppSpacing.md),
              ],
              if (items.isEmpty)
                _EmptyNotifications(l10n: l10n)
              else ...[
                for (final item in items)
                  _NotificationCard(
                    notification: item,
                    onTap: () => controller.markRead(item),
                  ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.notificationsInAppNotice,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.emptyStateNoAlerts,
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.emptyStateNoAlertsSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final color = notification.isEarlyStart
        ? AppColors.warning
        : AppColors.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: notification.isUnread ? onTap : null,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            notification.isTripStarted
                ? Icons.directions_bus_outlined
                : Icons.notifications_active_outlined,
            color: color,
          ),
        ),
        title: Text(
          _title(l10n, notification),
          style: textTheme.titleMedium?.copyWith(
            fontWeight: notification.isUnread
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${_body(l10n, notification)}\n${formatDateTime(notification.createdAt)}',
          style: textTheme.bodySmall,
        ),
        isThreeLine: true,
        trailing: notification.isUnread
            ? Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }

  String _title(AppLocalizations l10n, NotificationModel notification) {
    if (notification.isEarlyStart) {
      return l10n.notificationsTripStartedEarlyTitle;
    }
    if (notification.isTripStarted) {
      return l10n.notificationsTripStartedTitle;
    }
    return notification.title;
  }

  String _body(AppLocalizations l10n, NotificationModel notification) {
    if (notification.isTripStarted) {
      final route = notification.routeName ?? l10n.driverNoRoute;
      return notification.isEarlyStart
          ? l10n.notificationsTripStartedEarlyBody(route)
          : l10n.notificationsTripStartedBody(route);
    }
    return notification.body;
  }
}
