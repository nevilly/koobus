// Wasifu — taarifa za mzazi, watu waliounganishwa, watoto/shule na logout.
//
// Hapa ndipo "Toka" (logout) inapatikana. Tunathibitisha kwanza ili
// mtu asitokе kwa bahati mbaya.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/auth/screens/login_screen.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
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
                  Text('Juma Hamisi', style: textTheme.titleLarge),
                  Text('Mzazi · $phone', style: textTheme.bodySmall),
                ],
              ),
            ),
            const DevBadge(),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // --- Taarifa za mzazi ---
        _Section(
          title: 'Taarifa za mzazi',
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _InfoRow(label: 'Jina', value: 'Juma Hamisi'),
                  _InfoRow(label: 'Namba ya simu', value: phone),
                  _InfoRow(label: 'Aina ya akaunti', value: 'Mzazi'),
                  _InfoRow(label: 'Lugha', value: 'Kiswahili'),
                ],
              ),
            ),
          ),
        ),

        // --- Waliounganishwa kuchukua watoto ---
        _Section(
          title: 'Waliounganishwa kuchukua watoto',
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
                    title: Text(guardian.name,
                        style: textTheme.titleMedium),
                    subtitle: Text(
                      '${guardian.relation} · ${guardian.phone}',
                      style: textTheme.bodySmall,
                    ),
                    trailing: const Tooltip(
                      message: 'Ameidhinishwa kumchukua mtoto',
                      child: Icon(Icons.verified_user,
                          size: 18, color: AppColors.success),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                  child: Text(
                    'Wewe pekee unaweza kuongeza au kuondoa watu hawa. '
                    'Usimamizi halisi ni Phase 8.',
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- Watoto na shule ---
        _Section(
          title: 'Watoto na shule',
          child: Card(
            child: Column(
              children: [
                for (final child in demoChildren)
                  ListTile(
                    leading: const Icon(Icons.school_outlined,
                        color: AppColors.primary),
                    title: Text(child.name, style: textTheme.titleMedium),
                    subtitle: Text(
                      '${child.school} · ${child.className}',
                      style: textTheme.bodySmall,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                  child: Text(
                    'Watoto wanaweza kuwa shule tofauti. Kila mtoto ana '
                    'matron na njia yake.',
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- Mipangilio ---
        _Section(
          title: 'Mipangilio',
          child: Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Lugha'),
                  trailing: const Text('Kiswahili'),
                  onTap: null,
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text('Taarifa za push'),
                  subtitle: Text('Zitakuja Phase 10'),
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
          label: 'Toka kwenye akaunti',
          icon: Icons.logout,
          onPressed: () => _confirmLogout(context),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Ukitoka, session itafutwa kwenye kifaa hiki na utahitaji '
          'kuingia tena.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall,
        ),
      ],
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Toka?'),
        content: const Text(
          'Ukitoka, utahitaji kuingia tena kwenye kifaa hiki.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Bado'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ndiyo, toka'),
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
