// DriverHomeScreen — nyumbani ya dereva.
//
// Inaonyesha safari aliyopangiwa (au inayoendelea), basi, route na
// vituo, utayari wa kuanza, na vitufe vya kuanza/kumaliza safari.
//
// Data yote inatoka API. Hakuna GPS ya kufikirika na hakuna safari ya
// mfano hapa: kama server haina safari, tunaonyesha "hakuna safari".

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/core/utils/formatters.dart';
import 'package:koobus/core/widgets/app_loader.dart';
import 'package:koobus/core/widgets/empty_state.dart';
import 'package:koobus/core/widgets/error_view.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/features/driver/screens/active_trip_screen.dart';
import 'package:koobus/features/driver/screens/route_details_screen.dart';
import 'package:koobus/features/driver/services/driver_service.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/trip_model.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({
    super.key,
    this.controller,
    this.enableScheduleTicker = true,
  });

  /// Kwa test: controller iliyotengenezwa tayari (inaweza kutumia
  /// repository ya kufikirika). Kwenye app halisi ni `null`.
  final DriverController? controller;

  /// Timer ya countdown/tahadhari. Test zinaweza kuzima ili timer
  /// isibaki baada ya widget kupotea.
  final bool enableScheduleTicker;

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  late final DriverController _controller;
  late final bool _ownsController;
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Timer ndogo kwa countdown na tahadhari ya muda wa safari.
  Timer? _clockTimer;

  /// Safari ambazo tumeshaonyesha tahadhari ya muda; zisirudiwe kila sekunde.
  final Set<int> _scheduleAlertedTripIds = <int>{};

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

    _controller.addListener(_onControllerChanged);
    _controller.load();
    _ensureScheduleTimer();
  }

  void _onControllerChanged() {
    _ensureScheduleTimer();
    _maybeAlertScheduledTime();
  }

  /// Timer inaanza tu kama safari ina ratiba; safari zisizo na ratiba
  /// hazihitaji countdown wala tahadhari.
  void _ensureScheduleTimer() {
    if (!widget.enableScheduleTicker) return;
    if (_clockTimer != null) return;
    if (_controller.trip?.hasScheduledTime != true) return;
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      setState(() {});
      _maybeAlertScheduledTime();
    });
  }

  /// Tahadhari ya muda halisi wa safari: dereva asikose kuanza.
  void _maybeAlertScheduledTime() {
    if (!mounted) return;
    final trip = _controller.trip;
    if (trip == null || !trip.isPending) return;
    if (!trip.scheduledTimeReachedAt(_controller.now)) return;
    if (_scheduleAlertedTripIds.contains(trip.id)) return;
    _scheduleAlertedTripIds.add(trip.id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.alert);
      _messengerKey.currentState?.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          content: Text(l10n.driverScheduleAlert),
          action: SnackBarAction(
            label: l10n.driverStartTrip,
            onPressed: () {
              if (_controller.canStart) _start();
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _controller.removeListener(_onControllerChanged);
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
    _messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(ok ? l10n.driverTripStarted : _errorText(l10n))),
    );
  }

  Future<void> _startEmergency() async {
    final trip = _controller.trip;
    if (trip == null) return;

    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _EmergencyStartDialog(
        scheduledAt: trip.scheduledAt,
        windowAt: trip.startWindowAt,
      ),
    );
    if (reason == null || !mounted) return;

    final ok = await _controller.startTrip(emergency: true, reason: reason);
    if (!mounted) return;
    final currentL10n = AppLocalizations.of(context);
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          ok ? currentL10n.driverEmergencyStarted : _errorText(currentL10n),
        ),
      ),
    );
    if (ok) {
      // Safari ya dharura imerekodiwa; tahadhari ya muda haihitajiki tena.
      _scheduleAlertedTripIds.add(trip.id);
    }
  }

  Future<void> _end() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.driverEndTripDialogTitle),
        content: Text(l10n.driverEndTripDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.driverEndTripCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.driverEndTripConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final ok = await _controller.endTrip();
    if (!mounted) return;
    final currentL10n = AppLocalizations.of(context);
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          ok ? currentL10n.driverTripEnded : _errorText(currentL10n),
        ),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ScaffoldMessenger(
          key: _messengerKey,
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.driverHomeTitle),
              actions: [
                IconButton(
                  key: const Key('driver_refresh_button'),
                  tooltip: l10n.actionRefresh,
                  icon: const Icon(Icons.refresh),
                  onPressed: _controller.busy ? null : _controller.load,
                ),
              ],
            ),
            body: SafeArea(
              top: false,
              child: RefreshIndicator(
                onRefresh: _controller.load,
                child: _body(context, l10n),
              ),
            ),
            // Start/End route haipaswi kufichwa ndani ya scroll. Action bar
            // hii inakaa juu ya bottom navigation ya DriverShell.
            bottomNavigationBar: _stickyActionBar(context, l10n),
          ),
        );
      },
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
            ErrorView(message: _errorText(l10n), onRetry: _controller.load),
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
    final nextStop = _controller.stops.isEmpty
        ? l10n.driverNoNextStop
        : _controller.stops.first.name;

    return ListView(
      padding: AppSpacing.page,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Text(l10n.driverGreeting(name), style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(l10n.driverHomeSubtitle, style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.md),

        _tripHero(context, l10n, trip, nextStop),

        if (trip.isPending) ...[
          const SizedBox(height: AppSpacing.md),
          _scheduleCard(context, l10n, trip),
        ],

        if (_controller.errorMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          _ActionError(message: _errorText(l10n)),
        ],

        const SizedBox(height: AppSpacing.md),
        _readinessCard(context, l10n, trip),
        const SizedBox(height: AppSpacing.md),

        if (trip.isActive)
          ActiveTripCard(trip: trip, busy: _controller.busy)
        else if (!trip.isPending)
          _FinishedNote(
            message: trip.isCancelled
                ? l10n.driverTripCancelledNote
                : l10n.driverTripCompletedNote,
            cancelled: trip.isCancelled,
          ),

        _tripTimesCard(context, l10n, trip),

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

  /// Action bar ya kuanza/kumaliza safari.
  ///
  /// Iko kwenye `bottomNavigationBar` ya Scaffold hii, hivyo haitoweki
  /// ndani ya list na inabaki juu ya bottom navigation ya DriverShell.
  Widget _stickyActionBar(BuildContext context, AppLocalizations l10n) {
    if (_controller.state != DriverViewState.ready) {
      return const SizedBox.shrink();
    }

    final trip = _controller.trip;
    if (trip == null) return const SizedBox.shrink();

    if (trip.isPending) {
      final statusText = !_controller.hasSchedule
          ? l10n.driverStatusPending
          : _controller.isScheduledTimeReached
          ? l10n.driverScheduleDueStatus
          : _controller.isStartWindowOpen
          ? l10n.driverStartWindowOpenStatus
          : l10n.driverStartWindowLockedStatus(
              _durationLabel(
                l10n,
                _controller.timeUntilStartWindow ?? Duration.zero,
              ),
            );

      return _DriverActionBar(
        buttonKey: const Key('start_trip_button'),
        buttonLabel: l10n.driverStartTrip,
        buttonIcon: Icons.play_arrow_rounded,
        buttonColor: AppColors.success,
        statusText: statusText,
        loading: _controller.busy,
        onPressed: _controller.canStart ? _start : null,
        secondaryKey: const Key('emergency_start_button'),
        secondaryLabel: _controller.canEmergencyStart
            ? l10n.driverEmergencyStart
            : null,
        onSecondaryPressed: _controller.canEmergencyStart
            ? _startEmergency
            : null,
      );
    }

    if (trip.isActive) {
      return _DriverActionBar(
        buttonKey: const Key('end_trip_button'),
        buttonLabel: l10n.driverEndTrip,
        buttonIcon: Icons.stop_circle_outlined,
        buttonColor: AppColors.danger,
        statusText: l10n.driverStatusActive,
        loading: _controller.busy,
        onPressed: _controller.canEnd ? _end : null,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _tripHero(
    BuildContext context,
    AppLocalizations l10n,
    TripModel trip,
    String nextStop,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final routeName = _controller.route?.name ?? l10n.driverNoRoute;
    final plate = _controller.bus?.plateNumber ?? l10n.driverNoBus;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.driverSurface, AppColors.driverBackground],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg + 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -28,
            child: Icon(
              Icons.route_rounded,
              size: 190,
              color: Colors.white.withValues(alpha: 0.035),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: const Icon(
                        Icons.directions_bus,
                        color: AppColors.driverOnSurface,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            routeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.driverOnSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.driverOnSurfaceMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _StatusChip(status: trip.status, l10n: l10n),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.driverNextStop,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.driverOnSurfaceMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.flag_rounded,
                      size: 20,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        nextStop,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.driverOnSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _HeroStat(
                        icon: Icons.alt_route,
                        label: l10n.driverStopsShort,
                        value: '${_controller.stops.length}',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _HeroStat(
                        icon: Icons.schedule,
                        label: l10n.driverTripTypeShort,
                        value: _tripTypeLabel(l10n, trip.tripType),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _HeroStat(
                        icon: Icons.directions_bus,
                        label: l10n.driverBus,
                        value: plate,
                      ),
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

  String _durationLabel(AppLocalizations l10n, Duration duration) {
    final totalMinutes = duration.inMinutes < 0 ? 0 : duration.inMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return l10n.driverDurationHoursMinutes(hours, minutes);
    }
    if (hours > 0) return l10n.driverDurationHours(hours);
    return l10n.driverDurationMinutes(minutes);
  }

  Widget _scheduleCard(
    BuildContext context,
    AppLocalizations l10n,
    TripModel trip,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final scheduled = trip.scheduledAt;
    final window = trip.startWindowAt;

    if (scheduled == null || window == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.warning),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.driverNoScheduleTitle,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(l10n.driverNoScheduleBody, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final reached = _controller.isScheduledTimeReached;
    final open = _controller.isStartWindowOpen;
    final color = reached
        ? AppColors.danger
        : open
        ? AppColors.success
        : AppColors.warning;
    final title = reached
        ? l10n.driverScheduleReachedTitle
        : open
        ? l10n.driverScheduleWindowOpenTitle
        : l10n.driverScheduleLockedTitle;
    final body = reached
        ? l10n.driverScheduleReachedBody(formatDateTime(scheduled))
        : open
        ? l10n.driverScheduleWindowOpenBody(formatDateTime(scheduled))
        : l10n.driverScheduleLockedBody(
            formatDateTime(window),
            _durationLabel(
              l10n,
              _controller.timeUntilStartWindow ?? Duration.zero,
            ),
          );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                reached
                    ? Icons.notifications_active
                    : open
                    ? Icons.lock_open
                    : Icons.lock_clock,
                color: color,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(color: color),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(body, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          if (!open) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.driverEmergencyHint,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tripTimesCard(
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
              l10n.driverTripDetails,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Icons.calendar_today,
              label: l10n.driverScheduledFor,
              value: formatDateTime(trip.scheduledAt ?? trip.createdAt),
            ),
            if (trip.isPending && trip.startWindowAt != null)
              _InfoRow(
                icon: Icons.lock_open,
                label: l10n.driverStartWindowAt,
                value: formatDateTime(trip.startWindowAt),
              ),
            if (trip.startedEarly)
              _InfoRow(
                icon: Icons.bolt,
                label: l10n.driverEarlyStartLabel,
                value: trip.earlyStartReason ?? l10n.driverEarlyStartNoReason,
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

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.driverOnSurfaceMuted),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.driverOnSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.driverOnSurfaceMuted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverActionBar extends StatelessWidget {
  const _DriverActionBar({
    required this.buttonKey,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.buttonColor,
    required this.statusText,
    required this.loading,
    required this.onPressed,
    this.secondaryKey,
    this.secondaryLabel,
    this.onSecondaryPressed,
  });

  final Key buttonKey;
  final String buttonLabel;
  final IconData buttonIcon;
  final Color buttonColor;
  final String statusText;
  final bool loading;
  final VoidCallback? onPressed;
  final Key? secondaryKey;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.surface,
      elevation: 12,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        statusText,
                        style: textTheme.bodySmall?.copyWith(
                          color: buttonColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: FilledButton.icon(
                    key: buttonKey,
                    style: FilledButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: buttonColor.withValues(
                        alpha: 0.55,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: loading ? null : onPressed,
                    icon: loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(buttonIcon, size: 24),
                    label: Text(buttonLabel),
                  ),
                ),
                if (secondaryLabel != null && onSecondaryPressed != null) ...[
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton.icon(
                      key: secondaryKey,
                      onPressed: loading ? null : onSecondaryPressed,
                      icon: const Icon(Icons.bolt, size: 20),
                      label: Text(secondaryLabel!),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
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
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ReadinessRow extends StatelessWidget {
  const _ReadinessRow({required this.ok, required this.label, this.detail});

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
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
              style: Theme.of(context).textTheme.bodySmall
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
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog ya kuanza kwa dharura.
///
/// Sababu ni lazima ili server irekodi ni kwa nini safari ilianza kabla
/// ya dirisha la saa moja. Hii inalinda shule na dereva.
class _EmergencyStartDialog extends StatefulWidget {
  const _EmergencyStartDialog({
    required this.scheduledAt,
    required this.windowAt,
  });

  final DateTime? scheduledAt;
  final DateTime? windowAt;

  @override
  State<_EmergencyStartDialog> createState() => _EmergencyStartDialogState();
}

class _EmergencyStartDialogState extends State<_EmergencyStartDialog> {
  final TextEditingController _reasonController = TextEditingController();
  String _reason = '';

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      icon: const Icon(Icons.bolt, color: AppColors.warning),
      title: Text(l10n.driverEmergencyDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.driverEmergencyDialogBody),
            const SizedBox(height: AppSpacing.sm),
            if (widget.scheduledAt != null)
              Text(
                l10n.driverEmergencyScheduled(
                  formatDateTime(widget.scheduledAt),
                ),
              ),
            if (widget.windowAt != null)
              Text(l10n.driverEmergencyWindow(formatDateTime(widget.windowAt))),
            const SizedBox(height: AppSpacing.md),
            TextField(
              key: const Key('emergency_reason_field'),
              controller: _reasonController,
              autofocus: true,
              maxLength: 160,
              minLines: 2,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.driverEmergencyReasonLabel,
                hintText: l10n.driverEmergencyReasonHint,
              ),
              onChanged: (value) {
                final trimmed = value.trim();
                if (trimmed == _reason) return;
                setState(() => _reason = trimmed);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.driverEmergencyCancel),
        ),
        FilledButton.icon(
          key: const Key('confirm_emergency_start_button'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
          onPressed: _reason.isEmpty
              ? null
              : () => Navigator.of(context).pop(_reason),
          icon: const Icon(Icons.bolt),
          label: Text(l10n.driverEmergencyConfirm),
        ),
      ],
    );
  }
}
