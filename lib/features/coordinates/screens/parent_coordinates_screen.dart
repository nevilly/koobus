// ParentCoordinatesScreen — mzazi anaweka/anauthibitisha nafasi.
//
// Screen hii inatumia API halisi. Haina data ya mfano: kama mtoto
// hajaunganishwa, inaonyesha hali tupu badala ya kuvumbua majina.
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/core/widgets/app_loader.dart';
import 'package:koobus/core/widgets/empty_state.dart';
import 'package:koobus/core/widgets/error_view.dart';
import 'package:koobus/features/coordinates/controllers/coordinates_controller.dart';
import 'package:koobus/features/coordinates/services/coordinate_service.dart';
import 'package:koobus/features/coordinates/widgets/coordinate_cards.dart';
import 'package:koobus/features/coordinates/widgets/coordinate_editor_sheet.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/coordinate_model.dart';

class ParentCoordinatesScreen extends StatefulWidget {
  const ParentCoordinatesScreen({super.key, this.repository});

  /// Kwa test: repository ya kufikirika. Kwenye app halisi ni `null`.
  final CoordinateRepository? repository;

  @override
  State<ParentCoordinatesScreen> createState() =>
      _ParentCoordinatesScreenState();
}

class _ParentCoordinatesScreenState extends State<ParentCoordinatesScreen> {
  late final CoordinatesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CoordinatesController(
      repository:
          widget.repository ?? CoordinateService(context.read<ApiClient>()),
    );
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coordinatesTitle),
        actions: [
          IconButton(
            onPressed: _controller.loading ? null : _controller.load,
            icon: const Icon(Icons.refresh),
            tooltip: l10n.actionRefresh,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_controller.loading && !_controller.loaded) {
      return const AppLoader();
    }

    if (_controller.error != null &&
        _controller.children.isEmpty &&
        _controller.schools.isEmpty) {
      return ErrorView(
        message: l10n.coordinatesErrorLoad,
        onRetry: _controller.load,
      );
    }

    if (_controller.children.isEmpty && _controller.schools.isEmpty) {
      return RefreshIndicator(
        onRefresh: _controller.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.65,
              child: EmptyState(
                icon: Icons.location_off_outlined,
                title: l10n.coordinatesEmptyParentTitle,
                subtitle: l10n.coordinatesEmptyParentBody,
              ),
            ),
          ],
        ),
      );
    }

    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: _controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(l10n.coordinatesTitle, style: textTheme.titleLarge),
          const SizedBox(height: 2),
          Text(l10n.coordinatesInfo, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),
          if (_controller.children.isNotEmpty) ...[
            Text(l10n.coordinatesChildrenTitle, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final entry in _controller.children) ...[
              ChildCoordinateCard(
                entry: entry,
                busy: _controller.busy,
                canConfirm:
                    entry.coordinate != null &&
                    !entry.coordinate!.parentConfirmed,
                onEdit: () => _editChild(entry),
                onConfirm: () => _confirmChild(entry),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
          if (_controller.schools.isNotEmpty) ...[
            Text(l10n.coordinatesSchoolTitle, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final entry in _controller.schools) ...[
              SchoolCoordinateCard(
                entry: entry,
                busy: _controller.busy,
                canConfirm:
                    entry.coordinate != null &&
                    !entry.coordinate!.parentConfirmed,
                onEdit: null,
                onConfirm: () => _confirmSchool(entry),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _editChild(ChildCoordinateEntry entry) async {
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
            return _controller.saveChild(
              childId: entry.childId,
              latitude: latitude,
              longitude: longitude,
              label: label,
            );
          },
    );

    if (saved && mounted) {
      _showMessage(l10n.coordinatesSaved);
    }
  }

  Future<void> _confirmChild(ChildCoordinateEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _confirmDialog(
      title: l10n.coordinatesConfirmParentTitle,
      body: l10n.coordinatesConfirmParentBody,
    );
    if (confirmed != true || !mounted) return;

    try {
      await _controller.confirmChild(entry.childId);
      if (mounted) _showMessage(l10n.coordinatesConfirmed);
    } catch (_) {
      if (mounted) _showMessage(l10n.coordinatesErrorConfirm);
    }
  }

  Future<void> _confirmSchool(SchoolCoordinateEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _confirmDialog(
      title: l10n.coordinatesConfirmParentTitle,
      body: l10n.coordinatesConfirmParentBody,
    );
    if (confirmed != true || !mounted) return;

    try {
      await _controller.confirmSchool(entry.schoolId);
      if (mounted) _showMessage(l10n.coordinatesConfirmed);
    } catch (_) {
      if (mounted) _showMessage(l10n.coordinatesErrorConfirm);
    }
  }

  Future<bool?> _confirmDialog({required String title, required String body}) {
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
