// StaffChildrenCoordinatesTab — orodha ya wanafunzi na nafasi zao.
//
// Matron/Patron na school admin wanaweza kuweka/badilisha nafasi ya
// mtoto. Uthibitisho wa upande wa shule unabaki kwenye akaunti hii;
// mzazi huthibitisha upande wake kwenye app yake.
import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/app_loader.dart';
import 'package:koobus/core/widgets/empty_state.dart';
import 'package:koobus/core/widgets/error_view.dart';
import 'package:koobus/features/coordinates/controllers/coordinates_controller.dart';
import 'package:koobus/features/coordinates/widgets/coordinate_cards.dart';
import 'package:koobus/features/coordinates/widgets/coordinate_editor_sheet.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/coordinate_model.dart';

class StaffChildrenCoordinatesTab extends StatelessWidget {
  const StaffChildrenCoordinatesTab({super.key, required this.controller});

  final CoordinatesController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coordinatesChildrenTitle),
        actions: [
          IconButton(
            onPressed: controller.loading ? null : controller.load,
            icon: const Icon(Icons.refresh),
            tooltip: l10n.actionRefresh,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (controller.loading && !controller.loaded) {
      return const AppLoader();
    }

    if (controller.error != null && controller.children.isEmpty) {
      return ErrorView(
        message: l10n.coordinatesErrorLoad,
        onRetry: controller.load,
      );
    }

    if (controller.children.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.65,
              child: EmptyState(
                icon: Icons.groups_outlined,
                title: l10n.coordinatesEmptyTitle,
                subtitle: l10n.coordinatesEmptyBody,
              ),
            ),
          ],
        ),
      );
    }

    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(l10n.coordinatesChildrenTitle, style: textTheme.titleLarge),
          const SizedBox(height: 2),
          Text(l10n.coordinatesChildrenSubtitle, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),
          for (final entry in controller.children) ...[
            ChildCoordinateCard(
              entry: entry,
              busy: controller.busy,
              canConfirm:
                  entry.coordinate != null &&
                  !entry.coordinate!.schoolConfirmed,
              onEdit: () => _edit(context, entry),
              onConfirm: () => _confirm(context, entry),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, ChildCoordinateEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final saved = await showCoordinateEditor(
      context,
      title: l10n.coordinatesChildSheetTitle(entry.fullName),
      initial: entry.coordinate,
      onSave:
          ({
            required double latitude,
            required double longitude,
            String? label,
          }) {
            return controller.saveChild(
              childId: entry.childId,
              latitude: latitude,
              longitude: longitude,
              label: label,
            );
          },
    );

    if (saved && context.mounted) {
      _message(context, l10n.coordinatesSaved);
    }
  }

  Future<void> _confirm(
    BuildContext context,
    ChildCoordinateEntry entry,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _confirmDialog(
      context,
      title: l10n.coordinatesConfirmSchoolTitle,
      body: l10n.coordinatesConfirmSchoolBody,
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await controller.confirmChild(entry.childId);
      if (context.mounted) _message(context, l10n.coordinatesConfirmed);
    } catch (_) {
      if (context.mounted) _message(context, l10n.coordinatesErrorConfirm);
    }
  }

  Future<bool?> _confirmDialog(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    final l10n = AppLocalizations.of(context);
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.coordinatesConfirm),
          ),
        ],
      ),
    );
  }

  void _message(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
