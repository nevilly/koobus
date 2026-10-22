// Historia ya mtoto — kila alipopanda na kushuka, saa na matron.
//
// Hii ni screen ya maelezo (detail) inayofunguliwa kutoka Watoto.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/features/parent/widgets/trip_event_tile.dart';

class ChildHistoryScreen extends StatelessWidget {
  const ChildHistoryScreen({super.key, required this.child});

  final DemoChild child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Historia ya ${child.name}')),
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
                  Text('${child.school} · ${child.className}',
                      style: textTheme.bodySmall),
                  Text('Njia: ${child.route}', style: textTheme.bodySmall),
                  Text('Matron: ${child.matron}', style: textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Shughuli za hivi karibuni', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          // Orodha ya matukio — kila tukio lina tarehe, saa, mahali na matron.
          for (final event in child.events) TripEventTile(event: event),
          const SizedBox(height: AppSpacing.md),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline,
                  size: 16, color: AppColors.textSecondary),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Taarifa hizi ni za MFANO (DEV). Historia halisi itatoka '
                  'kwenye database kupitia API (Phase 6/7).',
                  style: TextStyle(
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
