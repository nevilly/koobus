// CoordinateEditorSheet — fomu moja ya kuweka/badilisha nafasi.
//
// Fomu hii inatumiwa na mzazi, Matron/Patron na msimamizi wa shule.
// Inaweza kujaza latitude/longitude kutoka GPS halisi ya kifaa; hakuna
// eneo la mfano.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/coordinate_model.dart';
import 'package:koobus/services/location_service.dart';

typedef CoordinateSaveCallback = Future<void> Function({
  required double latitude,
  required double longitude,
  String? label,
});

/// Fungua sheet na urudishe `true` kama nafasi ilihifadhiwa.
Future<bool> showCoordinateEditor(
  BuildContext context, {
  required String title,
  CoordinateModel? initial,
  required CoordinateSaveCallback onSave,
  LocationSource locationSource = const GeolocatorLocationSource(),
}) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (_) => CoordinateEditorSheet(
      title: title,
      initial: initial,
      onSave: onSave,
      locationSource: locationSource,
    ),
  );
  return saved ?? false;
}

class CoordinateEditorSheet extends StatefulWidget {
  const CoordinateEditorSheet({
    super.key,
    required this.title,
    required this.onSave,
    this.initial,
    this.locationSource = const GeolocatorLocationSource(),
  });

  final String title;
  final CoordinateModel? initial;
  final CoordinateSaveCallback onSave;
  final LocationSource locationSource;

  @override
  State<CoordinateEditorSheet> createState() => _CoordinateEditorSheetState();
}

class _CoordinateEditorSheetState extends State<CoordinateEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _latitude;
  late final TextEditingController _longitude;
  late final TextEditingController _label;

  bool _saving = false;
  bool _locating = false;
  bool _canOpenSettings = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _latitude = TextEditingController(
      text: initial == null ? '' : initial.latitude.toStringAsFixed(6),
    );
    _longitude = TextEditingController(
      text: initial == null ? '' : initial.longitude.toStringAsFixed(6),
    );
    _label = TextEditingController(text: initial?.label ?? '');
  }

  @override
  void dispose() {
    _latitude.dispose();
    _longitude.dispose();
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(widget.title, style: textTheme.titleLarge),
                  ),
                  IconButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close),
                    tooltip: l10n.actionCancel,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.coordinatesInfo, style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitude,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.coordinatesLatitude,
                        hintText: l10n.coordinatesLatitudeHint,
                      ),
                      validator: (value) => _validateCoordinate(
                        value,
                        isLatitude: true,
                        l10n: l10n,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextFormField(
                      controller: _longitude,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.coordinatesLongitude,
                        hintText: l10n.coordinatesLongitudeHint,
                      ),
                      validator: (value) => _validateCoordinate(
                        value,
                        isLatitude: false,
                        l10n: l10n,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _label,
                maxLength: 150,
                decoration: InputDecoration(
                  labelText: l10n.coordinatesLabel,
                  hintText: l10n.coordinatesLabelHint,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: (_saving || _locating) ? null : _fillFromGps,
                icon: _locating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  _locating ? l10n.coordinatesLocating : l10n.coordinatesUseGps,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _error!,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.danger),
                ),
              ],
              if (_canOpenSettings) ...[
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: _openSettings,
                  child: Text(l10n.coordinatesOpenSettings),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.coordinatesSave,
                icon: Icons.save_outlined,
                loading: _saving,
                onPressed: _save,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: _saving
                    ? null
                    : () => Navigator.of(context).pop(false),
                child: Text(l10n.actionCancel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateCoordinate(
    String? value, {
    required bool isLatitude,
    required AppLocalizations l10n,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return l10n.coordinatesRequired;
    final parsed = double.tryParse(text.replaceAll(',', '.'));
    if (parsed == null) return l10n.coordinatesRequired;
    if (isLatitude && (parsed < -90 || parsed > 90)) {
      return l10n.coordinatesInvalidLatitude;
    }
    if (!isLatitude && (parsed < -180 || parsed > 180)) {
      return l10n.coordinatesInvalidLongitude;
    }
    return null;
  }

  Future<void> _fillFromGps() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _locating = true;
      _error = null;
      _canOpenSettings = false;
    });

    try {
      if (!await widget.locationSource.isServiceEnabled()) {
        if (!mounted) return;
        setState(() {
          _error = l10n.coordinatesGpsOff;
          _canOpenSettings = true;
        });
        return;
      }

      final permission = await widget.locationSource.ensurePermission();
      if (!mounted) return;
      switch (permission) {
        case LocationPermissionState.granted:
          break;
        case LocationPermissionState.deniedForever:
          setState(() {
            _error = l10n.coordinatesGpsDeniedForever;
            _canOpenSettings = true;
          });
          return;
        case LocationPermissionState.serviceDisabled:
          setState(() {
            _error = l10n.coordinatesGpsOff;
            _canOpenSettings = true;
          });
          return;
        case LocationPermissionState.denied:
          setState(() => _error = l10n.coordinatesGpsDenied);
          return;
      }

      final fix = await widget.locationSource.currentFix();
      if (!mounted) return;
      if (!fix.isAccurate) {
        setState(() => _error = l10n.coordinatesGpsWeak);
        return;
      }

      _latitude.text = fix.latitude.toStringAsFixed(6);
      _longitude.text = fix.longitude.toStringAsFixed(6);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = l10n.coordinatesGpsError);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _openSettings() async {
    if (!await widget.locationSource.isServiceEnabled()) {
      await widget.locationSource.openLocationSettings();
    } else {
      await widget.locationSource.openAppSettings();
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final latitude = double.parse(_latitude.text.trim().replaceAll(',', '.'));
    final longitude = double.parse(_longitude.text.trim().replaceAll(',', '.'));
    if (latitude == 0 && longitude == 0) {
      setState(() => _error = l10n.coordinatesRequired);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await widget.onSave(
        latitude: latitude,
        longitude: longitude,
        label: _label.text.trim().isEmpty ? null : _label.text.trim(),
      );
      if (!mounted) return;
      setState(() => _saving = false);
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l10n.coordinatesErrorSave;
      });
    }
  }
}
