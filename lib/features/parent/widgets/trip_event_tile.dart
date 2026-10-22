// TripEventTile — kadi moja ya tukio la safari (kupanda/kushuka).
//
// Inatumika kwenye historia ya mtoto na kwenye tab ya Historia.
// NOTE: inatumia DemoTripEvent kwa sasa; Phase 5 itatumia TripEvent halisi.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';

class TripEventTile extends StatelessWidget {
  const TripEventTile({super.key, required this.event});

  final DemoTripEvent event;

  @override
  Widget build(BuildContext context) {
    final isBoarding = event.action.toLowerCase().contains('panda');
    final color = isBoarding ? AppColors.primary : AppColors.success;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            isBoarding ? Icons.login : Icons.logout,
            color: color,
          ),
        ),
        title: Text(
          '${event.action} — ${event.time}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '${event.date} · ${event.place}\nMatron: ${event.matron}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        isThreeLine: true,
      ),
    );
  }
}
