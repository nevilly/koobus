// ParentShell — "nyumba" ya mtazamo wa mzazi.
//
// Ina bottom navigation yenye tabs 5:
//   Nyumbani  — hali ya safari leo (ETA, basi)
//   Watoto    — orodha ya watoto + historia ya kupanda/kushuka
//   Historia  — safari zote za hivi karibuni
//   Taarifa   — alerts
//   Wasifu    — taarifa za mzazi, walioidhinishwa, logout
//
// IndexedStack inahifadhi hali ya kila tab (scroll position n.k.) badala
// ya kuijenga upya kila tunapobadilisha tab.
//
// NOTE YA LUGHA: majina ya tabs HAYAWEKI kwenye `const` list tena, kwa
// sababu yanatoka kwenye kamusi (l10n) ambayo inategemea lugha ya sasa.

import 'package:flutter/material.dart';

import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/features/parent/screens/tabs/alerts_tab.dart';
import 'package:koobus/features/parent/screens/tabs/children_tab.dart';
import 'package:koobus/features/parent/screens/tabs/history_tab.dart';
import 'package:koobus/features/parent/screens/tabs/home_tab.dart';
import 'package:koobus/features/parent/screens/tabs/profile_tab.dart';
import 'package:koobus/l10n/app_localizations.dart';

class ParentShell extends StatefulWidget {
  const ParentShell({super.key});

  @override
  State<ParentShell> createState() => _ParentShellState();
}

class _ParentShellState extends State<ParentShell> {
  int _index = 0;

  static const _tabs = <Widget>[
    ParentHomeTab(),
    ChildrenTab(),
    HistoryTab(),
    AlertsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unread = demoAlerts.where((a) => !a.read).length;

    // Vichwa vya AppBar kwa kila tab.
    final titles = <String>[
      l10n.appName,
      l10n.navChildren,
      l10n.navHistory,
      l10n.navAlerts,
      l10n.navProfile,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      // IndexedStack: tabs zote zipo kwenye mti, lakini moja pekee
      // inaonekana. Hii inahifadhi state (mfano scroll position).
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.navHome,
            tooltip: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.child_care_outlined),
            selectedIcon: const Icon(Icons.child_care),
            label: l10n.navChildren,
            tooltip: l10n.navChildren,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history),
            label: l10n.navHistory,
            tooltip: l10n.navHistory,
          ),
          NavigationDestination(
            icon: Badge.count(
              count: unread,
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: const Icon(Icons.notifications),
            label: l10n.navAlerts,
            tooltip: l10n.navAlerts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
            tooltip: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
