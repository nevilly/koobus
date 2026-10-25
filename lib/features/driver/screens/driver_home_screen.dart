// DriverHomeScreen — nyumbani ya dereva.
//
// Inaonyesha safari aliyopangiwa (au inayoendelea), basi, route na
// vituo, utayari wa kuanza, na vitufe vya kuanza/kumaliza safari.
//
// Data yote inatoka API. Hakuna GPS ya kufikirika na hakuna safari ya
// mfano hapa: kama server haina safari, tunaonyesha "hakuna safari".

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/core/utils/formatters.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/core/widgets/app_loader.dart';
import 'package:koobus/core/widgets/empty_state.dart';
import 'package:koobus/core/widgets/error_view.dart';
import 'package:koobus/features/auth/screens/login_screen.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/features/driver/screens/active_trip_screen.dart';
import 'package:koobus/features/driver/screens/route_details_screen.dart';
import 'package:koobus/features/driver/services/driver_service.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/trip_model.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key, this.controller});

  /// Kwa test: controller iliyotengenezwa tayari (inaweza kutumia
  /// repository ya kufikirika). Kwenye app halisi ni `null`.
  final DriverController? controller;

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  late final DriverController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();

    final provided = widget.controller;
    if (provided != null) {
      _controller = provided;
      _ownsController = false;
    } else {
      final auth = context.read<AuthController>();
      _controller = DriverController(
        repository: DriverService(context.read<ApiClient>()),
        driverId: auth.userId ?? 0,
        driverName: auth.displayName,
      );
      _ownsController = true;
    }

    _controller.load();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  String _errorText(AppLocalizations l10n) {
    final status = _controller.errorStatusCode;
    if (status == 0) return l10n.driverErrorNetwork;
    if (status == 403) return l10n.driverErrorForbidden;
    if (status == 404) return l10n.driverErrorNotFound;
    if (status == 409) return l10n.driverTripConflict;
    return l10n.driverServerError;
  }

  String _tripTypeLabel(AppLocalizations l10n, String type) {
    if (type == 'morning') return l10n.driverTripTypeMorning;
    if (type == 'afternoon') return l10n.driverTripTypeAfternoon;
    return type;
  }

  Future<void> _start() async {
    final ok = await _controller.startTrip();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.driverTripStarted : _errorText(l10n)),
      ),
    );
  }

  Future<void> _end() async {
    final ok = await _controller.endTrip();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.driverTripEnded : _errorText(l10n)),
      ),
    );
  }

  void _openStops() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RouteDetailsScreen(
          route: _controller.route,
          stops: _controller.stops,
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logoutDialogTitle),
        content: Text(l10n.logoutDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.logoutConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await context.read<AuthController>().signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.driverHomeTitle),
        actions: [
          IconButton(
            key: const Key('driver_refresh_button'),
            tooltip: l10n.actionRefresh,
            icon: const Icon(Icons.refresh),
            onPressed: _controller.busy ? null : _controller.load,
          ),
          IconButton(
            key: const Key('driver_logout_button'),
            tooltip: l10n.logoutButton,
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return RefreshIndicator(
            onRefresh: _controller.load,
            child: _body(context, l10n),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, AppLocalizations l10n) {
    switch (_controller.state) {
      case DriverViewState.loading:
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            AppLoader(message: l10n.driverLoadingTrip),
          ],
        );
      case DriverViewState.error:
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 80),
            ErrorView(
              message: _errorText(l10n),
              onRetry: _controller.load,
            ),
          ],
        );
      case DriverViewState.empty:
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 60),
            EmptyState(
              icon: Icons.event_busy_outlined,
              title: l10n.driverNoTripTitle,
              subtitle: l10n.driverNoTripSubtitle,
              actionLabel: l10n.actionRefresh,
              onAction: _controller.load,
            ),
          ],
        );
      case DriverViewState.ready:
        return _readyBody(context, l10n);
    }
  }

  Widget _readyBody(BuildContext context, AppLocalizations l10n) {
    final trip = _controller.trip!;
    final textTheme = Theme.of(context).textTheme;
    final name = _controller.driverName.trim().isEmpty
        ? '—'
        : _controller.driverName.trim();

    return ListView(
      padding: AppSpacing.page,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Text(l10n.driverGreeting(name), style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(l10n.driverHomeSubtitle, style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.md),

        _tripCard(context, l10n, trip),

        if (_controller.errorMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          _ActionError(message: _errorText(l10n)),
        ],

        const SizedBox(height: AppSpacing.md),
        _readinessCard(context, l10n, trip),
        const SizedBox(height: AppSpacing.md),

        if (trip.isActive)
          ActiveTripCard(
            trip: trip,
            busy: _controller.busy,
            onEnd: _end,
          )
        else if (trip.isPending)
          AppButton(
            key: const Key('start_trip_button'),
            label: l10n.driverStartTrip,
            icon: Icons.play_arrow,
            loading: _controller.busy,
            onPressed: _controller.canStart ? _start : null,
          )
        else
          _FinishedNote(
            message: trip.isCancelled
                ? l10n.driverTripCancelledNote
                : l10n.driverTripCompletedNote,
            cancelled: trip.isCancelled,
          ),

        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          key: const Key('view_stops_button'),
          onPressed: _openStops,
          icon: const Icon(Icons.alt_route),
          label: Text(l10n.driverViewStops),
        ),
      ],
    );
  }

  Widget _tripCard(
    BuildContext context,
    AppLocalizations l10n,
    TripModel trip,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  foregroundColor: AppColors.primary,
                  child: const Icon(Icons.directions_bus),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _controller.route?.name ?? l10n.driverNoRoute,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _controller.bus?.plateNumber ?? l10n.driverNoBus,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: trip.status, l10n: l10n),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            _InfoRow(
              icon: Icons.alt_route,
              label: l10n.driverRoute,
              value: _controller.route?.name ?? '—',
            ),
            _InfoRow(
              icon: Icons.directions_bus,
              label: l10n.driverBus,
              value: _controller.bus?.plateNumber ?? '—',
            ),
            _InfoRow(
              icon: Icons.schedule,
              label: l10n.driverTripType,
              value: _tripTypeLabel(l10n, trip.tripType),
            ),
            _InfoRow(
              icon: Icons.calendar_today,
              label: l10n.driverScheduledFor,
              value: formatDateTime(trip.createdAt),
            ),
            if (trip.startedAt != null)
              _InfoRow(
                icon: Icons.play_arrow,
                label: l10n.driverStartedAt,
                value: formatDateTime(trip.startedAt),
              ),
            if (trip.endedAt != null)
              _InfoRow(
                icon: Icons.stop,
                label: l10n.driverEndedAt,
                value: formatDateTime(trip.endedAt),
              ),
          ],
        ),
      ),
    );
  }

  Widget _readinessCard(
    BuildContext context,
    AppLocalizations l10n,
    TripModel trip,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.driverReadiness,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            _ReadinessRow(
              ok: _controller.isAssignedToMe,
              label: l10n.driverReadyDriver,
            ),
            _ReadinessRow(
              ok: _controller.hasBus,
              label: l10n.driverReadyBus,
              detail: _controller.bus?.plateNumber,
            ),
            _ReadinessRow(
              ok: _controller.hasRoute,
              label: l10n.driverReadyRoute,
              detail: _controller.route?.name,
            ),
            _ReadinessRow(
              ok: _controller.hasStops,
              label: l10n.driverReadyStops,
              detail: l10n.driverStopsCount(_controller.stops.length),
            ),
            _ReadinessRow(
              ok: _controller.canStart || trip.isActive,
              label: trip.isActive
                  ? l10n.driverReadyActive
                  : l10n.driverReadyStatus,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ReadinessRow extends StatelessWidget {
  const _ReadinessRow({
    required this.ok,
    required this.label,
    this.detail,
  });

  final bool ok;
  final String label;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: ok ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodyMedium),
                if (detail != null && detail!.trim().isNotEmpty)
                  Text(
                    detail!,
                    style: textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.l10n});

  final TripStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      TripStatus.pending => (l10n.driverStatusPending, AppColors.warning),
      TripStatus.active => (l10n.driverStatusActive, AppColors.success),
      TripStatus.completed => (l10n.driverStatusCompleted, AppColors.primary),
      TripStatus.cancelled => (l10n.driverStatusCancelled, AppColors.danger),
      TripStatus.unknown => (l10n.roleLabelUnknown, AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _ActionError extends StatelessWidget {
  const _ActionError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinishedNote extends StatelessWidget {
  const _FinishedNote({required this.message, required this.cancelled});

  final String message;
  final bool cancelled;

  @override
  Widget build(BuildContext context) {
    final color = cancelled ? AppColors.danger : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(
            cancelled ? Icons.cancel_outlined : Icons.check_circle_outline,
            color: color,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
