// StaffProfileTab — wasifu wa Matron/Patron au school admin.
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/controllers/language_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/features/auth/screens/login_screen.dart';
import 'package:koobus/features/coordinates/controllers/coordinates_controller.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/user_model.dart';

class StaffProfileTab extends StatelessWidget {
  const StaffProfileTab({super.key, required this.controller});

  final CoordinatesController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();
    final language = context.watch<LanguageController>();
    final phone = auth.session?.phone ?? '—';
    final name = auth.displayName.trim().isEmpty
        ? '—'
        : auth.displayName.trim();
    final roleLabel = _roleLabel(l10n, auth.role);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.staffNavProfile)),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final schoolName =
                controller.primarySchool?.schoolName ??
                (auth.schoolId != null
                    ? '${l10n.staffProfileSchool} #${auth.schoolId}'
                    : l10n.staffProfileNoSchool);

            return ListView(
              padding: AppSpacing.page,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.school, size: 32, color: Colors.white),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: textTheme.titleLarge),
                          const SizedBox(height: 2),
                          Text(
                            '$roleLabel - $phone',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _Section(
                  title: l10n.staffProfileSection,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          _InfoRow(label: l10n.profileFullName, value: name),
                          _InfoRow(label: l10n.loginPhoneLabel, value: phone),
                          _InfoRow(
                            label: l10n.profileAccountType,
                            value: roleLabel,
                          ),
                          _InfoRow(
                            label: l10n.staffProfileSchool,
                            value: schoolName,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _Section(
                  title: l10n.profileSettingsSection,
                  child: Card(
                    child: ListTile(
                      key: const Key('staff_language_tile'),
                      leading: const Icon(Icons.language),
                      title: Text(l10n.settingsLanguage),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_languageName(l10n, language.languageCode)),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                      onTap: () => _pickLanguage(context),
                    ),
                  ),
                ),
                Text(
                  l10n.staffProfileNotice,
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  key: const Key('staff_logout_button'),
                  label: l10n.logoutButton,
                  icon: Icons.logout,
                  onPressed: () => _confirmLogout(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _roleLabel(AppLocalizations l10n, UserRole role) {
    return switch (role) {
      UserRole.matron => l10n.roleLabelMatron,
      UserRole.schoolAdmin => l10n.roleLabelSchoolAdmin,
      UserRole.superAdmin => l10n.roleLabelSuperAdmin,
      UserRole.parent => l10n.roleLabelParent,
      UserRole.driver => l10n.roleLabelDriver,
      UserRole.unknown => l10n.roleLabelUnknown,
    };
  }

  String _languageName(AppLocalizations l10n, String code) {
    return code == AppLanguage.english
        ? l10n.languageEnglish
        : l10n.languageSwahili;
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final language = context.read<LanguageController>();
    final l10n = AppLocalizations.of(context);
    final changedMsg = l10n.languageChanged;

    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx).languageDialogTitle),
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              label: AppLocalizations.of(ctx).languageSwahili,
              selected: language.languageCode == AppLanguage.swahili,
              onTap: () => Navigator.pop(ctx, AppLanguage.swahili),
            ),
            _LanguageOption(
              label: AppLocalizations.of(ctx).languageEnglish,
              selected: language.languageCode == AppLanguage.english,
              onTap: () => Navigator.pop(ctx, AppLanguage.english),
            ),
          ],
        ),
      ),
    );

    if (selected == null || !context.mounted) return;

    await language.setLanguage(selected);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(changedMsg)));
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logoutDialogTitle),
        content: Text(l10n.logoutDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.logoutConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await context.read<AuthController>().signOut();
    if (!context.mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: textTheme.bodySmall)),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
