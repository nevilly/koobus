// ErrorView — onyesho la kawaida la kosa.
//
// Matumizi: pale request inashindikana (hakuna internet, server imelala,
// token imeisha muda). Badala ya kila screen kuandika Column yake,
// tunatumia hii — mtumiaji anaona ujumbe mmoja unaoeleweka na kitufe
// cha "Jaribu tena".

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/app_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    this.title = 'Imeshindikana',
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Ujumbe kwa mtumiaji — KISWAHILI, bila maneno ya kiufundi.
  /// Mfano: "Hakuna internet. Angalia data yako kisha ujaribu tena."
  final String message;

  final String title;

  /// Kama ni `null`, hakuna kitufe cha kujaribu tena.
  final VoidCallback? onRetry;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.page,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Jaribu tena',
                icon: Icons.refresh,
                onPressed: onRetry,
                expanded: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
