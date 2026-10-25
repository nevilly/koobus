// DriverStudentsTab — manifest ya wanafunzi.
//
// Hatua hii inaandaa mahali pa orodha. Hatutaweka wanafunzi wa mfano:
// orodha halisi itatoka kwenye API ya manifest/trip attendance. Hadi
// hapo, tab inaeleza wazi kwamba data bado haijaunganishwa.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/empty_state.dart';
import 'package:koobus/l10n/app_localizations.dart';

class DriverStudentsTab extends StatelessWidget {
  const DriverStudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.driverNavStudents)),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.page,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.sort_rounded, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.driverStudentsOrderNote,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.groups_outlined,
                  title: l10n.driverStudentsEmptyTitle,
                  subtitle: l10n.driverStudentsEmptySubtitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
