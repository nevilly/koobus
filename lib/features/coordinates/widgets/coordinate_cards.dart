// Kadi za nafasi zinazotumika kwa mzazi na wafanyakazi wa shule.
import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/coordinate_model.dart';

import 'coordinate_status.dart';

class ChildCoordinateCard extends StatelessWidget {
  const ChildCoordinateCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onConfirm,
    required this.canConfirm,
    this.busy = false,
    this.showSchool = true,
  });

  final ChildCoordinateEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onConfirm;
  final bool canConfirm;
  final bool busy;
  final bool showSchool;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final coordinate = entry.coordinate;
    final subtitle = [
      if (entry.className != null && entry.className!.trim().isNotEmpty)
        entry.className!.trim(),
      if (showSchool &&
          entry.schoolName != null &&
          entry.schoolName!.trim().isNotEmpty)
        entry.schoolName!.trim(),
    ].join(' • ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: Text(
                    _initials(entry.fullName),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.fullName, style: textTheme.titleMedium),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(subtitle, style: textTheme.bodySmall),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                CoordinateStatusSummary(coordinate: coordinate),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (coordinate == null)
              Text(
                l10n.coordinatesNoCoordinate,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            else ...[
              _CoordinateLine(
                icon: Icons.place_outlined,
                text:
                    '${coordinate.latitude.toStringAsFixed(6)}, ${coordinate.longitude.toStringAsFixed(6)}',
              ),
              if (coordinate.label != null &&
                  coordinate.label!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                _CoordinateLine(
                  icon: Icons.label_outline,
                  text: coordinate.label!.trim(),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              CoordinateStatusChips(coordinate: coordinate),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: busy ? null : onEdit,
                    icon: const Icon(
                      Icons.edit_location_alt_outlined,
                      size: 18,
                    ),
                    label: Text(
                      coordinate == null
                          ? l10n.coordinatesSet
                          : l10n.coordinatesEdit,
                    ),
                  ),
                ),
                if (canConfirm) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: busy ? null : onConfirm,
                      icon: const Icon(Icons.verified_outlined, size: 18),
                      label: Text(l10n.coordinatesConfirm),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class SchoolCoordinateCard extends StatelessWidget {
  const SchoolCoordinateCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onConfirm,
    required this.canConfirm,
    this.busy = false,
  });

  final SchoolCoordinateEntry entry;
  final VoidCallback? onEdit;
  final VoidCallback onConfirm;
  final bool canConfirm;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final coordinate = entry.coordinate;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.accent.withValues(alpha: 0.18),
                  child: const Icon(
                    Icons.school_outlined,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.schoolName, style: textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        l10n.coordinatesSchoolTitle,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                CoordinateStatusSummary(coordinate: coordinate),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (coordinate == null)
              Text(
                l10n.coordinatesSchoolNoCoordinate,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            else ...[
              _CoordinateLine(
                icon: Icons.place_outlined,
                text:
                    '${coordinate.latitude.toStringAsFixed(6)}, ${coordinate.longitude.toStringAsFixed(6)}',
              ),
              if (coordinate.label != null &&
                  coordinate.label!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                _CoordinateLine(
                  icon: Icons.label_outline,
                  text: coordinate.label!.trim(),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              CoordinateStatusChips(coordinate: coordinate),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (onEdit != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: busy ? null : onEdit,
                      icon: const Icon(
                        Icons.edit_location_alt_outlined,
                        size: 18,
                      ),
                      label: Text(
                        coordinate == null
                            ? l10n.coordinatesSet
                            : l10n.coordinatesEdit,
                      ),
                    ),
                  ),
                if (onEdit != null && canConfirm)
                  const SizedBox(width: AppSpacing.sm),
                if (canConfirm)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: busy ? null : onConfirm,
                      icon: const Icon(Icons.verified_outlined, size: 18),
                      label: Text(l10n.coordinatesConfirm),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CoordinateLine extends StatelessWidget {
  const _CoordinateLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
