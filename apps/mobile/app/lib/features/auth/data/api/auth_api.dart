import 'dart:async';

import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../../../app/di.dart';
import '../../../../ynab_api/oauth/ynab_access_token.dart';
import '../../../../ynab_api/oauth/ynab_auth_helper.dart';
import '../../domain/models/user.dart';
import 'models/upsert_user.dart';

class AuthApi {
  AuthApi({required YnabAuthHelper authHelper, required SupabaseClient client})
    : _client = client,
      _authHelper = authHelper;

  factory AuthApi.create() {
    return AuthApi(authHelper: inject(), client: inject());
  }

  final YnabAuthHelper _authHelper;
  final SupabaseClient _client;

  User get currentUser {
    final user = _client.auth.currentUser;
    final accessToken = Option.from(_authHelper.accessToken.valueOrNull);
    if (user != null) {
      return AuthenticatedUser(
        id: user.id,
        isAnonymous: user.isAnonymous,
        email: user.email,
        pendingEmail: user.newEmail,
        accessToken: accessToken,
      );
    } else {
      return UnauthenticatedUser(accessToken: accessToken);
    }
  }

  Stream<User> watchUser() {
    final accessTokenStream = _authHelper.accessToken;
    final supabaseUserStream = _client.auth.onAuthStateChange.map((event) => event.session?.user);

    return Rx.combineLatest2(accessTokenStream, supabaseUserStream, (accessToken, user) {
      if (user != null) {
        return AuthenticatedUser(
          id: user.id,
          isAnonymous: user.isAnonymous,
          email: user.email,
          pendingEmail: user.newEmail,
          accessToken: Option.from(accessToken),
        );
      } else {
        return UnauthenticatedUser(accessToken: Option.from(accessToken));
      }
    });
  }

  Future<Result<String, Exception>> upsertUser({
    required String id,
    required String? ynabUserId,
    required String? email,
  }) {
    return Result.asyncOf(() async {
      final upsertUser = UpsertUser(id: id, ynabUserId: ynabUserId, email: email);
      final response = await _client.from('users').upsert(upsertUser.toMap()).select('id').single();

      return response['id'] as String;
    });
  }

  Future<Result<void, Exception>> logInWithEmail({
    required String email,
    required String redirectUri,
  }) {
    return Result.asyncOf(() async {
      return await _client.auth.signInWithOtp(email: email, emailRedirectTo: redirectUri);
    });
  }

  Future<Result<void, Exception>> logInAnonymously() {
    return Result.asyncOf(() async {
      final response = await _client.auth.signInAnonymously();
      if (response.session == null) throw Exception('Failed to log in, session null');
    });
  }

  Future<Result<void, Exception>> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return Result.asyncOf(() async {
      final response = await _client.auth.signInWithPassword(email: email, password: password);
      if (response.session == null) throw Exception('Failed to log in, session null');
    });
  }

  Future<Result<void, Exception>> linkEmail({required String email, required String redirectUri}) {
    return Result.asyncOf(() async {
      await _client.auth.updateUser(UserAttributes(email: email), emailRedirectTo: redirectUri);
    });
  }

  Future<Result<void, Exception>> changeEmail({
    required String email,
    required String redirectUri,
  }) {
    return Result.asyncOf(() async {
      await _client.auth.updateUser(UserAttributes(email: email), emailRedirectTo: redirectUri);
    });
  }

  Future<Result<void, Exception>> logOut() {
    return Result.asyncOf(() async {
      await _client.auth.signOut();
      await _authHelper.unauthenticate();
    });
  }

  Future<Result<YnabAccessToken, Exception>> requestYnabAccessToken({
    required bool includeWriteScope,
  }) async {
    return _authHelper.fetchToken(includeWriteScope: includeWriteScope);
  }

  Future<Result<RefreshTokenOutcome, Exception>> refreshYnabAccessToken() async {
    return _authHelper.refreshToken();
  }

  Future<Result<T, Exception>> withAuthenticatedUser<T>(
    Future<Result<T, Exception>> Function(AuthenticatedUser user) action,
  ) async {
    final user = currentUser;
    if (user is AuthenticatedUser) {
      return await action(user);
    } else {
      return Err(Exception('User is not authenticated'));
    }
  }

  Future<Result<void, Exception>> removeYnabAccessToken() async {
    return Result.asyncOf(() async {
      await _authHelper.unauthenticate();
    });
  }
}

extension AuthApiX on AuthApi {
  StreamSubscription<void> onAuthenticated(Function() callback) {
    return watchUser().listen((user) {
      if (user is AuthenticatedUser) {
        callback();
      }
    });
  }
}
