// Wasifu — taarifa za mzazi, watu waliounganishwa, watoto/shule, lugha
// na logout.
//
// Hapa ndipo "Toka" (logout) inapatikana. Tunathibitisha kwanza ili
// mtu asitoke kwa bahati mbaya. Hapa pia mtumiaji anachagua LUGHA.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/controllers/language_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/auth/screens/login_screen.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/l10n/app_localizations.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();
    // Lugha ya sasa — tunaisoma ili kuonyesha jina lake kwenye safu ya Lugha.
    final language = context.watch<LanguageController>();
    final phone = auth.session?.phone ?? '—';
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // --- Kichwa cha wasifu ---
        Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 34, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Juma Hamisi" ni JINA HALISI (DEV) — halitafsiriwi.
                  Text('Juma Hamisi', style: textTheme.titleLarge),
                  Text(l10n.profileRoleSummary(phone),
                      style: textTheme.bodySmall),
                ],
              ),
            ),
            const DevBadge(),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // --- Taarifa za mzazi ---
        _Section(
          title: l10n.profileParentSection,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _InfoRow(label: l10n.profileFullName, value: 'Juma Hamisi'),
                  _InfoRow(label: l10n.loginPhoneLabel, value: phone),
                  _InfoRow(
                    label: l10n.profileAccountType,
                    value: l10n.profileAccountTypeParent,
                  ),
                  _InfoRow(
                    label: l10n.settingsLanguage,
                    value: _languageName(l10n, language.languageCode),
                  ),
                ],
              ),
            ),
          ),
        ),

        // --- Waliounganishwa kuchukua watoto ---
        _Section(
          title: l10n.profileGuardiansSection,
          trailing: const DevBadge(),
          child: Card(
            child: Column(
              children: [
                for (final guardian in demoGuardians)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          AppColors.success.withValues(alpha: 0.12),
                      child: Text(
                        guardian.name[0],
                        style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Majina ni ya kweli (DEV) — hayatafsiriwi.
                    title: Text(guardian.name,
                        style: textTheme.titleMedium),
                    subtitle: Text(
                      '${guardian.relation} · ${guardian.phone}',
                      style: textTheme.bodySmall,
                    ),
                    trailing: Tooltip(
                      message: l10n.profileGuardianApproved,
                      child: const Icon(Icons.verified_user,
                          size: 18, color: AppColors.success),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                  child: Text(
                    l10n.profileGuardiansNotice,
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- Watoto na shule ---
        _Section(
          title: l10n.profileChildrenSection,
          child: Card(
            child: Column(
              children: [
                for (final child in demoChildren)
                  ListTile(
                    leading: const Icon(Icons.school_outlined,
                        color: AppColors.primary),
                    title: Text(child.name, style: textTheme.titleMedium),
                    subtitle: Text(
                      l10n.childSchoolClass(child.school, child.className),
                      style: textTheme.bodySmall,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                  child: Text(
                    l10n.profileChildrenNotice,
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- Mipangilio ---
        _Section(
          title: l10n.profileSettingsSection,
          child: Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.settingsLanguage),
                  // Jina la lugha ya sasa linaonyeshwa hapa.
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_languageName(l10n, language.languageCode)),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                  // Gusa -> chagua lugha.
                  onTap: () => _pickLanguage(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_active_outlined),
                  title: Text(l10n.settingsNotifications),
                  subtitle: Text(l10n.settingsNotificationsSubtitle),
                  enabled: false,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // --- Logout ---
        AppButton(
          key: const Key('logout_button'),
          label: l10n.logoutButton,
          icon: Icons.logout,
          onPressed: () => _confirmLogout(context),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.logoutFootnote,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall,
        ),
      ],
    );
  }

  /// Jina la lugha kwa kuonyesha (Kiswahili / English).
  /// Hili linatoka kwenye kamusi — hivyo linaonekana sawa kwa lugha zote.
  String _languageName(AppLocalizations l10n, String code) {
    return code == AppLanguage.english
        ? l10n.languageEnglish
        : l10n.languageSwahili;
  }

  /// Fungua dialog ya kuchagua lugha.
  ///
  /// Mtumiaji anachagua; tunaita LanguageController.setLanguage — hiyo
  /// inabadilisha app YOTE papo hapo na kuhifadhi kwenye kifaa.
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
            RadioListTile<String>(
              value: AppLanguage.swahili,
              groupValue: language.languageCode,
              title: Text(AppLocalizations.of(ctx).languageSwahili),
              onChanged: (v) => Navigator.pop(ctx, v),
            ),
            RadioListTile<String>(
              value: AppLanguage.english,
              groupValue: language.languageCode,
              title: Text(AppLocalizations.of(ctx).languageEnglish),
              onChanged: (v) => Navigator.pop(ctx, v),
            ),
          ],
        ),
      ),
    );

    if (selected == null || !context.mounted) return;

    await language.setLanguage(selected);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(changedMsg)),
    );
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

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              ?trailing,
            ],
          ),
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
          SizedBox(
            width: 130,
            child: Text(label, style: textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
