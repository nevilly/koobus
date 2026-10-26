// StaffShell — "nyumba" ya Matron/Patron na school admin.
//
// Tabs:
//   Wanafunzi — nafasi za wanafunzi (weka/badilisha/thibitisha)
//   Shule     — nafasi ya shule
//   Wasifu    — taarifa, lugha na logout
//
// Controller moja inatumiwa na tabs zote ili nafasi moja isipotelewe
// tab inapobadilishwa.
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/features/coordinates/controllers/coordinates_controller.dart';
import 'package:koobus/features/coordinates/services/coordinate_service.dart';
import 'package:koobus/features/staff/screens/tabs/staff_children_coordinates_tab.dart';
import 'package:koobus/features/staff/screens/tabs/staff_profile_tab.dart';
import 'package:koobus/features/staff/screens/tabs/staff_school_coordinate_tab.dart';
import 'package:koobus/l10n/app_localizations.dart';

class StaffShell extends StatefulWidget {
  const StaffShell({super.key, this.controller});

  /// Kwa test: controller iliyotengenezwa tayari. Kwenye app halisi ni
  /// `null`; shell itaunda controller kutoka `ApiClient`.
  final CoordinatesController? controller;

  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  int _index = 0;
  late final CoordinatesController _controller;
  late final bool _ownsController;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    final provided = widget.controller;
    if (provided != null) {
      _controller = provided;
      _ownsController = false;
    } else {
      _controller = CoordinatesController(
        repository: CoordinateService(context.read<ApiClient>()),
      );
      _ownsController = true;
    }

    _tabs = [
      StaffChildrenCoordinatesTab(controller: _controller),
      StaffSchoolCoordinateTab(controller: _controller),
      StaffProfileTab(controller: _controller),
    ];
    _controller.load();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.groups_outlined),
            selectedIcon: const Icon(Icons.groups),
            label: l10n.staffNavChildren,
            tooltip: l10n.staffNavChildren,
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_outlined),
            selectedIcon: const Icon(Icons.school),
            label: l10n.staffNavSchool,
            tooltip: l10n.staffNavSchool,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.staffNavProfile,
            tooltip: l10n.staffNavProfile,
          ),
        ],
      ),
    );
  }
}
