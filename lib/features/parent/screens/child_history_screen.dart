// Historia ya mtoto — kila alipopanda na kushuka, saa na matron.
//
// Hii ni screen ya maelezo (detail) inayofunguliwa kutoka Watoto.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/features/parent/widgets/trip_event_tile.dart';
import 'package:koobus/l10n/app_localizations.dart';

class ChildHistoryScreen extends StatelessWidget {
  const ChildHistoryScreen({super.key, required this.child});

  final DemoChild child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.childHistoryTitle(child.name))),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(child.name, style: textTheme.titleMedium),
                      ),
                      const DevBadge(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.childSchoolClass(child.school, child.className),
                    style: textTheme.bodySmall,
                  ),
                  Text(l10n.childRouteLabel(child.route),
                      style: textTheme.bodySmall),
                  Text(l10n.busMatron(child.matron),
                      style: textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.childRecentActivity, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          // Orodha ya matukio — kila tukio lina tarehe, saa, mahali na matron.
          for (final event in child.events) TripEventTile(event: event),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.childHistoryDevNotice,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
