// UnsupportedRoleScreen — ukurasa wa uwazi kwa role ambazo bado
// hazijapata UI.
//
// Kanuni yetu: tusimpeleke matron/school_admin kwenye UI ya mzazi
// kana kwamba ni sawa. Badala yake tunamwambia wazi kuwa ukurasa wake
// unakuja, na tunampa njia ya kutoka.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/features/auth/screens/login_screen.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/user_model.dart';

class UnsupportedRoleScreen extends StatelessWidget {
  const UnsupportedRoleScreen({super.key});

  String _roleLabel(AppLocalizations l10n, UserRole role) {
    switch (role) {
      case UserRole.parent:
        return l10n.roleLabelParent;
      case UserRole.driver:
        return l10n.roleLabelDriver;
      case UserRole.matron:
        return l10n.roleLabelMatron;
      case UserRole.schoolAdmin:
        return l10n.roleLabelSchoolAdmin;
      case UserRole.superAdmin:
        return l10n.roleLabelSuperAdmin;
      case UserRole.unknown:
        return l10n.roleLabelUnknown;
    }
  }

  Future<void> _logout(BuildContext context, AppLocalizations l10n) async {
    await context.read<AuthController>().signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      body: Center(
        child: Padding(
          padding: AppSpacing.page,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.construction_outlined,
                size: 64,
                color: AppColors.warning,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.roleUnsupportedTitle,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.roleUnsupportedBody,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '${l10n.roleLabel}: ${_roleLabel(l10n, auth.role)}',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: l10n.logoutButton,
                icon: Icons.logout,
                onPressed: () => _logout(context, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
