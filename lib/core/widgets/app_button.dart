// AppButton — kitufe cha kawaida cha KooBus.
//
// Kwa nini widget ya kawaida? Kila screen ingeandika:
//   FilledButton(... child: loading ? spinner : Text(...))
// Hiyo inarudiwa mara kumi, na kila mara mtu anaweza kusahau kuzima
// kitufe wakati wa loading. Hapa tunaandika mara MOJA, tunaijaribu
// mara moja, na screen zote zinapata tabia ile ile.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.expanded = true,
  });

  /// Maandishi ya kitufe (Kiswahili, kifupi, wazi).
  final String label;

  /// Kitendo kinachotokea. `null` = kitufe hakifanyi kazi (disabled).
  final VoidCallback? onPressed;

  /// `true` = onyesha spinner na zuia kubonyeza mara mbili.
  final bool loading;

  /// Icon ya hiari upande wa kushoto.
  final IconData? icon;

  /// `true` = kitufe kichukue upana kamili wa screen.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    // Muhimu: wakati wa loading, onPressed = null. Hii inazuia
    // mtumiaji kubonyeza tena na kutuma request mbili.
    final effectiveOnPressed = loading ? null : onPressed;

    final Widget content = loading
        ? const SizedBox(
            height: 20,
            width: 20,
            // Spinner ikiwa nyumbufu (primary) inaonekana hata kwenye
            // background ya kijivu ya kitufe kilichozimwa.
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          )
        : Text(label);

    // FilledButton.icon inahitaji label ndani yake; kwa hiyo
    // tunaiona tu wakati hakuna loading.
    final Widget button = (!loading && icon != null)
        ? FilledButton.icon(
            onPressed: effectiveOnPressed,
            icon: Icon(icon),
            label: content,
          )
        : FilledButton(
            onPressed: effectiveOnPressed,
            child: content,
          );

    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
