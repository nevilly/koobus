// ActiveTripCard — kadi ya safari inayoendelea.
//
// Hii ni sehemu ya DriverHomeScreen (si route tofauti) kwa sababu
// inahitaji controller moja: muda wa kuanza, hali, na kitendo cha
// kumaliza safari.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/utils/formatters.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/trip_model.dart';

class ActiveTripCard extends StatelessWidget {
  const ActiveTripCard({
    super.key,
    required this.trip,
    required this.busy,
    this.onEnd,
  });

  final TripModel trip;
  final bool busy;
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.play_circle_fill, color: AppColors.success),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.driverStatusActive,
                  style: textTheme.titleMedium
                      ?.copyWith(color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${l10n.driverStartedAt}: ${formatDateTime(trip.startedAt)}',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: l10n.driverEndTrip,
            icon: Icons.stop_circle_outlined,
            loading: busy,
            onPressed: busy ? null : onEnd,
          ),
        ],
      ),
    );
  }
}
