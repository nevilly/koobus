// RouteDetailsScreen — orodha ya vituo vya route kwa mpangilio.
//
// Dereva anahitaji kuona vituo kabla ya kuanza safari. Data inatoka
// kwenye controller ya DriverHomeScreen (`route_stops`), si kwenye
// data ya mfano.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/empty_state.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/route_model.dart';
import 'package:koobus/models/route_stop_model.dart';

class RouteDetailsScreen extends StatelessWidget {
  const RouteDetailsScreen({
    super.key,
    required this.route,
    required this.stops,
  });

  final RouteModel? route;
  final List<RouteStopModel> stops;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.driverStopsTitle)),
      body: stops.isEmpty
          ? EmptyState(
              icon: Icons.location_off_outlined,
              title: l10n.driverNoStops,
              subtitle: route?.name,
            )
          : ListView(
              padding: AppSpacing.page,
              children: [
                if (route != null) ...[
                  Text(
                    route!.name,
                    style: textTheme.titleLarge,
                  ),
                  if (route!.description != null &&
                      route!.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      route!.description!,
                      style: textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.driverStopsCount(stops.length),
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                for (final stop in stops) _StopTile(stop: stop),
              ],
            ),
    );
  }
}

class _StopTile extends StatelessWidget {
  const _StopTile({required this.stop});

  final RouteStopModel stop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasCoordinates = stop.latitude != null && stop.longitude != null;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          foregroundColor: AppColors.primary,
          child: Text(
            '${stop.stopOrder}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(stop.name),
        subtitle: hasCoordinates
            ? Text(
                '${stop.latitude!.toStringAsFixed(5)}, '
                '${stop.longitude!.toStringAsFixed(5)}',
              )
            : Text(l10n.driverStopNoCoordinates),
      ),
    );
  }
}
