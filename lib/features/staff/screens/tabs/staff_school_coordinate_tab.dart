// StaffSchoolCoordinateTab — nafasi ya shule.
//
// Matron/Patron na school admin wanaweka nafasi ya shule. Upande wa
// shule unathibitishwa mara moja wanapohifadhi; mzazi huthibitisha
// upande wake kwenye app yake.
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

class StaffSchoolCoordinateTab extends StatelessWidget {
  const StaffSchoolCoordinateTab({super.key, required this.controller});

  final CoordinatesController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coordinatesSchoolTitle),
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

    if (controller.error != null && controller.schools.isEmpty) {
      return ErrorView(
        message: l10n.coordinatesErrorLoad,
        onRetry: controller.load,
      );
    }

    final entry = controller.primarySchool;
    if (entry == null) {
      return EmptyState(
        icon: Icons.school_outlined,
        title: l10n.staffProfileNoSchool,
        subtitle: l10n.coordinatesSchoolSubtitle,
      );
    }

    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(l10n.coordinatesSchoolTitle, style: textTheme.titleLarge),
          const SizedBox(height: 2),
          Text(l10n.coordinatesSchoolSubtitle, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),
          SchoolCoordinateCard(
            entry: entry,
            busy: controller.busy,
            canConfirm:
                entry.coordinate != null && !entry.coordinate!.schoolConfirmed,
            onEdit: () => _edit(context, entry),
            onConfirm: () => _confirm(context, entry),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.coordinatesInfo, style: textTheme.bodySmall),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, SchoolCoordinateEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final saved = await showCoordinateEditor(
      context,
      title: l10n.coordinatesSchoolSheetTitle,
      initial: entry.coordinate,
      onSave:
          ({
            required double latitude,
            required double longitude,
            String? label,
          }) {
            return controller.saveSchool(
              schoolId: entry.schoolId,
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
    SchoolCoordinateEntry entry,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _confirmDialog(
      context,
      title: l10n.coordinatesConfirmSchoolTitle,
      body: l10n.coordinatesConfirmSchoolBody,
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await controller.confirmSchool(entry.schoolId);
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
