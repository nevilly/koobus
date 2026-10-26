// DriverMapTab �?" ramani halisi ya route na eneo la basi.
//
// Ramani: OpenStreetMap kupitia flutter_map (bila API key, bila malipo).
// Eneo la dereva linatoka GPS ya simu (`DriverTrackingController`), si
// data ya mfano. Vituo vinatoka `route_stops` za server.
//
// Tiles zinatumia `darkModeTileBuilder` ya flutter_map ili ramani
// iendane na dashibodi nyeusi ya dereva.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/features/driver/controllers/driver_tracking_controller.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/route_stop_model.dart';
import 'package:koobus/models/trip_model.dart';
import 'package:koobus/services/location_service.dart';

class DriverMapTab extends StatefulWidget {
  const DriverMapTab({
    super.key,
    required this.controller,
    required this.tracking,
  });

  final DriverController controller;
  final DriverTrackingController tracking;

  @override
  State<DriverMapTab> createState() => _DriverMapTabState();
}

class _DriverMapTabState extends State<DriverMapTab> {
  // Kituo cha kawaida cha ramani (Tanzania) wakati hakuna vituo/GPS.
  // Hii si eneo la basi; ni mwanzo wa ramani tu.
  static const LatLng _fallbackCenter = LatLng(-6.7924, 39.2083);

  final MapController _map = MapController();
  late final Listenable _listenable;
  LocationFix? _centeredFix;

  @override
  void initState() {
    super.initState();
    _listenable = Listenable.merge([widget.controller, widget.tracking]);
    widget.tracking.addListener(_onTrackingChanged);
  }

  @override
  void dispose() {
    widget.tracking.removeListener(_onTrackingChanged);
    _map.dispose();
    super.dispose();
  }

