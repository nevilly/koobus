// KooBus — splash screen na msingi wa app.
//
// Hii ndiyo app ya KooBus inapoanza: inaonyesha nembo kwa muda mfupi,
// kisha inasoma session (kama mtu aliwahi kuingia) na inaenda
// ukurasa unaofaa: home kama session ipo, login kama haipo.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/controllers/language_controller.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/core/storage/language_service.dart';
import 'package:koobus/core/storage/secure_session_service.dart';
import 'package:koobus/core/storage/session_service.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/app/app_theme.dart';
import 'package:koobus/core/constants/app_colors.dart';
import 'package:koobus/features/auth/screens/login_screen.dart';
import 'package:koobus/features/parent/screens/parent_shell.dart';

// main() ni function ya kuanzia. Flutter inaita mara moja tu
// inapoanza programu kwenye simu.
void main() {
  // runApp haipaswi kutumia async/await moja kwa moja — hivyo tunatengeneza
  // sessionService hapa kisha tunampa KooBusApp. Kama unahitaji kusoma
  // hifadhi kabla ya app kuanza, tunaweza kusubiri hapa (tutaongeza baadae).
  final SessionService sessionService = SecureSessionService();
  final LanguageService languageService = SecureLanguageService();

  runApp(
    KooBusApp(
      sessionService: sessionService,
      languageService: languageService,
    ),
  );
}

// KooBusApp ni "root widget" — mchuzi wa app nzima.
// Inapokea sessionService na languageService ili kujenga controllers
// (dependency injection): hii inaturuhusu kubadilisha hifadhi
// (halisi -> ya majaribio) kwa urahisi.
class KooBusApp extends StatefulWidget {
  const KooBusApp({
    super.key,
    required this.sessionService,
    required this.languageService,
  });

  final SessionService sessionService;
  final LanguageService languageService;

  @override
  State<KooBusApp> createState() => _KooBusAppState();
}

class _KooBusAppState extends State<KooBusApp> {
  late final AuthController _auth;
  late final LanguageController _language;
  late final ApiClient _api;

  // navigatorKey inaturuhusu kufanya navigation kutoka nje ya widget
  // (mfano pale API inarudisha 401 na session inafutwa).
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _auth = AuthController(widget.sessionService);
    _api = ApiClient(
      tokenProvider: () => _auth.session?.token,
      onUnauthorized: () => _auth.signOut(expired: true),
    );
    _language = LanguageController(widget.languageService)..loadLanguage();

    _auth.addListener(_onAuthChanged);
  }

  /// Token expiry handling: pale token inapoisha muda (au server
  /// inarudisha 401), tunamrudisha mtumiaji kwenye login mara moja.
  ///
  /// Tunafanya hivi TU pale sessionExpired = true. Logout ya kawaida
  /// inashughulikiwa na screen yenyewe (profile), hivyo hatuna
  /// navigation mbili zinazogongana.
  void _onAuthChanged() {
    if (!mounted) return;
    if (_auth.status != AuthStatus.loggedOut || !_auth.sessionExpired) return;

    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    _api.dispose();
    _auth.dispose();
    _language.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MultiProvider: tunaweka controllers zote kwenye "mti" wa widgets.
    // Wowote wanaohitaji hali wanaweza kuisoma kwa
    // context.watch<AuthController>() au context.read<LanguageController>().
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: _auth),
        Provider<ApiClient>.value(value: _api),
        ChangeNotifierProvider<LanguageController>.value(value: _language),
      ],
      // Consumer<LanguageController> — hapa MaterialApp INABAO lugha moja
      // kwa moja kutoka controller. Kila mtumiaji anapobadilisha lugha,
      // controller inaarifu, na MaterialApp INAJENGWA UPYA kwa Locale mpya:
      // hivyo app YOTE hubadilika papo hapo, bila ku-restart.
      child: Consumer<LanguageController>(
        builder: (context, language, _) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'KooBus',
            debugShowCheckedModeBanner: false, // ondoa banner ya "DEBUG"
            theme: AppTheme.light,
            // Lugha: locale inatoka controller; delegates hutoa tafsiri za
            // Flutter yenyewe (mfano "Back") pamoja na maneno yetu.
            locale: language.locale,
            supportedLocales: AppLanguage.locales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const SplashScreen(),
          );
        },
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
        ? const ParentShell()
        : const LoginScreen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    // l10n = kamusi ya maneno ya lugha iliyochaguliwa kwa sasa.
    final l10n = AppLocalizations.of(context);

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
              Text(
                l10n.appName,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Ujumbe wa utambulisho
              Text(
                l10n.appTagline,
                style: const TextStyle(
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
