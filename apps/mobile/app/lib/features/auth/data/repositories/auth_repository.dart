import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../../ynab_api/oauth/ynab_access_token.dart';
import '../../../../ynab_api/oauth/ynab_auth_helper.dart';
import '../../domain/models/user.dart';
import '../api/auth_api.dart';

class AuthRepository {
  AuthRepository({required AuthApi api}) : _api = api {
    _watchUser();
  }

  factory AuthRepository.create() {
    return AuthRepository(api: inject());
  }

  final AuthApi _api;

  late final _subject = BehaviorSubject<User>.seeded(_api.currentUser);

  Stream<User> get watch => _subject.stream;

  final _subs = CompositeSubscription();

  void _watchUser() {
    _subs.add(_api.watchUser().listen(_subject.add));
  }

  Future<void> dispose() async {
    await _subject.close();
    await _subs.dispose();
  }

  Future<Result<String, Exception>> upsertUser({
    required String id,
    required String? ynabUserId,
    required String? email,
  }) {
    return _api.upsertUser(id: id, ynabUserId: ynabUserId, email: email);
  }

  Future<Result<void, Exception>> logInWithEmail({
    required String email,
    required String redirectUri,
  }) {
    return _api.logInWithEmail(email: email, redirectUri: redirectUri);
  }

  Future<Result<void, Exception>> linkEmail({required String email, required String redirectUri}) {
    return _api.linkEmail(email: email, redirectUri: redirectUri);
  }

  Future<Result<void, Exception>> changeEmail({
    required String email,
    required String redirectUri,
  }) {
    return _api.changeEmail(email: email, redirectUri: redirectUri);
  }

  Future<Result<void, Exception>> logInAnonymously() {
    return _api.logInAnonymously();
  }

  Future<Result<void, Exception>> logOut() {
    return _api.logOut();
  }

  Future<Result<YnabAccessToken, Exception>> requestYnabAccessToken({
    required bool includeWriteScope,
  }) {
    return _api.requestYnabAccessToken(includeWriteScope: includeWriteScope);
  }

  Future<Result<RefreshTokenOutcome, Exception>> refreshYnabAccessToken() async {
    return _api.refreshYnabAccessToken();
  }

  Future<Result<void, Exception>> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _api.logInWithEmailAndPassword(email: email, password: password);
  }

  Future<Result<void, Exception>> removeYnabAccessToken() async {
    return _api.removeYnabAccessToken();
  }
}