  void _onTrackingChanged() {
    final fix = widget.tracking.lastFix;
    if (fix == null || identical(fix, _centeredFix)) return;
    if (_centeredFix != null) return;
    _centeredFix = fix;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _map.move(LatLng(fix.latitude, fix.longitude), 16);
    });
  }

  void _recenter() {
    final fix = widget.tracking.lastFix;
    if (fix == null) return;
    _map.move(LatLng(fix.latitude, fix.longitude), 16);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.driverBackground,
      body: ListenableBuilder(
        listenable: _listenable,
        builder: (context, _) {
          final trip = widget.controller.trip;
          final stops = widget.controller.stops;
          final stopPoints = _stopPoints(stops);
          final fix = widget.tracking.lastFix;
          final fixPoint = fix == null
              ? null
              : LatLng(fix.latitude, fix.longitude);
          final points = [
            ...stopPoints,
            ?fixPoint,
          ];

          return Stack(
            fit: StackFit.expand,
            children: [
              FlutterMap(
                mapController: _map,
                options: MapOptions(
                  initialCenter: points.isEmpty ? _fallbackCenter : points.first,
                  initialZoom: points.isEmpty ? 11 : 14,
                  initialCameraFit: points.length > 1
                      ? CameraFit.coordinates(
                          coordinates: points,
                          padding: const EdgeInsets.fromLTRB(48, 140, 48, 120),
                          maxZoom: 16,
                        )
                      : null,
                  minZoom: 3,
                  maxZoom: 19,
                  backgroundColor: AppColors.driverBackground,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.koobus',
                    maxZoom: 19,
                    tileBuilder: darkModeTileBuilder,
                  ),
                  if (stopPoints.length > 1)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: stopPoints,
                          strokeWidth: 4,
                          color: AppColors.primary.withValues(alpha: 0.75),
                        ),
                      ],
                    ),
                  MarkerLayer(markers: _stopMarkers(context, stops, l10n)),
                  if (fixPoint != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: fixPoint,
                          width: 54,
                          height: 54,
                          child: _DriverMarker(
                            stale: widget.tracking.state == TrackingState.stale,
                          ),
                        ),
                      ],
                    ),
                  RichAttributionWidget(
                    alignment: AttributionAlignment.bottomLeft,
                    attributions: [
                      TextSourceAttribution(
                        l10n.driverMapAttribution,
                        prependCopyright: false,
                      ),
                    ],
                  ),
                ],
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MapHeader(
                        title: l10n.driverMapTitle,
                        subtitle: _tripLabel(trip, l10n),
                        state: widget.tracking.state,
                        fix: fix,
                        uploadError: widget.tracking.uploadError,
                        l10n: l10n,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (trip != null && !trip.isActive)
                        _NoticeCard(text: l10n.driverMapWaitingTrip),
                      if (widget.controller.hasStops && stopPoints.isEmpty)
                        _NoticeCard(text: l10n.driverMapNoStopsHint),
                    ],
                  ),
                ),
              ),
              if (trip == null)
                _CenterPanel(
                  icon: Icons.map_outlined,
                  title: l10n.driverMapNoActiveTrip,
                  body: l10n.driverMapStartToTrack,
                )
              else if (_needsPermission(widget.tracking.state))
                _CenterPanel(
                  icon: Icons.location_off_outlined,
                  title: _stateTitle(widget.tracking.state, l10n),
                  body: l10n.driverMapStartToTrack,
                  actionLabel: _stateAction(widget.tracking.state, l10n),
                  onAction: _stateActionPressed,
                )
              else if (widget.tracking.state == TrackingState.error)
                _CenterPanel(
                  icon: Icons.gps_off_outlined,
                  title: l10n.driverMapLocating,
                  body: l10n.driverMapStartToTrack,
                  actionLabel: l10n.driverMapRetry,
                  onAction: _retry,
                ),
              Positioned(
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: SafeArea(
                  top: false,
                  child: FloatingActionButton.small(
                    heroTag: 'driver_map_recenter',
                    onPressed: fix == null ? null : _recenter,
                    backgroundColor: AppColors.driverSurface,
                    foregroundColor: AppColors.driverOnSurface,
                    tooltip: l10n.driverMapRecenter,
                    child: const Icon(Icons.my_location_rounded),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<LatLng> _stopPoints(List<RouteStopModel> stops) {
    return [
      for (final stop in stops)
        if (stop.latitude != null && stop.longitude != null)
          LatLng(stop.latitude!, stop.longitude!),
    ];
  }

  List<Marker> _stopMarkers(
    BuildContext context,
    List<RouteStopModel> stops,
    AppLocalizations l10n,
  ) {
    final markers = <Marker>[];
    for (final stop in stops) {
      if (stop.latitude == null || stop.longitude == null) continue;
      markers.add(
        Marker(
          point: LatLng(stop.latitude!, stop.longitude!),
          width: 38,
          height: 38,
          child: Tooltip(
            message: stop.name,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.driverSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                '${stop.stopOrder}',
                style: const TextStyle(
                  color: AppColors.driverOnSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return markers;
  }

  bool _needsPermission(TrackingState state) {
    return state == TrackingState.permissionDenied ||
        state == TrackingState.permissionDeniedForever ||
        state == TrackingState.serviceDisabled;
  }

  String _stateTitle(TrackingState state, AppLocalizations l10n) {
    return switch (state) {
      TrackingState.serviceDisabled => l10n.driverMapGpsOff,
      TrackingState.permissionDeniedForever =>
        l10n.driverMapPermissionDeniedForever,
      TrackingState.permissionDenied => l10n.driverMapPermissionDenied,
      _ => l10n.driverMapLocating,
    };
  }

  String _stateAction(TrackingState state, AppLocalizations l10n) {
    return state == TrackingState.permissionDenied
        ? l10n.driverMapRetry
        : l10n.driverMapOpenSettings;
  }

  Future<void> _stateActionPressed() async {
    final state = widget.tracking.state;
    if (state == TrackingState.permissionDenied) {
      await _retry();
      return;
    }
    if (state == TrackingState.serviceDisabled) {
      await widget.tracking.openLocationSettings();
      return;
    }
    await widget.tracking.openAppSettings();
  }

  Future<void> _retry() async {
    final trip = widget.controller.trip;
    if (trip == null) return;
    await widget.tracking.start(trip.id);
  }

  String _tripLabel(TripModel? trip, AppLocalizations l10n) {
    if (trip == null) return l10n.driverMapNoActiveTrip;
    final route = widget.controller.route;
    final type = trip.tripType == 'morning'
        ? l10n.driverTripTypeMorning
        : l10n.driverTripTypeAfternoon;
    return route == null ? type : '${route.name} · $type';
  }
}

class _MapHeader extends StatelessWidget {
  const _MapHeader({
    required this.title,
    required this.subtitle,
    required this.state,
    required this.fix,
    required this.uploadError,
    required this.l10n,
  });

  final String title;
  final String subtitle;
  final TrackingState state;
  final LocationFix? fix;
  final String? uploadError;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (color, label) = _status(state, l10n);
    final time = fix == null
        ? null
        : DateFormat.Hms().format(fix!.timestamp.toLocal());

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.driverSurface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white12),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.map_rounded,
                size: 20,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.driverOnSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StatusPill(color: color, label: label),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.driverOnSurfaceMuted,
            ),
          ),
          if (fix != null && (state == TrackingState.live || state == TrackingState.stale)) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: 4,
              children: [
                _Meta(
                  icon: Icons.gps_fixed_rounded,
                  text: l10n.driverMapAccuracy(fix!.accuracy.round()),
                ),
                if (time != null)
                  _Meta(
                    icon: Icons.schedule_rounded,
                    text: l10n.driverMapLastUpdate(time),
                  ),
              ],
            ),
          ],
          if (uploadError != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  size: 16,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.driverMapUploadFailed,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  (Color, String) _status(TrackingState state, AppLocalizations l10n) {
    return switch (state) {
      TrackingState.live => (AppColors.success, l10n.driverMapLive),
      TrackingState.stale => (AppColors.warning, l10n.driverMapStale),
      TrackingState.inaccurate => (
        AppColors.warning,
        l10n.driverMapInaccurate,
      ),
      TrackingState.locating ||
      TrackingState.requesting => (
        AppColors.accent,
        l10n.driverMapLocating,
      ),
      TrackingState.serviceDisabled => (
        AppColors.danger,
        l10n.driverMapGpsOff,
      ),
      TrackingState.permissionDenied => (
        AppColors.danger,
        l10n.driverMapPermissionDenied,
      ),
      TrackingState.permissionDeniedForever => (
        AppColors.danger,
        l10n.driverMapPermissionDeniedForever,
      ),
      TrackingState.error => (AppColors.danger, l10n.driverMapLocating),
      TrackingState.idle => (
        AppColors.driverOnSurfaceMuted,
        l10n.driverMapNoActiveTrip,
      ),
    };
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.driverOnSurfaceMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.driverOnSurfaceMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _DriverMarker extends StatelessWidget {
  const _DriverMarker({required this.stale});

  final bool stale;

  @override
  Widget build(BuildContext context) {
    final color = stale ? AppColors.warning : AppColors.primary;
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.22),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 16),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.directions_bus_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.driverSurface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.driverOnSurfaceMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterPanel extends StatelessWidget {
  const _CenterPanel({
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.lg),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: AppColors.driverSurface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: Colors.white12),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 24, offset: Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: AppColors.accent),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.driverOnSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.driverOnSurfaceMuted,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.settings_rounded, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
