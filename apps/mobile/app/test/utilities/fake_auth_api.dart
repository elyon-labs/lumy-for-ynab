import 'package:lumy/features/auth/data/api/auth_api.dart';
import 'package:lumy/features/auth/domain/models/user.dart';
import 'package:lumy/ynab_api/oauth/ynab_access_token.dart';
import 'package:lumy/ynab_api/oauth/ynab_auth_helper.dart';
import 'package:oxidized/oxidized.dart';

import '../factory/ynab_access_token_factory.dart';

typedef EmailRedirectCallback = void Function({required String email, required String redirectUri});
typedef EmailPasswordCallback = void Function({required String email, required String password});

class FakeAuthApi implements AuthApi {
  FakeAuthApi({
    User? currentUser,
    User? watchedUser,
    this.onChangeEmail,
    this.onLinkEmail,
    this.onLogInAnonymously,
    this.onLogInWithEmail,
    this.onLogInWithEmailAndPassword,
    this.onLogOut,
    this.onRemoveYnabAccessToken,
    this.changeEmailResult = const Ok(null),
    this.linkEmailResult = const Ok(null),
    this.logInAnonymouslyResult = const Ok(null),
    this.logInWithEmailResult = const Ok(null),
    this.logInWithEmailAndPasswordResult = const Ok(null),
    this.logOutResult = const Ok(null),
    this.removeYnabAccessTokenResult = const Ok(null),
  }) : currentUser = currentUser ?? _defaultUser,
       watchedUser = watchedUser ?? currentUser ?? _defaultUser;

  static final _defaultUser = AuthenticatedUser(
    id: 'fake-user',
    accessToken: Some(YnabAccessTokenFactory.build()),
    isAnonymous: false,
  );

  @override
  final User currentUser;

  final User watchedUser;
  final Result<void, Exception> changeEmailResult;
  final Result<void, Exception> linkEmailResult;
  final Result<void, Exception> logInAnonymouslyResult;
  final Result<void, Exception> logInWithEmailResult;
  final Result<void, Exception> logInWithEmailAndPasswordResult;
  final Result<void, Exception> logOutResult;
  final Result<void, Exception> removeYnabAccessTokenResult;

  final EmailRedirectCallback? onChangeEmail;
  final EmailRedirectCallback? onLinkEmail;
  final void Function()? onLogInAnonymously;
  final EmailRedirectCallback? onLogInWithEmail;
  final EmailPasswordCallback? onLogInWithEmailAndPassword;
  final void Function()? onLogOut;
  final void Function()? onRemoveYnabAccessToken;

  @override
  Future<Result<void, Exception>> changeEmail({
    required String email,
    required String redirectUri,
  }) {
    onChangeEmail?.call(email: email, redirectUri: redirectUri);
    return Future.value(changeEmailResult);
  }

  @override
  Future<Result<void, Exception>> linkEmail({required String email, required String redirectUri}) {
    onLinkEmail?.call(email: email, redirectUri: redirectUri);
    return Future.value(linkEmailResult);
  }

  @override
  Future<Result<void, Exception>> logInAnonymously() {
    onLogInAnonymously?.call();
    return Future.value(logInAnonymouslyResult);
  }

  @override
  Future<Result<void, Exception>> logInWithEmail({
    required String email,
    required String redirectUri,
  }) {
    onLogInWithEmail?.call(email: email, redirectUri: redirectUri);
    return Future.value(logInWithEmailResult);
  }

  @override
  Future<Result<void, Exception>> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    onLogInWithEmailAndPassword?.call(email: email, password: password);
    return Future.value(logInWithEmailAndPasswordResult);
  }

  @override
  Future<Result<void, Exception>> logOut() {
    onLogOut?.call();
    return Future.value(logOutResult);
  }

  @override
  Future<Result<RefreshTokenOutcome, Exception>> refreshYnabAccessToken() {
    return Future.value(Ok(RefreshTokenSuccess(YnabAccessTokenFactory.build())));
  }

  @override
  Future<Result<YnabAccessToken, Exception>> requestYnabAccessToken({
    required bool includeWriteScope,
  }) {
    return Future.value(Ok(YnabAccessTokenFactory.build()));
  }

  @override
  Future<Result<void, Exception>> removeYnabAccessToken() {
    onRemoveYnabAccessToken?.call();
    return Future.value(removeYnabAccessTokenResult);
  }

  @override
  Future<Result<String, Exception>> upsertUser({
    required String id,
    required String? ynabUserId,
    required String? email,
  }) {
    return Future.value(Ok(id));
  }

  @override
  Stream<User> watchUser() {
    return Stream.value(watchedUser);
  }

  @override
  Future<Result<T, Exception>> withAuthenticatedUser<T>(
    Future<Result<T, Exception>> Function(AuthenticatedUser user) action,
  ) {
    return Future.value(action(currentUser as AuthenticatedUser));
  }
}
