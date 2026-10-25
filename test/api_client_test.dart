// Tests za ApiClient: uhakika kwamba 401 inamtoa mtumiaji (token expiry),
// 403 haitoi session, na token inatumwa kwa header sahihi.
//
// Tunatumia MockClient (package:http/testing.dart) — hakuna mtandao halisi.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:koobus/core/network/api_client.dart';
import 'package:koobus/core/network/api_exception.dart';

void main() {
  group('ApiClient', () {
    test('inaongeza header ya Owesis kwenye maombi', () async {
      String? receivedAuth;
      final client = ApiClient(
        baseUrl: 'http://test.local/api/v1',
        tokenProvider: () => 'TOKEN-123',
        onUnauthorized: () async {},
        httpClient: MockClient((request) async {
          receivedAuth = request.headers['Authorization'];
          return http.Response(
            jsonEncode({'status': 200, 'payload': 'ok'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await client.get('/trips/all');

      expect(receivedAuth, 'Owesis TOKEN-123');
      expect(response.data, 'ok');
      expect(response.isSuccess, isTrue);
    });

    test('401 inaita onUnauthorized na kurudisha ApiException', () async {
      var unauthorizedCalled = 0;
      final client = ApiClient(
        baseUrl: 'http://test.local/api/v1',
        tokenProvider: () => 'EXPIRED',
        onUnauthorized: () async => unauthorizedCalled++,
        httpClient: MockClient((request) async {
          return http.Response(
            jsonEncode({'status': 401, 'payload': 'Unauthorized'}),
            401,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await expectLater(
        client.get('/children/all'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.isUnauthorized, 'isUnauthorized', isTrue),
        ),
      );
      expect(unauthorizedCalled, 1);
    });

    test('401 kutoka HTTP pekee (bila status ya ndani) pia inashughulikiwa',
        () async {
      var unauthorizedCalled = 0;
      final client = ApiClient(
        baseUrl: 'http://test.local/api/v1',
        tokenProvider: () => 'EXPIRED',
        onUnauthorized: () async => unauthorizedCalled++,
        httpClient: MockClient((request) async {
          return http.Response('', 401);
        }),
      );

      await expectLater(
        client.post('/trips/start', body: {'trip_id': 1}),
        throwsA(isA<ApiException>()),
      );
      expect(unauthorizedCalled, 1);
    });

    test('403 hairudishi mtumiaji nje (hana ruhusa tu)', () async {
      var unauthorizedCalled = 0;
      final client = ApiClient(
        baseUrl: 'http://test.local/api/v1',
        tokenProvider: () => 'VALID',
        onUnauthorized: () async => unauthorizedCalled++,
        httpClient: MockClient((request) async {
          return http.Response(
            jsonEncode({'status': 403, 'payload': 'Forbidden'}),
            403,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await expectLater(
        client.get('/schools/all'),
        throwsA(
          isA<ApiException>().having((e) => e.isForbidden, 'isForbidden', isTrue),
        ),
      );
      expect(unauthorizedCalled, 0);
    });

    test('makosa mengine yanarudisha ujumbe wa server', () async {
      final client = ApiClient(
        baseUrl: 'http://test.local/api/v1',
        tokenProvider: () => 'VALID',
        onUnauthorized: () async {},
        httpClient: MockClient((request) async {
          return http.Response(
            jsonEncode({'status': 500, 'payload': 'Failed'}),
            500,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await expectLater(
        client.put('/children/update', body: {'id': 1}),
        throwsA(
          isA<ApiException>().having((e) => e.message, 'message', 'Failed'),
        ),
      );
    });
  });
}
