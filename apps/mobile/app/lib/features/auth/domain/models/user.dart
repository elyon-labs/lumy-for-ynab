import 'package:oxidized/oxidized.dart';

import '../../../../ynab_api/oauth/ynab_access_token.dart';

sealed class User {
  User({required this.accessToken});

  // It's possible for an [UnauthenticatedUser] to have an access token if they
  // they were an existing user when the authentication model was changed to be
  // based on Supabase. Eventually, we can bump the minimum supported version
  // of the app to 1.24.0 and move this to be a field only on [AuthenticatedUser].
  final Option<YnabAccessToken> accessToken;
}

class AuthenticatedUser extends User {
  AuthenticatedUser({
    required this.id,
    required super.accessToken,
    required this.isAnonymous,
    this.email,
    this.pendingEmail,
  });

  final String id;
  final bool isAnonymous;
  final String? email;
  final String? pendingEmail;
}

class UnauthenticatedUser extends User {
  UnauthenticatedUser({required super.accessToken});
}

extension UserX on User {
  bool get isAuthenticated => this is AuthenticatedUser;
}
