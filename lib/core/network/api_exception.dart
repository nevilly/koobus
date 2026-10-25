// ApiException — kosa moja linalotokana na mawasiliano na API.
//
// Tunatunza status code ili UI iweze kuamua cha kufanya:
// 401 -> token imeisha muda / haijasajiliwa (toa session)
// 403 -> hana ruhusa (usiweke sawa na 401)
// 4xx -> kosa la mtumiaji (onyesha ujumbe)
// 5xx -> kosa la server (jaribu tena baadaye)

class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.payload,
  });

  /// HTTP status code (401, 403, 500, n.k.) au 0 kama hakuna jibu.
  final int statusCode;

  /// Ujumbe unaoweza kuonyeshwa kwa mtumiaji.
  final String message;

  /// Payload kamili ya server (kama ipo) kwa debugging/maendeleo.
  final Object? payload;

  /// Token haipo, imeisha muda, au haikubaliki.
  bool get isUnauthorized => statusCode == 401;

  /// Mtumiaji ameingia lakini hana ruhusa ya kitendo hiki.
  bool get isForbidden => statusCode == 403;

  /// Kosa la mtandao (hakuna jibu kutoka server).
  bool get isNetworkError => statusCode == 0;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
