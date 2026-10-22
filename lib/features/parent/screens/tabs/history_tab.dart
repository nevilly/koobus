// Historia — safari zote za hivi karibuni kwa watoto wote.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/features/parent/widgets/trip_event_tile.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text('Historia ya safari', style: textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    'Kila kupanda na kushuka kunahifadhiwa saa na matron.',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const DevBadge(),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (final child in demoChildren) ...[
          Text(child.name, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final event in child.events) TripEventTile(event: event),
          const SizedBox(height: AppSpacing.md),
        ],
        Text(
          'Vichujio vya tarehe/shule na historia kamili ni Phase 9.',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}
