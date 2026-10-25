// AuthService — mawasiliano ya kuingia na profile na API.
//
// Mchakato ni hatua MBILI kwa sababu `ApiClient` inachukua token kutoka
// `AuthController.session`:
//   1. POST /users/login  -> token
//   2. AuthController.signIn(token) ili ApiClient iitumie
//   3. GET /users/user    -> role, id, jina
//   4. AuthController.attachProfile(user)
//
// LoginScreen ndiyo inaratibu hatua hizi; service hii inajua API pekee.

import 'package:koobus/core/constants/api_endpoints.dart';
import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/models/user_model.dart';

class AuthService {
  AuthService(this._api);

  final ApiClient _api;

  /// Ingia kwa namba ya simu (au username/email) na nenosiri.
  ///
  /// Server inarudisha token (string) kama payload. Token hiyo ni
  /// iliyosimbwa (encrypted JWT); client haiichambui, inaituma tu.
  Future<String> login({
    required String phone,
    required String password,
  }) async {
    final response = await _api.post(
      ApiEndpoints.login,
      body: {
        'username': phone.trim(),
        'password': password,
      },
    );

    final payload = response.data;
    if (payload is String && payload.trim().isNotEmpty) {
      return payload.trim();
    }
    if (payload is Map && payload['token'] is String) {
      final token = (payload['token'] as String).trim();
      if (token.isNotEmpty) return token;
    }

    throw const ApiException(
      statusCode: 500,
      message: 'Jibu la server halijaeleweka. Jaribu tena.',
    );
  }

  /// Pata profile ya mtumiaji aliyeingia (token ipo kwenye ApiClient).
  Future<UserModel> profile() async {
    final response = await _api.get(ApiEndpoints.profile);
    final data = response.data;

    if (data is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }

    throw const ApiException(
      statusCode: 500,
      message: 'Server haikurudisha taarifa za mtumiaji.',
    );
  }
}
