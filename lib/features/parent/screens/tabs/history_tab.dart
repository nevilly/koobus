// Historia — safari zote za hivi karibuni kwa watoto wote.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/features/parent/widgets/trip_event_tile.dart';
import 'package:koobus/l10n/app_localizations.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final children = demoChildren;
    final hasEvents = children.any((c) => c.events.isNotEmpty);

    return RefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.historyTabTitle, style: textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      l10n.historySubtitle,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const DevBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (!hasEvents)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Column(
                children: [
                  Icon(Icons.history_outlined,
                      size: 48, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.emptyStateNoHistory,
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.emptyStateNoHistorySubtitle,
                      style: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center),
                ],
              ),
            )
          else ...[
            for (final child in children) ...[
              if (child.events.isNotEmpty) ...[
                Text(child.name, style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                for (final event in child.events) TripEventTile(event: event),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
            Text(
              l10n.historyFilterNotice,
              style: textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
