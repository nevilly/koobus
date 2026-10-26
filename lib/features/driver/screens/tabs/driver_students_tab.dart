// DriverStudentsTab — manifest na mahudhurio ya wanafunzi.
//
// Orodha ni mlalo (horizontal) na inatoka kwenye API halisi ya manifest.
// Server inaipanga kwa kituo cha safari: asubuhi kwa pickup, mchana kwa
// drop-off. Hivyo dereva hapaswi kuipanga upya — nafasi ya kwanza ndiyo
// mwanafunzi anayefuata kupanda/kushuka.
//
// Hakuna wanafunzi wa mfano. Kama route haina wanafunzi, tunaonyesha
// maelezo wazi badala ya orodha ya kubuni.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/student_manifest_entry.dart';
import 'package:koobus/models/trip_model.dart';

class DriverStudentsTab extends StatelessWidget {
  const DriverStudentsTab({super.key, required this.controller});

  final DriverController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.driverBackground,
          appBar: AppBar(
            backgroundColor: AppColors.driverBackground,
            foregroundColor: AppColors.driverOnSurface,
            surfaceTintColor: Colors.transparent,
            title: Text(l10n.driverNavStudents),
            actions: [
              IconButton(
                key: const Key('manifest_refresh_button'),
                tooltip: l10n.actionRefresh,
                onPressed: controller.manifestState == ManifestViewState.loading
                    ? null
                    : (controller.trip == null
                          ? controller.load
                          : controller.loadManifest),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              color: AppColors.accent,
              backgroundColor: AppColors.driverSurface,
              onRefresh: controller.load,
              child: _body(context, l10n),
            ),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, AppLocalizations l10n) {
    if (controller.state == DriverViewState.loading &&
        controller.trip == null) {
      return _loading(l10n.driverStudentsLoading);
    }

    if (controller.state == DriverViewState.error && controller.trip == null) {
      return _verticalScroll(
        child: _DarkMessage(
          icon: Icons.error_outline_rounded,
          title: l10n.driverStudentsErrorTitle,
          message: _errorText(l10n, controller.errorStatusCode),
          actionLabel: l10n.actionRefresh,
          onAction: controller.load,
        ),
      );
    }

    final trip = controller.trip;
    if (trip == null) {
      return _verticalScroll(
        child: _DarkMessage(
          icon: Icons.event_busy_outlined,
          title: l10n.driverNoTripTitle,
          message: l10n.driverNoTripSubtitle,
          actionLabel: l10n.actionRefresh,
          onAction: controller.load,
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        _summaryCard(context, l10n, trip),
        const SizedBox(height: AppSpacing.md),
        ..._manifestContent(context, l10n, trip),
      ],
    );
  }

  List<Widget> _manifestContent(
    BuildContext context,
    AppLocalizations l10n,
    TripModel trip,
  ) {
    switch (controller.manifestState) {
      case ManifestViewState.idle:
      case ManifestViewState.loading:
        return [_loading(l10n.driverStudentsLoading)];
      case ManifestViewState.error:
        return [
          _DarkMessage(
            icon: Icons.sync_problem_rounded,
            title: l10n.driverStudentsErrorTitle,
            message: _errorText(l10n, controller.manifestStatusCode),
            actionLabel: l10n.actionRefresh,
            onAction: controller.loadManifest,
          ),
        ];
      case ManifestViewState.empty:
        return [
          _DarkMessage(
            icon: Icons.groups_outlined,
            title: l10n.driverStudentsEmptyTitle,
            message: l10n.driverStudentsEmptySubtitle,
            actionLabel: l10n.actionRefresh,
            onAction: controller.loadManifest,
          ),
        ];
      case ManifestViewState.ready:
        final entries = controller.manifest;
        final nextIndex = _nextIndex(entries, trip.tripType);
        return [
          SizedBox(
            height: 342,
            child: ListView.separated(
              key: const Key('student_manifest_list'),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                return _studentCard(
                  context,
                  l10n,
                  trip,
                  entries[index],
                  index,
                  isNext: index == nextIndex,
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.swipe_rounded,
                size: 16,
                color: AppColors.driverOnSurfaceMuted,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.driverStudentsSwipeHint,
                  style: const TextStyle(
                    color: AppColors.driverOnSurfaceMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ];
    }
  }

  Widget _summaryCard(
    BuildContext context,
    AppLocalizations l10n,
    TripModel trip,
  ) {
    final routeName = controller.route?.name ?? l10n.driverNoRoute;
    final typeLabel = trip.tripType == 'morning'
        ? l10n.driverTripTypeMorning
        : l10n.driverTripTypeAfternoon;
    final orderText = trip.tripType == 'morning'
        ? l10n.driverStudentsOrderMorning
        : l10n.driverStudentsOrderAfternoon;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.driverSurfaceLight, AppColors.driverSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg + 4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: AppColors.accent,
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
                      style: const TextStyle(
                        color: AppColors.driverOnSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      typeLabel,
                      style: const TextStyle(
                        color: AppColors.driverOnSurfaceMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  l10n.driverStudentsCount(controller.manifest.length),
                  style: const TextStyle(
                    color: AppColors.driverOnSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.sort_rounded,
                size: 18,
                color: AppColors.driverOnSurfaceMuted,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  orderText,
                  style: const TextStyle(
                    color: AppColors.driverOnSurfaceMuted,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          if (!trip.isActive) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      l10n.driverAttendancePendingNote,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _studentCard(
    BuildContext context,
    AppLocalizations l10n,
    TripModel trip,
    StudentManifestEntry entry,
    int index, {
    required bool isNext,
  }) {
    final statusColor = _statusColor(entry.attendanceStatus);
    final stopName = entry.stopNameFor(trip.tripType).trim();
    final className = entry.className.trim();
    final canRecord = trip.isActive && !controller.isMarking(entry.id);
    final marking = controller.isMarking(entry.id);

    return Container(
      key: Key('student_card_${entry.id}'),
      width: 292,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.driverSurface, AppColors.driverSurfaceLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg + 8),
        border: Border.all(color: statusColor.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              if (isNext)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    trip.tripType == 'morning'
                        ? l10n.driverStudentsFirstOn
                        : l10n.driverStudentsFirstOff,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  entry.initials,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.driverOnSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      className.isEmpty
                          ? '—'
                          : '${l10n.driverStudentsClass}: $className',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.driverOnSurfaceMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: AppColors.driverOnSurfaceMuted,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.driverStudentsStop,
                        style: const TextStyle(
                          color: AppColors.driverOnSurfaceMuted,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        stopName.isEmpty ? l10n.driverStudentsNoStop : stopName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: stopName.isEmpty
                              ? AppColors.driverOnSurfaceMuted
                              : AppColors.driverOnSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _StatusChip(
            label: _statusLabel(l10n, entry.attendanceStatus),
            color: statusColor,
          ),
          const Spacer(),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton.icon(
              key: Key('attendance_button_${entry.id}'),
              onPressed: canRecord
                  ? () => _openAttendanceSheet(context, l10n, trip, entry)
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.driverBackground,
                disabledBackgroundColor: AppColors.driverSurfaceLight,
                disabledForegroundColor: AppColors.driverOnSurfaceMuted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              icon: marking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.fact_check_outlined, size: 18),
              label: Text(
                entry.hasAttendance
                    ? l10n.driverAttendanceChange
                    : l10n.driverAttendanceRecord,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAttendanceSheet(
    BuildContext context,
    AppLocalizations l10n,
    TripModel trip,
    StudentManifestEntry entry,
  ) async {
    final action = await showModalBottomSheet<TripAttendanceAction>(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.driverSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.driverAttendanceSheetTitle(entry.fullName),
                style: const TextStyle(
                  color: AppColors.driverOnSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                entry.stopNameFor(trip.tripType).trim().isEmpty
                    ? l10n.driverStudentsNoStop
                    : entry.stopNameFor(trip.tripType),
                style: const TextStyle(
                  color: AppColors.driverOnSurfaceMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _AttendanceOption(
                key: const Key('attendance_option_board'),
                icon: Icons.directions_bus_filled_outlined,
                label: l10n.driverAttendanceBoarded,
                selected:
                    entry.attendanceStatus == TripAttendanceStatus.boarded,
                onTap: () =>
                    Navigator.of(sheetContext).pop(TripAttendanceAction.board),
              ),
              _AttendanceOption(
                key: const Key('attendance_option_alight'),
                icon: Icons.logout_rounded,
                label: l10n.driverAttendanceAlighted,
                selected:
                    entry.attendanceStatus == TripAttendanceStatus.alighted,
                onTap: () =>
                    Navigator.of(sheetContext).pop(TripAttendanceAction.alight),
              ),
              _AttendanceOption(
                key: const Key('attendance_option_absent'),
                icon: Icons.person_off_outlined,
                label: l10n.driverAttendanceAbsent,
                selected: entry.attendanceStatus == TripAttendanceStatus.absent,
                onTap: () =>
                    Navigator.of(sheetContext).pop(TripAttendanceAction.absent),
              ),
              _AttendanceOption(
                key: const Key('attendance_option_excused'),
                icon: Icons.assignment_late_outlined,
                label: l10n.driverAttendanceExcused,
                selected:
                    entry.attendanceStatus == TripAttendanceStatus.excused,
                onTap: () =>
                    Navigator.of(sheetContext)
                        .pop(TripAttendanceAction.excused),
              ),
            ],
          ),
        );
      },
    );

    if (action == null || !context.mounted) return;

    final ok = await controller.markAttendance(
      childId: entry.id,
      action: action,
    );
    if (!context.mounted) return;

    final currentL10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? currentL10n.driverAttendanceSaved
              : currentL10n.driverAttendanceFailed,
        ),
        backgroundColor: ok ? AppColors.success : AppColors.danger,
      ),
    );
  }

  Widget _loading(String message) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.accent),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.driverOnSurfaceMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalScroll({required Widget child}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [const SizedBox(height: 48), child],
    );
  }

  String _errorText(AppLocalizations l10n, int? status) {
    if (status == 0) return l10n.driverErrorNetwork;
    if (status == 403) return l10n.driverErrorForbidden;
    if (status == 404) return l10n.driverErrorNotFound;
    return l10n.driverStudentsError;
  }

  int? _nextIndex(List<StudentManifestEntry> entries, String tripType) {
    for (var i = 0; i < entries.length; i++) {
      if (!_isResolved(entries[i], tripType)) return i;
    }
    return null;
  }

  bool _isResolved(StudentManifestEntry entry, String tripType) {
    final status = entry.attendanceStatus;
    if (status == TripAttendanceStatus.absent ||
        status == TripAttendanceStatus.excused) {
      return true;
    }
    if (tripType == 'morning') {
      return status == TripAttendanceStatus.boarded ||
          status == TripAttendanceStatus.alighted;
    }
    return status == TripAttendanceStatus.alighted;
  }

  String _statusLabel(AppLocalizations l10n, TripAttendanceStatus status) {
    switch (status) {
      case TripAttendanceStatus.none:
        return l10n.driverAttendanceNone;
      case TripAttendanceStatus.boarded:
        return l10n.driverAttendanceBoarded;
      case TripAttendanceStatus.alighted:
        return l10n.driverAttendanceAlighted;
      case TripAttendanceStatus.absent:
        return l10n.driverAttendanceAbsent;
      case TripAttendanceStatus.excused:
        return l10n.driverAttendanceExcused;
      case TripAttendanceStatus.unknown:
        return l10n.driverAttendanceNone;
    }
  }

  Color _statusColor(TripAttendanceStatus status) {
    switch (status) {
      case TripAttendanceStatus.none:
        return AppColors.driverOnSurfaceMuted;
      case TripAttendanceStatus.boarded:
        return AppColors.accent;
      case TripAttendanceStatus.alighted:
        return AppColors.success;
      case TripAttendanceStatus.absent:
        return AppColors.danger;
      case TripAttendanceStatus.excused:
        return AppColors.warning;
      case TripAttendanceStatus.unknown:
        return AppColors.driverOnSurfaceMuted;
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceOption extends StatelessWidget {
  const _AttendanceOption({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.accent.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 13,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? AppColors.accent
                    : AppColors.driverOnSurfaceMuted,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? AppColors.accent
                        : AppColors.driverOnSurface,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.accent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DarkMessage extends StatelessWidget {
  const _DarkMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.driverSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 44, color: AppColors.driverOnSurfaceMuted),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.driverOnSurface,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.driverOnSurfaceMuted,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: onAction,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
