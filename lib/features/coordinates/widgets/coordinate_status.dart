// Vipengele vya kuonyesha hali ya uthibitisho wa nafasi.
import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/coordinate_model.dart';

class CoordinateStatusSummary extends StatelessWidget {
  const CoordinateStatusSummary({super.key, required this.coordinate});

  final CoordinateModel? coordinate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final coordinate = this.coordinate;

    final (label, color) = switch (coordinate) {
      null => (l10n.coordinatesNoCoordinate, AppColors.textSecondary),
      CoordinateModel(isValid: true) => (
        l10n.coordinatesValid,
        AppColors.success,
      ),
      CoordinateModel(parentConfirmed: true) => (
        l10n.coordinatesWaitingSchool,
        AppColors.warning,
      ),
      CoordinateModel(schoolConfirmed: true) => (
        l10n.coordinatesWaitingParent,
        AppColors.warning,
      ),
      _ => (l10n.coordinatesNoCoordinate, AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class CoordinateStatusChips extends StatelessWidget {
  const CoordinateStatusChips({super.key, required this.coordinate});

  final CoordinateModel? coordinate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final coordinate = this.coordinate;
    if (coordinate == null) {
      return _StatusChip(
        icon: Icons.location_off_outlined,
        label: l10n.coordinatesNoCoordinate,
        color: AppColors.textSecondary,
      );
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _StatusChip(
          icon: coordinate.parentConfirmed
              ? Icons.verified
              : Icons.pending_outlined,
          label: coordinate.parentConfirmed
              ? l10n.coordinatesParentConfirmed
              : l10n.coordinatesWaitingParent,
          color: coordinate.parentConfirmed
              ? AppColors.success
              : AppColors.warning,
        ),
        _StatusChip(
          icon: coordinate.schoolConfirmed
              ? Icons.verified
              : Icons.pending_outlined,
          label: coordinate.schoolConfirmed
              ? l10n.coordinatesSchoolConfirmed
              : l10n.coordinatesWaitingSchool,
          color: coordinate.schoolConfirmed
              ? AppColors.success
              : AppColors.warning,
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
