// Watoto — orodha ya watoto wa mzazi na hali ya kila mmoja.
//
// Gusa mtoto -> historia ya kupanda/kushuka, pamoja na matron
// aliyekuwa akimsimamia.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/features/parent/screens/child_history_screen.dart';

class ChildrenTab extends StatelessWidget {
  const ChildrenTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // ListView = orodha inayosogeza (scroll). Tunatumia `children:` kwa
    // sababu orodha ni ndogo na tayari tunayo data. Kwa orodha kubwa
    // tutatumia ListView.builder (Phase 6).
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
                  Text('Watoto wako', style: textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    'Gusa mtoto kuona historia ya kupanda na kushuka.',
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
          _ChildCard(child: child),
          const SizedBox(height: AppSpacing.md),
        ],
        Text(
          'Watoto wanaweza kuwa shule tofauti — kila mmoja ana shule, '
          'darasa na matron wake.',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({required this.child});

  final DemoChild child;

  @override
  Widget build(BuildContext context) {
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
                          '${child.school} · ${child.className}',
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
                text: 'Matron: ${child.matron}',
              ),
              const SizedBox(height: AppSpacing.sm),
              _InfoLine(
                icon: Icons.schedule,
                text: '${child.events.first.action} — ${child.events.first.time}',
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
                  label: const Text('Historia yake'),
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
        status.label,
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
