import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:dio/dio.dart' as dio;
import 'package:server/environment/environment.dart';
import 'package:shelf/shelf.dart';

part 'get_token.mapper.dart';

const refreshTokenGrantType = 'refresh_token';
const authorizationCodeGrantType = 'authorization_code';

class GetToken {
  final ServerEnvironment environment;
  final dio.Dio httpClient;

  GetToken({required this.environment, required this.httpClient});

  Future<Response> call(Request request) async {
    final requestAsString = await request.readAsString();
    final queryAsMap = Uri.splitQueryString(requestAsString);

    // Read the query parameters from the request body
    final code = queryAsMap['code'];
    final grantType = queryAsMap['grant_type'];
    final refreshToken = queryAsMap['refresh_token'];
    // Use client-provided redirect URI or fallback to environment variable
    final redirectUri = queryAsMap['redirect_uri'] ?? environment.redirectUri;

    // Read the headers from the request
    final headers = request.headers;
    final userId = headers['X-User-Id'];
    final appVersion = headers['X-App-Version'];

    final clientId = environment.clientId;
    final clientSecret = environment.clientSecret;

    print('Received request for grant_type $grantType');
    print('Code is ${code == null ? 'null' : code.obfuscateKeeping(4)}');
    print(
      'Refresh token is ${refreshToken == null ? 'null' : refreshToken.obfuscateKeeping(4)}',
    );
    print('Redirect URI is $redirectUri');
    print('User ID is $userId');
    print('App version is $appVersion');

    try {
      final response = await httpClient.request(
        environment.tokenUrl,
        options: dio.Options(
          method: 'POST',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        queryParameters: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': grantType,
          if (grantType == authorizationCodeGrantType) 'code': code,
          if (grantType == authorizationCodeGrantType)
            'redirect_uri': redirectUri,
          if (grantType == refreshTokenGrantType) 'refresh_token': refreshToken,
        },
      );
      print('Response from YNAB is ${response.statusCode}');
      return Response.ok(
        jsonEncode(GetTokenMetaResponseMapper.fromMap(response.data).toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on dio.DioException catch (e) {
      print('DioException caught, returning status ${e.response?.statusCode}');
      print('Body from YNAB is ${e.response?.data}');
      final body = e.response?.data as Map<String, dynamic>? ?? {};
      return Response(
        e.response?.statusCode ?? 500,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'error': body['error'] as String? ?? 'server_error',
          'error_description':
              body['error_description'] as String? ??
              'An error occurred while trying to get a token from YNAB.',
        }),
      );
    }
  }
}

extension on String {
  String obfuscateKeeping(int keep) {
    if (keep >= length) return this;

    final visible = substring(0, keep);
    final stars = '*' * (length - keep);
    return visible + stars;
  }
}

@MappableClass()
class GetTokenMetaResponse with GetTokenMetaResponseMappable {
  @MappableField(key: 'access_token')
  final String accessToken;
  @MappableField(key: 'token_type')
  final String tokenType;
  @MappableField(key: 'expires_in')
  final int expiresIn;
  @MappableField(key: 'refresh_token')
  final String refreshToken;
  final String scope;
  @MappableField(key: 'created_at')
  final int createdAt;

  GetTokenMetaResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
    required this.scope,
    required this.createdAt,
  });
}
