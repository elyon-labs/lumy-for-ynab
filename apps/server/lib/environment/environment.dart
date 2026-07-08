import 'package:dotenv/dotenv.dart';

class ServerEnvironment {
  final String tokenUrl;
  final String redirectUri;
  final String clientId;
  final String clientSecret;
  final String baseUrl;
  final String allowedCorsOrigin;

  ServerEnvironment({
    required this.tokenUrl,
    required this.redirectUri,
    required this.clientId,
    required this.clientSecret,
    required this.baseUrl,
    required this.allowedCorsOrigin,
  });

  factory ServerEnvironment.fromDotEnv(DotEnv env) {
    return ServerEnvironment(
      tokenUrl: env['YNAB_TOKEN_URL']!,
      redirectUri: env['OAUTH_REDIRECT_URI']!,
      clientId: env['CLIENT_ID']!,
      clientSecret: env['CLIENT_SECRET']!,
      baseUrl: env['YNAB_BASE_URL']!,
      allowedCorsOrigin: env['ALLOWED_CORS_ORIGIN']!,
    );
  }
}
