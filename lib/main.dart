// KooBus — splash screen na msingi wa app.
//
// Hii ndiyo app ya KooBus inapoanza: inaonyesha nembo kwa muda mfupi,
// kisha inasoma session (kama mtu aliwahi kuingia) na inaenda
// ukurasa unaofaa: home kama session ipo, login kama haipo.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/core/storage/secure_session_service.dart';
import 'package:koobus/core/storage/session_service.dart';
import 'package:koobus/app/app_theme.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/features/auth/screens/login_screen.dart';
import 'package:koobus/features/parent/screens/parent_home_screen.dart';

// main() ni function ya kuanzia. Flutter inaita mara moja tu
// inapoanza programu kwenye simu.
void main() {
  // runApp haipaswi kutumia async/await moja kwa moja — hivyo tunatengeneza
  // sessionService hapa kisha tunampa KooBusApp. Kama unahitaji kusoma
  // hifadhi kabla ya app kuanza, tunaweza kusubiri hapa (tutaongeza baadae).
  final SessionService sessionService = SecureSessionService();

  runApp(KooBusApp(sessionService: sessionService));
}

// KooBusApp ni "root widget" — mchuzi wa app nzima.
// Inapokea sessionService ili kujenga AuthController (dependency injection):
// hii inaturuhusu kubadilisha hifadhi (halisi -> ya majaribio) kwa urahisi.
class KooBusApp extends StatelessWidget {
  const KooBusApp({super.key, required this.sessionService});

  final SessionService sessionService;

  @override
  Widget build(BuildContext context) {
    // Provider<AuthController> inaweka AuthController kwenye "mti" wa widgets.
    // Wowote wanaohitaji hali ya kuingia wanaweza kuisoma kwa
    // context.watch<AuthController>() au context.read<AuthController>().
    return ChangeNotifierProvider<AuthController>(
      // create = jenga controller mara moja tu (app nzima).
      create: (_) => AuthController(sessionService),
      child: MaterialApp(
        title: 'KooBus',
        debugShowCheckedModeBanner: false, // ondoa banner ya "DEBUG"
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}

// SplashScreen ndiyo page ya kwanza itakayoonekana.
// StatefulWidget tunatumia kwa sababu splash ina "state" ndogo:
// inasoma session kisha inaondoka.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // initState inaitwa WAKATI widget inajengwa (build phase).
    // Kama tunaita kitendo cha asynchronous hapa moja kwa moja na
    // kinatuma notification (notifyListeners), Flutter inakataa:
    // "huwezi kumwambia widget ijengwe upya wakati bado tunaijenga".
    //
    // Suluhisho: tunasubiri FRAME YA KWANZA imalize (addPostFrameCallback)
    // ndipo tuendelee na kusoma session. Hii inahakikisha tuko nje ya
    // build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    // 1. Soma session (hii inachukua muda kidogo — inasoma keystore)
    final auth = context.read<AuthController>();
    await auth.restoreSession();

    // 2. Subiri sekunde 2 za kuonyesha nembo (splash branding).
    //    Kama restoreSession ilichukua zaidi ya sekunde 2, hii itasubiri
    //    zilizobaki tu — haina kusubiri mara mbili.
    await Future.delayed(const Duration(seconds: 2));

    // mounted = "je, widget bado ipo?" Kama imeondoka (mfano
    // mtumiaji alifunga app), usifanye kitu — hii inazuia kosa.
    if (!mounted) return;

    // 3. Nenda ukurasa unaofaa: home kama session ipo, login kama haipo.
    final next = auth.status == AuthStatus.loggedIn
        ? const ParentHomeScreen()
        : const LoginScreen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold = muundo wa page: AppBar juu, body kwenye, n.k.
    return Scaffold(
      // GradientBackground: background ya bluu inayobadilika polepole
      // kutoka juu kwenda chini — inaonekana ya kisasa.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        // Center = inaweka kitu kwenye katikati ya screen
        child: Center(
          // Column = kuweka vitu wima (juu -> chini)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon ya basi — nembo ya KooBus
              const Icon(
                Icons.directions_bus_filled,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24), // nafasi kati ya vitu
              // Jina la app
              const Text(
                'KooBus',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Ujumbe wa utambulisho
              const Text(
                'Usalama wa safari ya shule',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
