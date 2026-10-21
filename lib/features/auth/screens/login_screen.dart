// Login screen ya KooBus — ukurasa wa kuingia kwa mzazi au dereva.
//
// Hii ni UI pekee bila backend: inaangalia umbo (form) na inaonyesha
// ujumbe wakati server bado haijaunganishwa (Phase 6 tutaijenga API).

import 'package:flutter/material.dart';

import 'package:koobus/core/utils/validators.dart';

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

    // NOTE: Hakuna API bado. Hii ni "simulasi" fupi ilionyesha hali
    // ya "loading". Hatutaki app ionyeshe mafanikio ya kubuni —
    // hivyo tunajulisha wazi kwamba server haijaunganishwa.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return; // widget imeondoka? usifanye kitu
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server bado haijaunganishwa (hatua ya Phase 6).'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Safeapa inazuia UI kuingia kwenye "notch" ya simu
        child: Center(
          child: SingleChildScrollView(
            // inaruhusu kurasa kusogeza chini kama keyboard inafunika
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.directions_bus_filled,
                    size: 72,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Karibu KooBus',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ingia ili kuona safari za watoto wako',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // TextFormField = TextField yenye muunganisho na Form
                  // (hivyo validate() inaweza kuizungumzia).
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    // validator inarudisha error message au null
                    validator: Validators.phone,
                    decoration: const InputDecoration(
                      labelText: 'Namba ya simu',
                      hintText: 'Mfano: 0712345678',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword, // true = nukta ••••
                    validator: Validators.password,
                    decoration: InputDecoration(
                      labelText: 'Nenosiri',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
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
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      // onSubmitting = true, kitufe "hazimwi" (disabled)
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Ingia', style: TextStyle(fontSize: 16)),
                    ),
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
