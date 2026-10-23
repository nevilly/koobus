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
import 'package:koobus/l10n/app_localizations.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Ujumbe kwa mtumiaji — tayari umetafsiriwa na screen inayotumia
  /// ErrorView. Mfano: l10n.errorNoInternet
  final String message;

  /// Kichwa cha kosa; kama ni `null` tunatumia maneno ya kawaida
  /// kutoka kamusi ("Imeshindikana").
  final String? title;

  /// Kama ni `null`, hakuna kitufe cha kujaribu tena.
  final VoidCallback? onRetry;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: AppSpacing.page,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.md),
            Text(
              title ?? l10n.errorTitle,
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
                label: l10n.actionRetry,
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
