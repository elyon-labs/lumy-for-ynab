import 'dart:convert';

import 'package:charlatan/charlatan.dart';
import 'package:dio/dio.dart';
import 'package:server/endpoints/get_token.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../factories/server_environment_factory.dart';

void main() {
  group('GetToken', () {
    group('when grant_type is refresh_token', () {
      test('it makes the correct request to YNAB', () async {
        final clientRequest = Request(
          'POST',
          Uri.parse('http://localhost:8080/token'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-User-Id': 'user-id',
            'X-App-Version': 'app-version',
          },
          body:
              Uri(
                queryParameters: {
                  'client_id': 'abcd12345client',
                  'refresh_token': 'old-refresh-token',
                  'grant_type': 'refresh_token',
                  'redirect_uri': 'oauth://lumy',
                  'scope': 'read-only',
                },
              ).query,
        );

        final environment = ServerEnvironmentFactory.create(
          tokenUrl: 'https://ynab.com/token',
          redirectUri: 'oauth://lumy',
          baseUrl: 'https://ynab.com',
        );

        late final CharlatanHttpRequest serverRequest;

        final charlatan =
            Charlatan()
              // Using `whenMatch` because Charlatan doesn't support form-urlencoded requests
              ..whenMatch((req) => req.method == 'POST', (req) {
                serverRequest = req;
                return CharlatanHttpResponse(
                  statusCode: 200,
                  body: {
                    'token_type': 'bearer',
                    'access_token': 'new-access-token',
                    'refresh_token': 'new-refresh-token',
                    'created_at': 1234567890,
                    'expires_in': 1234567890,
                    'scope': 'read-only',
                  },
                );
              });

        final client = Dio(BaseOptions(baseUrl: 'https://ynab.com'))
          ..httpClientAdapter = charlatan.toFakeHttpClientAdapter();

        final subject = GetToken(environment: environment, httpClient: client);

        final response = await subject.call(clientRequest);

        expect(serverRequest, isNotNull);

        expect(serverRequest.queryParameters, {
          'client_id': environment.clientId,
          'client_secret': environment.clientSecret,
          'grant_type': 'refresh_token',
          'refresh_token': 'old-refresh-token',
        });

        expect(response.statusCode, 200);

        expect(jsonDecode(await response.readAsString()), {
          'access_token': 'new-access-token',
          'token_type': 'bearer',
          'expires_in': 1234567890,
          'refresh_token': 'new-refresh-token',
          'scope': 'read-only',
          'created_at': 1234567890,
        });
      });
    });

    group('when grant_type is authorization_code', () {
      test('it makes the correct request to YNAB', () async {
        final clientRequest = Request(
          'POST',
          Uri.parse('http://localhost:8080/token'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-User-Id': 'user-id',
            'X-App-Version': 'app-version',
          },
          body:
              Uri(
                queryParameters: {
                  'client_id': 'abcd12345client',
                  'code': 'auth-code',
                  'grant_type': 'authorization_code',
                  'redirect_uri': 'com.brandontrautmann.lumy://fake-redirect',
                  'scope': 'read-only',
                },
              ).query,
        );

        final environment = ServerEnvironmentFactory.create(
          tokenUrl: 'https://ynab.com/token',
        );

        late final CharlatanHttpRequest serverRequest;

        final charlatan =
            Charlatan()
              // Using `whenMatch` because Charlatan doesn't support form-urlencoded requests
              ..whenMatch((req) => req.method == 'POST', (req) {
                serverRequest = req;
                return CharlatanHttpResponse(
                  statusCode: 200,
                  body: {
                    'token_type': 'bearer',
                    'access_token': 'new-access-token',
                    'refresh_token': 'new-refresh-token',
                    'created_at': 1234567890,
                    'expires_in': 1234567890,
                    'scope': 'read-only',
                  },
                );
              });

        final client = Dio(BaseOptions(baseUrl: 'https://ynab.com'))
          ..httpClientAdapter = charlatan.toFakeHttpClientAdapter();

        final subject = GetToken(environment: environment, httpClient: client);

        final response = await subject.call(clientRequest);

        expect(serverRequest, isNotNull);

        expect(serverRequest.queryParameters, {
          'client_id': environment.clientId,
          'client_secret': environment.clientSecret,
          'grant_type': 'authorization_code',
          'code': 'auth-code',
          'redirect_uri': 'com.brandontrautmann.lumy://fake-redirect',
        });

        expect(response.statusCode, 200);

        expect(jsonDecode(await response.readAsString()), {
          'access_token': 'new-access-token',
          'token_type': 'bearer',
          'expires_in': 1234567890,
          'refresh_token': 'new-refresh-token',
          'scope': 'read-only',
          'created_at': 1234567890,
        });
      });
    });

    group('when ynab returns an error', () {
      test('it forwards the error', () async {
        final clientRequest = Request(
          'POST',
          Uri.parse('http://localhost:8080/token'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-User-Id': 'user-id',
            'X-App-Version': 'app-version',
          },
          body:
              Uri(
                queryParameters: {
                  'client_id': 'abcd12345client',
                  'refresh_token': 'old-refresh-token',
                  'grant_type': 'refresh_token',
                  'redirect_uri': 'oauth://lumy',
                  'scope': 'read-only',
                },
              ).query,
        );

        final environment = ServerEnvironmentFactory.create(
          tokenUrl: 'https://ynab.com/token',
          redirectUri: 'oauth://lumy',
          baseUrl: 'https://ynab.com',
        );

        late final CharlatanHttpRequest serverRequest;

        final charlatan =
            Charlatan()
              // Using `whenMatch` because Charlatan doesn't support form-urlencoded requests
              ..whenMatch((req) => req.method == 'POST', (req) {
                serverRequest = req;
                return CharlatanHttpResponse(
                  statusCode: 400,
                  body: {
                    'error': 'This is a bad request blah blah blah',
                    'error_description': 'This describes the error',
                  },
                );
              });

        final client = Dio(BaseOptions(baseUrl: 'https://ynab.com'))
          ..httpClientAdapter = charlatan.toFakeHttpClientAdapter();

        final subject = GetToken(environment: environment, httpClient: client);

        final response = await subject.call(clientRequest);

        expect(serverRequest, isNotNull);

        expect(response.statusCode, 400);

        expect(jsonDecode(await response.readAsString()), {
          'error': 'This is a bad request blah blah blah',
          'error_description': 'This describes the error',
        });
      });
    });
  });
}
