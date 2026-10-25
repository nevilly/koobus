// ApiResponse — jibu la API baada ya kufanikiwa.
//
// API ya KooBus inarudisha muundo: `{"status": 200, "payload": ...}`.
// Hii class inatunza status na payload pamoja, ili UI isilazimike
// kuchambua JSON kila mara.

class ApiResponse<T> {
  const ApiResponse({required this.statusCode, required this.data});

  /// Status code iliyorudishwa na API (200, 201, 204, n.k.).
  final int statusCode;

  /// Payload iliyochakatwa (au `null` kama hakuna).
  final T? data;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  bool get isEmpty => data == null;
}
