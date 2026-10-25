// Rangi za KooBus — mahali PEKEE pa kufafanua rangi.
//
// Kanuni: screen haipaswi kuandika `Colors.blue` au `Color(0xFF...)`
// moja kwa moja. Inatumia AppColors.primary n.k. Kwa nini?
// - Ukibadilisha brand rangi, unabadilisha mstari mmoja hapa.
// - Rangi zinabaki sawa kwenye screen zote (consistency).
// - "danger" inamaanisha kitu kimoja kila mahali: kosa/hatari.

import 'package:flutter/material.dart';

class AppColors {
  // Private constructor: class hii ni "kasha la constants" tu,
  // haipaswi kuwa na instance (AppColors()).
  const AppColors._();

  /// Rangi kuu ya KooBus — bluu ya kuaminika (trust).
  static const Color primary = Color(0xFF1565C0);

  /// Bluu nzito — kwa gradient ya splash na AppBar.
  static const Color primaryDark = Color(0xFF0D47A1);

  /// Rangi ya pili — njano ya basi la shule (school-bus amber).
  /// Matumizi: tahadhari, alama za basi, vipengele vinavyovutia jicho.
  static const Color accent = Color(0xFFFFB300);

  /// Background ya screen nyingi (badala ya nyeupe tupu).
  static const Color background = Color(0xFFF5F7FA);

  /// Background ya kadi, dialogs na input fields.
  static const Color surface = Color(0xFFFFFFFF);

  /// Mistari/nafasi kati ya vitu (borders, dividers).
  static const Color border = Color(0xFFD7DEE8);

  /// Maandishi makuu.
  static const Color textPrimary = Color(0xFF17212B);

  /// Maelezo, hints na maandishi ya pili.
  static const Color textSecondary = Color(0xFF5F6B7A);

  // ---- Rangi za hali (status) ----
  // Tutazitumia kwenye safari: imefika, iko njiani, imechelewa, offline.

  /// Kitu kimefanikiwa / basi limefika.
  static const Color success = Color(0xFF2E7D32);

  /// Tahadhari / basi limechelewa kidogo.
  static const Color warning = Color(0xFFF9A825);

  /// Kosa / hatari / basi halipo.
  static const Color danger = Color(0xFFC62828);

  // ---- Rangi za dashibodi ya dereva ----
  // Dashibodi ya dereva inatumia mandhari ya giza (kama ramani ya usiku)
  // ili dereva aweze kuiona kwa haraka wakati wa safari.

  /// Background ya dashibodi ya dereva.
  static const Color driverBackground = Color(0xFF0B1220);

  /// Kadi na bottom navigation ya dereva.
  static const Color driverSurface = Color(0xFF161F2E);

  /// Rangi nyepesi kwa vitu vilivyoinuliwa kwenye dashibodi ya dereva.
  static const Color driverSurfaceLight = Color(0xFF243044);

  /// Maandishi kwenye mandhari ya giza ya dereva.
  static const Color driverOnSurface = Color(0xFFF8FAFC);

  /// Maandishi ya pili kwenye mandhari ya giza ya dereva.
  static const Color driverOnSurfaceMuted = Color(0xFFB6C2D2);
}
