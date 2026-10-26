// DriverShell — "nyumba" ya dereva.
//
// Ina bottom navigation yenye tabs 4:
//   Nyumbani  — safari ya sasa, vituo na Start/End route
//   Wanafunzi — manifest/mahudhurio (hatua inayofuata)
//   Ramani    — ramani/GPS (hatua inayofuata)
//   Wasifu    — taarifa za dereva, lugha na logout
//
// Start/End route haiko hapa: iko kwenye sticky action bar ya
// DriverHomeScreen, juu ya NavigationBar hii. Hivyo dereva anaweza
// kuianzisha au kuimaliza safari bila kusogeza list.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/features/driver/controllers/driver_tracking_controller.dart';
import 'package:koobus/features/driver/screens/driver_home_screen.dart';
import 'package:koobus/features/driver/screens/tabs/driver_map_tab.dart';
import 'package:koobus/features/driver/screens/tabs/driver_profile_tab.dart';
import 'package:koobus/features/driver/screens/tabs/driver_students_tab.dart';
import 'package:koobus/features/driver/services/driver_service.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/services/location_service.dart';

class DriverShell extends StatefulWidget {
  const DriverShell({super.key, this.controller, this.trackingController});

  /// Kwa test: controller iliyotengenezwa tayari. Kwenye app halisi ni
  /// `null`; DriverHomeScreen itaunda controller yake kutoka AuthController.
  final DriverController? controller;

  /// Kwa test: GPS ya kufikirika. Kwenye app halisi ni `null`.
  final DriverTrackingController? trackingController;

  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _index = 0;
  late final DriverController _controller;
  late final bool _ownsController;
  late final DriverTrackingController _tracking;
  late final bool _ownsTracking;
  late final List<Widget> _tabs;
  final Set<int> _loadedTabs = <int>{0};
  int? _syncedTripId;

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

    final providedTracking = widget.trackingController;
    if (providedTracking != null) {
      _tracking = providedTracking;
      _ownsTracking = false;
    } else {
      _tracking = DriverTrackingController(
        source: const GeolocatorLocationSource(),
        repository: _controller.repository,
      );
      _ownsTracking = true;
    }

    // Controller moja inatumiwa na Nyumbani, Wanafunzi na Ramani. Hivyo
    // safari iliyopakiwa haipotei tab inapobadilishwa, na GPS inaweza
    // kuendelea wakati dereva ako kwenye tab nyingine.
    _tabs = [
      DriverHomeScreen(controller: _controller),
      DriverStudentsTab(controller: _controller),
      DriverMapTab(controller: _controller, tracking: _tracking),
      const DriverProfileTab(),
    ];

    _controller.addListener(_syncTracking);
    _syncTracking();
  }

  /// GPS huanza safari ikiwa active tu, na huacha safari inapomalizika.
  void _syncTracking() {
    final trip = _controller.trip;
    if (trip != null && trip.isActive) {
      if (_syncedTripId == trip.id) return;
      _syncedTripId = trip.id;
      _tracking.start(trip.id);
      return;
    }
    if (_syncedTripId != null) {
      _syncedTripId = null;
      _tracking.stop();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_syncTracking);
    if (_ownsTracking) {
      _tracking.dispose();
    }
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          for (var i = 0; i < _tabs.length; i++)
            if (_loadedTabs.contains(i)) _tabs[i] else const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.driverSurface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.30),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? AppColors.driverOnSurface
                  : AppColors.driverOnSurfaceMuted,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected
                  ? AppColors.driverOnSurface
                  : AppColors.driverOnSurfaceMuted,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (index) => setState(() {
            _index = index;
            _loadedTabs.add(index);
          }),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: l10n.driverNavHome,
              tooltip: l10n.driverNavHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.groups_outlined),
              selectedIcon: const Icon(Icons.groups),
              label: l10n.driverNavStudents,
              tooltip: l10n.driverNavStudents,
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map),
              label: l10n.driverNavMap,
              tooltip: l10n.driverNavMap,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: l10n.driverNavProfile,
              tooltip: l10n.driverNavProfile,
            ),
          ],
        ),
      ),
    );
  }
}
