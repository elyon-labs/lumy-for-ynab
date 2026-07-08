import 'package:lumy/app/environment/environment.dart';

abstract class EnvironmentFactory {
  static Environment build({
    String? name,
    String? logLevel,
    String? authorizationUrl,
    String? tokenUrl,
    String? mobileDeeplinkUri,
    String? webDeeplinkUri,
    String? customUriScheme,
    String? clientId,
    String? ynabBaseUrl,
    String? feedbackBoardUrl,
    String? feedbackWebhook,
    String? communityServerUrl,
    String? androidStoreUrl,
    String? iosStoreUrl,
    String? supabaseUrl,
    String? supabaseAnonKey,
    String? supportEmail,
  }) {
    return Environment(
      name: name ?? '',
      logLevel: logLevel ?? 'off',
      authorizationUrl: authorizationUrl ?? '',
      tokenUrl: tokenUrl ?? '',
      mobileDeeplinkUri: mobileDeeplinkUri ?? '',
      webDeeplinkUri: webDeeplinkUri ?? '',
      clientId: clientId ?? '',
      ynabBaseUrl: ynabBaseUrl ?? '',
      feedbackBoardUrl: feedbackBoardUrl ?? '',
      feedbackWebhook: feedbackWebhook ?? '',
      communityServerUrl: communityServerUrl ?? '',
      androidStoreUrl: androidStoreUrl ?? '',
      iosStoreUrl: iosStoreUrl ?? '',
      supabaseUrl: supabaseUrl ?? '',
      supabaseAnonKey: supabaseAnonKey ?? '',
      supportEmail: supportEmail ?? '',
    );
  }
}
