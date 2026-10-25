// AuthController — hali ya kuingia ya mtumiaji (auth state).
//
// Hii ni "business logic" ya session: inasoma/hifadhi/ondoa session,
// na inaarifu screens zilizosajiliwa (kupitia Provider) pale hali
// inapobadilika. Screens haziwezi kugusa hifadhi moja kwa moja.

import 'package:flutter/foundation.dart';

import 'package:koobus/core/storage/session_service.dart';
import 'package:koobus/core/utils/token_utils.dart';
import 'package:koobus/models/user_model.dart';

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
  bool _sessionExpired = false;

  /// Hali ya sasa — screens zinasoma hii.
  AuthStatus get status => _status;

  /// Session ya sasa (token + simu) — `null` kama hali si loggedIn.
  StoredSession? get session => _session;

  /// Je, mtumiaji alitolewa kwa sababu token ilisha muda?
  ///
  /// Login screen inaitumia kuonyesha ujumbe wa "session imeisha muda"
  /// badala ya kumtaka mtumiaji aingie bila maelezo.
  bool get sessionExpired => _sessionExpired;

  /// Role ya mtumiaji. Kama session ya zamani haina role (mfano token
  /// ya DEV), tunaitafsiri kama `parent` ili app isikwame.
  UserRole get role {
    final raw = _session?.role;
    if (raw == null || raw.isEmpty) {
      final token = _session?.token ?? '';
      if (token.startsWith('DEV-')) return UserRole.parent;
      return UserRole.unknown;
    }
    return UserModel.parseRole(raw);
  }

  /// `users.id` ya mtumiaji aliyeingia (inahitajika kwa safari za dereva).
  int? get userId => _session?.userId;

  /// Jina la kuonyesha (kutoka profile ya API).
  String get displayName {
    final name = _session?.displayName;
    if (name != null && name.trim().isNotEmpty) return name.trim();
    return _session?.phone ?? '';
  }

  bool get isDriver => role == UserRole.driver;
  bool get isParent => role == UserRole.parent;

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
      // Kinga: token iliyokwisha muda haipaswi kumwingiza mtumiaji.
      // Tunafuta session na kumtaka aingie tena.
      if (stored.isExpired || TokenUtils.isExpired(stored.token)) {
        await _sessionService.clearSession();
        _session = null;
        _status = AuthStatus.loggedOut;
        _sessionExpired = true;
        notifyListeners();
        return;
      }

      _session = stored;
      _status = AuthStatus.loggedIn;
      _sessionExpired = false;
    } else {
      _session = null;
      _status = AuthStatus.loggedOut;
    }
    notifyListeners();
  }

  /// Ingia — hifadhi session mpya na arifu.
  ///
  /// Login screen inaita hii mara mbili kwa mchakato mmoja:
  ///  1. Baada ya `/users/login` kurudisha token (role bado haijulikani).
  ///  2. Baada ya `/users/user` kurudisha profile (`attachProfile`).
  ///
  /// Kwa nini si mara moja? Kwa sababu `ApiClient` inasoma token kutoka
  /// session hii; bila kuihifadhi kwanza, hatuwezi kuomba profile.
  Future<void> signIn({
    required String token,
    required String phone,
    String? role,
    int? userId,
    String? displayName,
  }) async {
    final session = StoredSession(
      token: token,
      phone: phone,
      expiresAt: TokenUtils.expiryOf(token),
      role: role,
      userId: userId,
      displayName: displayName,
    );
    await _sessionService.saveSession(session);
    _session = session;
    _status = AuthStatus.loggedIn;
    _sessionExpired = false;
    notifyListeners();
  }

  /// Weka taarifa za profile (role, id, jina) kwenye session iliyopo.
  ///
  /// Hii haibadilishi token; inaongeza tu kile API iliturudishia.
  Future<void> attachProfile(UserModel user) async {
    final current = _session;
    if (current == null) return;

    final updated = StoredSession(
      token: current.token,
      phone: current.phone,
      expiresAt: current.expiresAt,
      role: user.roleValue,
      userId: user.id,
      displayName: user.displayName,
    );
    await _sessionService.saveSession(updated);
    _session = updated;
    _status = AuthStatus.loggedIn;
    _sessionExpired = false;
    notifyListeners();
  }

  /// Toka — ondoa session na arifu.
  ///
  /// [expired] = `true` pale token ilipoisha muda au server ikarudisha 401.
  /// Hii inaruhusu login screen kuonyesha ujumbe unaofaa.
  Future<void> signOut({bool expired = false}) async {
    await _sessionService.clearSession();
    _session = null;
    _status = AuthStatus.loggedOut;
    _sessionExpired = expired;
    notifyListeners();
  }
}
