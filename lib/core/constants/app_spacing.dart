// Nafasi (spacing) na pembe (radius) za KooBus.
//
// Kwa nini si `SizedBox(height: 16)` kila mahali? Kwa sababu "16" ni
// namba ya kizembe — hakuna maana. `AppSpacing.md` ina maana: nafasi
// ya kati. Na kama tunabadilisha spacing ya app nzima, tunabadilisha
// hapa tu.

import 'package:flutter/material.dart';

class AppSpacing {
  const AppSpacing._();

  /// 4 — nafasi ndogo sana (kati ya icon na maandishi).
  static const double xs = 4;

  /// 8 — ndogo.
  static const double sm = 8;

  /// 16 — ya kawaida (kati ya fields).
  static const double md = 16;

  /// 24 — kubwa (kati ya sehemu).
  static const double lg = 24;

  /// 32 — kubwa sana (juu/chini ya screen).
  static const double xl = 32;

  /// Padding ya kawaida ya screen nzima.
  static const EdgeInsets page = EdgeInsets.all(lg);
}

class AppRadius {
  const AppRadius._();

  /// 8 — vitu vidogo (chips, badges).
  static const double sm = 8;

  /// 12 — buttons na input fields.
  static const double md = 12;

  /// 16 — kadi na dialogs.
  static const double lg = 16;
}
