// Login screen ya KooBus — ukurasa wa kuingia kwa mzazi, dereva au
// mfanyakazi wa shule.
//
// Token halisi inatoka kwenye API (`/users/login`), kisha tunasoma
// profile (`/users/user`) ili kujua role. Role ndiyo inayoamua
// tunampeleka wapi (RoleHome).
//
// Kitufe cha DEV kinaonekana kwenye debug build pekee. Ni cha kufanya
// majaribio bila server, na kimeandikwa wazi "DEV" — hakuna token ya
// majaribio kwenye release build.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/app/role_home.dart';
import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/core/utils/validators.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _messageFor(ApiException error, AppLocalizations l10n) {
    if (error.statusCode == 0) return l10n.loginErrorNetwork;
    if (error.statusCode == 401 ||
        error.statusCode == 403 ||
        error.statusCode == 406) {
      return l10n.loginErrorInvalid;
    }
    return l10n.loginErrorGeneric;
  }

  /// Ingia kwa API halisi: token -> session -> profile -> RoleHome.
  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final l10n = AppLocalizations.of(context);
    final auth = context.read<AuthController>();
    final service = AuthService(context.read<ApiClient>());
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _submitting = true;
      _error = null;
    });

    var tokenSaved = false;
    try {
      final token = await service.login(phone: phone, password: password);

      // Hifadhi token kwanza ili ApiClient iweze kuomba profile.
      await auth.signIn(token: token, phone: phone);
      tokenSaved = true;

      final user = await service.profile();
      await auth.attachProfile(user);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RoleHome()),
        (route) => false,
      );
    } on ApiException catch (error) {
      // Kama token ilihifadhiwa lakini profile ilishindikana, tusimwache
      // mtumiaji na session isiyo na role.
      if (tokenSaved) await auth.signOut();
      if (!mounted) return;
      setState(() => _error = _messageFor(error, l10n));
    } catch (_) {
      if (tokenSaved) await auth.signOut();
      if (!mounted) return;
      setState(() => _error = l10n.loginErrorGeneric);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Kuingia kwa majaribio — debug build pekee.
  Future<void> _devLogin() async {
    final auth = context.read<AuthController>();
    final phone = _phoneController.text.trim().isEmpty
        ? '0712345678'
        : _phoneController.text.trim();

    setState(() {
      _submitting = true;
      _error = null;
    });

    await auth.signIn(
      token: 'DEV-TOKEN-DO-NOT-USE-IN-PRODUCTION',
      phone: phone,
      role: 'parent',
      displayName: phone,
    );

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RoleHome()),
      (route) => false,
    );
  }

  Widget _errorCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sessionExpired = context.watch<AuthController>().sessionExpired;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.page,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.directions_bus_filled,
                    size: 72,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.loginTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (sessionExpired) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.sessionExpiredNotice,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.warning),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _errorCard(l10n),
                  ],
                  const SizedBox(height: AppSpacing.xl),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone(l10n),
                    decoration: InputDecoration(
                      labelText: l10n.loginPhoneLabel,
                      hintText: 'Mfano: 0712345678',
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: Validators.password(l10n),
                    decoration: InputDecoration(
                      labelText: l10n.loginPasswordLabel,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  AppButton(
                    label: l10n.loginSubmit,
                    loading: _submitting,
                    onPressed: _submitting ? null : _submit,
                  ),

                  // Kitufe cha majaribio: debug build pekee, na limeandikwa
                  // wazi kuwa ni DEV. Hakiwezi kufika release build.
                  if (kDebugMode) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      key: const Key('dev_login_button'),
                      label: l10n.loginDevButton,
                      icon: Icons.science_outlined,
                      loading: false,
                      onPressed: _submitting ? null : _devLogin,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.loginDevNotice,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.warning),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
