// Tests za design system: theme na widgets zinazotumika kila mahali.
//
// Kwa nini kujaribu rangi/ukubwa? Kwa sababu design system ni "mkataba":
// ukibadilisha theme kwa bahati mbaya (mfano button inakuwa nyembamba),
// test hii itatuambia mara moja.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/app/app_theme.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/core/widgets/error_view.dart';

void main() {
  group('AppTheme.light', () {
    test('inatumia rangi kuu ya KooBus', () {
      final theme = AppTheme.light;
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.error, AppColors.danger);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });

    test('button ya kawaida ina urefu wa 52', () {
      final style = AppTheme.light.filledButtonTheme.style;
      expect(style?.minimumSize?.resolve({}), const Size(64, 52));
    });

    test('input fields zina pembe za radius 12', () {
      final border = AppTheme.light.inputDecorationTheme.enabledBorder;
      expect(border, isA<OutlineInputBorder>());
      final radius = (border! as OutlineInputBorder).borderRadius;
      expect(radius, BorderRadius.circular(AppRadius.md));
    });
  });

  group('AppButton', () {
    testWidgets('inabonyezwa na kuita onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                label: 'Ingia',
                onPressed: () => taps++,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Ingia'));
      expect(taps, 1);
    });

    testWidgets('wakati loading: spinner, hakuna kubonyeza', (tester) async {
      var taps = 0;
      Widget build({required bool loading}) => MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: AppButton(
                  label: 'Ingia',
                  loading: loading,
                  onPressed: () => taps++,
                ),
              ),
            ),
          );

      await tester.pumpWidget(build(loading: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Ingia'), findsNothing);

      await tester.tap(find.byType(AppButton));
      expect(taps, 0); // haikubonyezwa — request mbili hazitakaa kutokea
    });
  });

  group('ErrorView', () {
    testWidgets('inaonyesha ujumbe na kitufe cha kujaribu tena',
        (tester) async {
      var retried = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('sw'),
          home: Scaffold(
            body: ErrorView(
              message: 'Hakuna internet. Angalia data yako kisha ujaribu tena.',
              onRetry: () => retried++,
            ),
          ),
        ),
      );

      expect(
        find.text('Hakuna internet. Angalia data yako kisha ujaribu tena.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Jaribu tena'));
      expect(retried, 1);
    });
  });
}
