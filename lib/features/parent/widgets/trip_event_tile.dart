// TripEventTile — kadi moja ya tukio la safari (kupanda/kushuka).
//
// Inatumika kwenye historia ya mtoto na kwenye tab ya Historia.
// NOTE: inatumia DemoTripEvent kwa sasa; Phase 5 itatumia TripEvent halisi.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/l10n/app_localizations.dart';

class TripEventTile extends StatelessWidget {
  const TripEventTile({super.key, required this.event});

  final DemoTripEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    // Alama inatokana na MAANA ya kitendo (enum), si kwa kutafuta neno
    // la Kiswahili ndani ya String. Hii inafanya kazi kwa lugha zote.
    final color =
        event.action.isBoarding ? AppColors.primary : AppColors.success;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            event.action.isBoarding ? Icons.login : Icons.logout,
            color: color,
          ),
        ),
        title: Text(
          // Kitendo na siku hutafsiriwa; saa na majina haya.
          l10n.eventTitle(event.action.label(l10n), event.time),
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          l10n.eventSubtitle(
            event.date.label(l10n),
            event.place,
            event.matron,
          ),
          style: textTheme.bodySmall,
        ),
        isThreeLine: true,
      ),
    );
  }
}
