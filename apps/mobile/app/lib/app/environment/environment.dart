import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class Environment {
  Environment({
    required this.name,
    required this.logLevel,
    required this.authorizationUrl,
    required this.tokenUrl,
    required this.mobileDeeplinkUri,
    required this.webDeeplinkUri,
    required this.clientId,
    required this.ynabBaseUrl,
    required this.communityServerUrl,
    required this.androidStoreUrl,
    required this.iosStoreUrl,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.supportEmail,
  });

  factory Environment.fromDotEnv(DotEnv env) {
    return Environment(
      name: env.get('ENVIRONMENT_NAME'),
      logLevel: env.get('LOG_LEVEL', fallback: Level.off.name),
      authorizationUrl: env.get('YNAB_AUTHORIZE_URL'),
      tokenUrl: env.get('YNAB_TOKEN_URL'),
      mobileDeeplinkUri: env.get('MOBILE_DEEPLINK_URI'),
      webDeeplinkUri: env.get('WEB_DEEPLINK_URI'),
      clientId: env.get('CLIENT_ID'),
      ynabBaseUrl: env.get('YNAB_BASE_URL'),
      communityServerUrl: env.get('COMMUNITY_SERVER_URL'),
      androidStoreUrl: env.get('ANDROID_STORE_URL'),
      iosStoreUrl: env.get('IOS_STORE_URL'),
      supabaseUrl: env.get('SUPABASE_URL'),
      supabaseAnonKey: env.get('SUPABASE_ANON_KEY'),
      supportEmail: env.get('SUPPORT_EMAIL'),
    );
  }

  final String name;
  final String logLevel;
  final String authorizationUrl;
  final String tokenUrl;
  final String mobileDeeplinkUri;
  final String webDeeplinkUri;
  final String clientId;
  final String ynabBaseUrl;
  final String communityServerUrl;
  final String androidStoreUrl;
  final String iosStoreUrl;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String supportEmail;
}

Environment parseEnvironment() {
  // ignore: do_not_use_environment
  const injectedEnvironment = String.fromEnvironment('ENVIRONMENT');
  final dotEnv = DotEnv();
  final decoded = base64Decode(injectedEnvironment);
  dotEnv.testLoad(fileInput: String.fromCharCodes(decoded));
  return Environment.fromDotEnv(dotEnv);
}
