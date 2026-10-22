// ParentShell — "nyumba" ya mtazamo wa mzazi.
//
// Ina bottom navigation yenye tabs 5:
//   Nyumbani  — hali ya safari leo (ETA, basi)
//   Watoto    — orodha ya watoto + historia ya kupanda/kushuka
//   Historia  — safari zote za hivi karibuni
//   Taarifa   — notifications
//   Wasifu    — taarifa za mzazi, walioidhinishwa, logout
//
// IndexedStack inahifadhi hali ya kila tab (scroll position n.k.) badala
// ya kuijenga upya kila tunapobadilisha tab.

import 'package:flutter/material.dart';

import 'package:koobus/features/parent/dev/parent_demo_data.dart';
import 'package:koobus/features/parent/screens/tabs/alerts_tab.dart';
import 'package:koobus/features/parent/screens/tabs/children_tab.dart';
import 'package:koobus/features/parent/screens/tabs/history_tab.dart';
import 'package:koobus/features/parent/screens/tabs/home_tab.dart';
import 'package:koobus/features/parent/screens/tabs/profile_tab.dart';

class ParentShell extends StatefulWidget {
  const ParentShell({super.key});

  @override
  State<ParentShell> createState() => _ParentShellState();
}

class _ParentShellState extends State<ParentShell> {
  int _index = 0;

  static const _titles = <String>[
    'KooBus',
    'Watoto',
    'Historia',
    'Taarifa',
    'Wasifu',
  ];

  static const _tabs = <Widget>[
    ParentHomeTab(),
    ChildrenTab(),
    HistoryTab(),
    AlertsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = demoAlerts.where((a) => !a.read).length;

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      // IndexedStack: tabs zote zipo kwenye mti, lakini moja pekee
      // inaonekana. Hii inahifadhi state (mfano scroll position).
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Nyumbani',
          ),
          const NavigationDestination(
            icon: Icon(Icons.child_care_outlined),
            selectedIcon: Icon(Icons.child_care),
            label: 'Watoto',
          ),
          const NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Historia',
          ),
          NavigationDestination(
            icon: Badge.count(
              count: unread,
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: const Icon(Icons.notifications),
            label: 'Taarifa',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Wasifu',
          ),
        ],
      ),
    );
  }
}
