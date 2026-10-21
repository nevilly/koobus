// AuthController — hali ya kuingia ya mtumiaji (auth state).
//
// Hii ni "business logic" ya session: inasoma/hifadhi/ondoa session,
// na inaarifu screens zilizosajiliwa (kupitia Provider) pale hali
// inapobadilika. Screens haziwezi kugusa hifadhi moja kwa moja.

import 'package:flutter/foundation.dart';

import 'package:koobus/core/storage/session_service.dart';

/// Hali ya mtumiaji katika app.
enum AuthStatus {
  /// Inasoma session (hakuna kitu cha kuonyesha bado).
  unknown,

  /// Hakuna session — mtu hajawahi kuingia au ame-toka.
  loggedOut,

  /// Kuna session halisi — mtu yuko ndani.
  loggedIn,
}

class AuthController extends ChangeNotifier {
  AuthController(this._sessionService);

  final SessionService _sessionService;

  AuthStatus _status = AuthStatus.unknown;
  StoredSession? _session;

  /// Hali ya sasa — screens zinasoma hii.
  AuthStatus get status => _status;

  /// Session ya sasa (token + simu) — `null` kama hali si loggedIn.
  StoredSession? get session => _session;

  /// Angalia hifadhi: kuna session iliyopita inayostahili kuhifadhiwa?
  ///
  /// Hii inaitwa wakati app inapoanza (splash). Kama ipo, mtu haliingii
  /// tena — anaenda moja kwa moja home.
  ///
  /// NOTE: Hakuna notifyListeners() hapa kabla ya kusoma — status tayari
  /// ni `unknown` kutoka constructor. Kuongeza notification ya bure
  /// kunaweza kusababisha "notify during build" kama inaitwa kutoka
  /// initState. Tunatuma notification MOJA tu pale tayari tunajua jibu.
  Future<void> restoreSession() async {
    final stored = await _sessionService.readSession();

    if (stored != null && stored.token.isNotEmpty) {
      _session = stored;
      _status = AuthStatus.loggedIn;
    } else {
      _session = null;
      _status = AuthStatus.loggedOut;
    }
    notifyListeners();
  }

  /// Ingia — hifadhi session mpya na arifu.
  ///
  /// NOTE: Hii sasa inaitwa na login screen kwa token ya majaribio.
  /// Baada ya Phase 7, login screen itapokea token kutoka API halisi
  /// kwanza, kisha itaita hii. Controller haifahamu API — inahifadhi tu.
  Future<void> signIn({required String token, required String phone}) async {
    final session = StoredSession(token: token, phone: phone);
    await _sessionService.saveSession(session);
    _session = session;
    _status = AuthStatus.loggedIn;
    notifyListeners();
  }

  /// Toka — ondoa session na arifu.
  Future<void> signOut() async {
    await _sessionService.clearSession();
    _session = null;
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }
}
