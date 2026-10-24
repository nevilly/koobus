// Nyumbani (Home) — hali ya safari ya leo kwa mtazamo mmoja.
//
// Muundo umechukuliwa kutoka mockup ya Stitch: ramani juu, kadi ya ETA,
// taarifa ya basi, na uwezo wa basi. Ramani/GPS halisi ni Phase 9 —
// kwa sasa tunaonyesha eneo la "ramani" lenye rangi na onyo wazi.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/dev_badge.dart';
import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/l10n/app_localizations.dart';

class ParentHomeTab extends StatelessWidget {
  const ParentHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();
    // "mzazi" ni neno la akiba ikiwa hakuna simu — hivyo linatafsiriwa.
    final phone = auth.session?.phone ?? l10n.profileAccountTypeParent;
    final child = demoChildren.first;
    final textTheme = Theme.of(context).textTheme;

    final hasTrip = demoChildren.isNotEmpty;

    return RefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.welcomeUser(phone), style: textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(l10n.homeTodayStatus, style: textTheme.bodySmall),
                  ],
                ),
              ),
              const DevBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (!hasTrip)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Column(
                children: [
                  Icon(Icons.directions_bus_outlined,
                      size: 48, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.emptyStateNoTrips,
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.emptyStateNoTripsSubtitle,
                      style: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center),
                ],
              ),
            )
          else ...[
            _LiveTripCard(child: child),
            const SizedBox(height: AppSpacing.md),
            const _BusCard(),
            const SizedBox(height: AppSpacing.md),
            const _CapacityCard(),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.homePhaseNotice,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _LiveTripCard extends StatelessWidget {
  const _LiveTripCard({required this.child});

  final DemoChild child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias, // kata pembe za mtoto (map) kwa radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- "Ramani" ya mfano ---
          // Stack = kuweka vitu juu ya kitu kingine (map + pill + maandishi).
          SizedBox(
            height: 190,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF123A5A), Color(0xFF1E5F8A)],
                      ),
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 72,
                      color: Colors.white24,
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.sm,
                  top: AppSpacing.sm,
                  child: _StatusPill(status: child.status),
                ),
                Positioned(
                  left: AppSpacing.sm,
                  right: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  child: Text(
                    l10n.homeMapNotice,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // --- ETA ---
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.etaMinutes(5),
                        style: textTheme.headlineSmall
                            ?.copyWith(color: AppColors.primary),
                      ),
                      Text(
                        l10n.etaDistanceFrom('2.4', 'Mbezi Beach'),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.directions_bus_filled,
                      color: AppColors.primary,
                      size: 30,
                    ),
                    Text(
                      child.name.split(' ').first,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final DemoChildStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Rangi inatokana na hali: njiani = bluu, shuleni = kijani, n.k.
    final color = switch (status) {
      DemoChildStatus.onboard => AppColors.primary,
      DemoChildStatus.atSchool || DemoChildStatus.atHome => AppColors.success,
      DemoChildStatus.waiting => AppColors.warning,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.label(l10n),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BusCard extends StatelessWidget {
  const _BusCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.directions_bus, color: Colors.white),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.busCardTitle('T 123 ABC'),
                          style: textTheme.titleMedium),
                      Text(l10n.busDriver('Mwl. Hassan'),
                          style: textTheme.bodySmall),
                      Text(l10n.busMatron('Bi. Neema'),
                          style: textTheme.bodySmall),
                      Text(l10n.busRouteLabel('A — Mbezi Beach'),
                          style: textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.busCallDriverNotice,
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CapacityCard extends StatelessWidget {
  const _CapacityCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.capacityTitle,
                      style: textTheme.titleMedium),
                ),
                Text(l10n.capacityCount(15, 20), style: textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const LinearProgressIndicator(
                value: 0.75,
                minHeight: 10,
                backgroundColor: AppColors.border,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
