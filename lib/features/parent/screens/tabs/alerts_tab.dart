// Taarifa — notifications za basi kwa mzazi.
//
// Phase 10 itaunganisha FCM (push notifications) na backend. Kwa sasa
// tunaonyesha taarifa za MFANO zenye alama ya DEV.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/l10n/app_localizations.dart';

class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kichwa hiki ni sawa na jina la tab; linatoka kamusi.
                  Text(l10n.alertsTabTitle, style: textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    l10n.alertsSubtitle,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const DevBadge(),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // NOTE: sentensi za taarifa (title/message/time) bado ni za MFANO
        // kwa Kiswahili — zitakuja kutoka server (templates) Phase 10.
        for (final alert in demoAlerts) _AlertCard(alert: alert),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.alertsPushNotice,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final DemoAlert alert;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: const Icon(
            Icons.notifications_active_outlined,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          alert.title,
          style: textTheme.titleMedium?.copyWith(
            // Taarifa ambayo haijasomwa inaandikwa kwa herufi nzito.
            fontWeight: alert.read ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        subtitle: Text(
          '${alert.message}\n${alert.time}',
          style: textTheme.bodySmall,
        ),
        isThreeLine: true,
        trailing: alert.read
            ? null
            : Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }
}
