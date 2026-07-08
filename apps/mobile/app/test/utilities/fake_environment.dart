import 'package:lumy/app/environment/environment.dart';

class FakeEnvironment implements Environment {
  @override
  String get name => throw UnimplementedError();

  @override
  String get logLevel => throw UnimplementedError();

  @override
  String get authorizationUrl => throw UnimplementedError();

  @override
  String get clientId => throw UnimplementedError();

  @override
  String get communityServerUrl => throw UnimplementedError();

  @override
  String get feedbackBoardUrl => throw UnimplementedError();

  @override
  String get feedbackWebhook => throw UnimplementedError();

  @override
  String get mobileDeeplinkUri => throw UnimplementedError();

  @override
  String get webDeeplinkUri => throw UnimplementedError();

  @override
  String get tokenUrl => throw UnimplementedError();

  @override
  String get ynabBaseUrl => throw UnimplementedError();

  @override
  String get androidStoreUrl => throw UnimplementedError();

  @override
  String get iosStoreUrl => throw UnimplementedError();

  @override
  String get supabaseUrl => throw UnimplementedError();

  @override
  String get supabaseAnonKey => throw UnimplementedError();

  @override
  String get supportEmail => throw UnimplementedError();
}
