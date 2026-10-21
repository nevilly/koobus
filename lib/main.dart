// KooBus — splash screen ya kwanza.
// Hii ndiyo app ya KooBus inapoanza: inaonyesha nembo, jina la app,
// na ujumbe mfupi kabla ya kuenda kwenye login (hatua ya baadaye).

import 'package:flutter/material.dart';

// main() ni function ya kuanzia. Flutter inaita mara moja tu
// inapoanza programu kwenye simu.
void main() {
  runApp(const KooBusApp());
}

// KooBusApp ni "root widget" — mchuzi wa app nzima.
// Stateless = haibadiliki yenyewe (splash haibadiliki).
class KooBusApp extends StatelessWidget {
  const KooBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp hutoa Material Design: theme, fonts, navigation.
    // themeColor ni rangi kuu ya KooBus (bluu ya kuaminika).
    return MaterialApp(
      title: 'KooBus',
      debugShowCheckedModeBanner: false, // ondoa banner ya "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// SplashScreen ndiyo page ya kwanza itakayoonekana.
// StatefulWidget tunatumia kwa sababu splash ina "state" ndogo:
// inaonyeshwa kwa muda, kisha inaondoka (hii hatua ya baadaye).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
            colors: [Colors.blue, Colors.blueAccent],
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
