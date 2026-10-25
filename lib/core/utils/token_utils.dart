// TokenUtils — kusoma muda wa mwisho (exp) wa token bila kuiverify.
//
// Token ya KooBus ni JWT: `header.payload.signature`. Upande wa mteja
// hatuna key ya kuthibitisha signature (na haipaswi kuwa nayo), lakini
// tunaweza kusoma `exp` kwenye payload ili kujua token itaisha lini.
//
// Hii ni kinga ya ziada tu: uthibitisho halisi unafanywa na server.
// Kama token si JWT au haieleweki, tunarudisha `null` — na app
// itaendelea kutegemea jibu la 401 kutoka API.

import 'dart:convert';

class TokenUtils {
  const TokenUtils._();

  /// Rudisha muda wa mwisho wa token, au `null` kama haujulikani.
  static DateTime? expiryOf(String? token) {
    if (token == null || token.isEmpty) return null;

    final parts = token.split('.');
    if (parts.length != 3) return null;

    try {
      final payload = _decodePart(parts[1]);
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) return null;

      final exp = decoded['exp'];
      if (exp is int) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
      }
      if (exp is String) {
        final parsed = int.tryParse(exp);
        if (parsed != null) {
          return DateTime.fromMillisecondsSinceEpoch(parsed * 1000, isUtc: true);
        }
      }
    } catch (_) {
      // Token si JWT halali — tunaacha uamuzi kwa server (401).
    }

    return null;
  }

  /// Je, token imeisha muda? Token isiyojulikana haichukuliwi kama imeisha.
  static bool isExpired(String? token, {Duration leeway = Duration.zero}) {
    final expiry = expiryOf(token);
    if (expiry == null) return false;
    return DateTime.now().toUtc().add(leeway).isAfter(expiry);
  }

  static String _decodePart(String part) {
    final normalized = base64Url.normalize(part);
    return utf8.decode(base64Url.decode(normalized));
  }
}
