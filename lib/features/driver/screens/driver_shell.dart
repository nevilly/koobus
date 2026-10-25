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

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/features/driver/controllers/driver_controller.dart';
import 'package:koobus/features/driver/screens/driver_home_screen.dart';
import 'package:koobus/features/driver/screens/tabs/driver_map_tab.dart';
import 'package:koobus/features/driver/screens/tabs/driver_profile_tab.dart';
import 'package:koobus/features/driver/screens/tabs/driver_students_tab.dart';
import 'package:koobus/l10n/app_localizations.dart';

class DriverShell extends StatefulWidget {
  const DriverShell({super.key, this.controller});

  /// Kwa test: controller iliyotengenezwa tayari. Kwenye app halisi ni
  /// `null`; DriverHomeScreen itaunda controller yake kutoka AuthController.
  final DriverController? controller;

  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _index = 0;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      DriverHomeScreen(controller: widget.controller),
      const DriverStudentsTab(),
      const DriverMapTab(),
      const DriverProfileTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
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
          onDestinationSelected: (index) => setState(() => _index = index),
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
