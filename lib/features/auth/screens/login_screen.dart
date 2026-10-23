// Login screen ya KooBus — ukurasa wa kuingia kwa mzazi au dereva.
//
// Hii ni UI pekee bila backend: inaangalia umbo (form) na inaonyesha
// ujumbe wakati server bado haijaunganishwa (Phase 6 tutaijenga API).

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/core/constants/app_spacing.dart';
import 'package:koobus/core/utils/validators.dart';
import 'package:koobus/core/widgets/app_button.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/features/parent/screens/parent_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // FormKey hutumika ku-"control" umbo zima: tunaweza kuuliza
  // "je, umbo lote limejaa kwa usahihi?" kwa _formKey.currentState.validate()
  final _formKey = GlobalKey<FormState>();

  // Controllers ni "vipokezi" vya maandishi yanayoingizwa.
  // Baada ya widget kuondoka, lazima zisafishwe (dispose) — hii
  // inazuia "memory leak".
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true; // nenosiri limefichwa?
  bool _submitting = false; // tunasubiri server?

  @override
  void dispose() {
    // dispose = "safisha baada ya kutumika"
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    // validate() inaangalia kila field; ikiona hitilafu inaionyesha
    // na inarudisha false. Kama zote zimepita inarudisha true.
    if (form == null || !form.validate()) {
      return; // kuna hitilafu — usifanye chochote zaidi
    }

    setState(() => _submitting = true);

    // NOTE: Hakuna API bado. Tunatumia token ya MAJARIBIO (DEV ONLY)
    // ili kuonyesha session inafanya kazi. Token halisi itatoka kwenye
    // API (Phase 7). Hii inajulisha wazi kwa mtumiaji.
    const devToken = 'DEV-TOKEN-DO-NOT-USE-IN-PRODUCTION';

    Future.delayed(const Duration(milliseconds: 500), () async {
      if (!mounted) return; // widget imeondoka? usifanye kitu
      await context.read<AuthController>().signIn(
            token: devToken,
            phone: _phoneController.text.trim(),
          );
      if (!mounted) return;

      // Sasa tuko ndani — nenda home kwa kuiondoa login kwenye stack
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ParentShell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // l10n = maneno ya lugha iliyochaguliwa.
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        // Safeapa inazuia UI kuingia kwenye "notch" ya simu
        child: Center(
          child: SingleChildScrollView(
            // inaruhusu kurasa kusogeza chini kama keyboard inafunika
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
                  const SizedBox(height: AppSpacing.xl),

                  // TextFormField = TextField yenye muunganisho na Form
                  // (hivyo validate() inaweza kuizungumzia).
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    // validator inarudisha error message au null
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
                    obscureText: _obscurePassword, // true = nukta ••••
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

                  // AppButton = kitufe chetu cha kawaida. Inajua loading
                  // yenyewe: inaonyesha spinner na inajizuia kwa kubonyeza
                  // mara mbili. Haihitaji SizedBox(height: 48) tena —
                  // urefu unatoka kwenye theme.
                  AppButton(
                    label: l10n.loginSubmit,
                    loading: _submitting,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Onyo la wazi: kuingia huku si halisi.
                  Text(
                    l10n.loginDevNotice,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.warning),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
