// Parent home screen — mahali mzazi anapoingia baada ya login.
//
// NOTE: Hii ni "placeholder" rahisi kwa sasa. Baada ya Phase 5/9
// itaonyesha watoto, basi na ramani halisi. Lengo la sasa ni kuonyesha
// session inafanya kazi: mtu yuko ndani na anaweza kutoka.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/features/auth/screens/login_screen.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch<AuthController>() = "jenga upya screen hii
    // kila AuthController inapobadilika hali". Hii ndiyo nguvu
    // ya ChangeNotifier + Provider.
    final auth = context.watch<AuthController>();
    final phone = auth.session?.phone ?? 'Haijulikani';

    return Scaffold(
      appBar: AppBar(
        title: const Text('KooBus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Toka',
            onPressed: () async {
              // swali_thibitisha: mtu anaweza kubonyeza kwa makosa
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Toka?'),
                  content: const Text(
                    'Ukifunga app baada ya kutoka, utahitaji kuingia tena.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Bado'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Toka'),
                    ),
                  ],
                ),
              );
              if (confirmed != true || !context.mounted) return;

              // Ondoa session halisi kwenye hifadhi
              await context.read<AuthController>().signOut();
              if (!context.mounted) return;

              // Rudi login. pushReplacement = usirudi nyuma kwa home.
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_bus_filled,
                  size: 72, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Karibu, $phone',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Umefanikiwa kuingia.\nSession yako imehifadhiwa — '
                'ukifunga app utarudi hapa bila kuingia tena.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              // Onyo wazi: hii si app halisi bado
              const Card(
                color: Colors.amber,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'DEVELOPMENT: Ukurasa huu ni wa muda. Hakuna watoto, '
                    'basi wala ramani bado — tutajenga kwa Phase 5-9.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
