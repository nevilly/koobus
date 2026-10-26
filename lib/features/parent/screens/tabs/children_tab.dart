// Watoto — orodha ya watoto wa mzazi na hali ya kila mmoja.
//
// Gusa mtoto -> historia ya kupanda/kushuka, pamoja na matron
// aliyekuwa akimsimamia.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/coordinates/screens/parent_coordinates_screen.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/features/parent/screens/child_history_screen.dart';
import 'package:koobus/l10n/app_localizations.dart';

class ChildrenTab extends StatelessWidget {
  const ChildrenTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final children = demoChildren;

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
                    Text(l10n.childrenTitle, style: textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      l10n.childrenSubtitle,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const DevBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _CoordinatesEntryCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ParentCoordinatesScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          if (children.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Column(
                children: [
                  Icon(Icons.child_care_outlined,
                      size: 48, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.emptyStateNoChildren,
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.emptyStateNoChildrenSubtitle,
                      style: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center),
                ],
              ),
            )
          else ...[
            for (final child in children) ...[
              _ChildCard(child: child),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(
              l10n.childrenMultipleSchoolsNotice,
              style: textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _CoordinatesEntryCard extends StatelessWidget {
  const _CoordinatesEntryCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const Key('parent_coordinates_entry'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: const Icon(Icons.my_location, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.coordinatesParentEntryTitle,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.coordinatesParentEntryBody,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({required this.child});

  final DemoChild child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChildHistoryScreen(child: child),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: Text(
                      _initials(child.name),
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
                        Text(child.name, style: textTheme.titleMedium),
                        Text(
                          l10n.childSchoolClass(child.school, child.className),
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  _ChildStatusChip(status: child.status),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              _InfoLine(icon: Icons.alt_route, text: child.route),
              const SizedBox(height: AppSpacing.sm),
              _InfoLine(
                icon: Icons.supervisor_account_outlined,
                text: l10n.busMatron(child.matron),
              ),
              const SizedBox(height: AppSpacing.sm),
              _InfoLine(
                icon: Icons.schedule,
                text: l10n.eventTitle(
                  child.events.first.action.label(l10n),
                  child.events.first.time,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChildHistoryScreen(child: child),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history, size: 18),
                  label: Text(l10n.childrenHistoryButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class _ChildStatusChip extends StatelessWidget {
  const _ChildStatusChip({required this.status});

  final DemoChildStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final color = switch (status) {
      DemoChildStatus.onboard => AppColors.primary,
      DemoChildStatus.atSchool || DemoChildStatus.atHome => AppColors.success,
      DemoChildStatus.waiting => AppColors.warning,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label(l10n),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
