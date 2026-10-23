// DevBadge — onyo dogo linaloonyesha kuwa data ni ya MFANO.
//
// Kanuni yetu: data yoyote isiyotoka kwenye database halisi LAZIMA
// ionekane wazi kama ya majaribio. Hii inatuzuia (na mzazi) kudhani
// taarifa ni za kweli.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/l10n/app_localizations.dart';

class DevBadge extends StatelessWidget {
  const DevBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.science_outlined,
              size: 13, color: AppColors.warning),
          const SizedBox(width: 4),
          Text(
            AppLocalizations.of(context).devBadgeLabel,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}
