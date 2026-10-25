// DriverMapTab — ramani ya route.
//
// Hatua hii inaandaa mahali pa ramani halisi. Hatuonyeshi ramani ya
// kufikirika wala GPS ya mfano; tutaunganisha eneo halisi la basi na
// vituo baada ya kuchagua provider na kuongeza ruhusa za location.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/empty_state.dart';
import 'package:koobus/l10n/app_localizations.dart';

class DriverMapTab extends StatelessWidget {
  const DriverMapTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.driverNavMap)),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.page,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.driverSurface,
                      AppColors.driverBackground,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.route_rounded,
                      color: AppColors.accent,
                      size: 28,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.driverMapNote,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AppColors.driverOnSurface),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.map_outlined,
                  title: l10n.driverMapEmptyTitle,
                  subtitle: l10n.driverMapEmptySubtitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
