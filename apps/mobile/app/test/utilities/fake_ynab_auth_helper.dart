import 'package:lumy/ynab_api/oauth/ynab_access_token.dart';
import 'package:lumy/ynab_api/oauth/ynab_auth_helper.dart';
import 'package:oxidized/src/result.dart';
import 'package:rxdart/rxdart.dart';

class FakeYnabAuthHelper implements YnabAuthHelper {
  @override
  Future<Result<YnabAccessToken, Exception>> fetchToken({required bool includeWriteScope}) async {
    return Ok(
      YnabAccessToken(
        accessToken: 'MTQ0NjJkZmQ5OTM2NDE1ZTZjNGZmZjI3',
        expiresIn: 3600,
        refreshToken: 'IwOGYzYTlmM2YxOTQ5MGE3YmNmMDFkNTVk',
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        scope: 'public',
      ),
    );
  }

  @override
  Future<YnabAccessToken?> get future => Future.value(accessToken.value);

  @override
  ValueStream<YnabAccessToken?> get accessToken {
    return Stream.value(null).shareValue();
  }

  @override
  ValueStream<bool> watchHasAccessToken() {
    return Stream.value(true).shareValue();
  }

  @override
  Future<Result<RefreshTokenOutcome, Exception>> refreshToken() async {
    return Ok(
      RefreshTokenSuccess(
        YnabAccessToken(
          accessToken: 'MTQ0NjJkZmQ5OTM2NDE1ZTZjNGZmZjI3',
          expiresIn: 3600,
          refreshToken: 'IwOGYzYTlmM2YxOTQ5MGE3YmNmMDFkNTVk',
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          scope: 'public',
        ),
      ),
    );
  }

  @override
  void complete(YnabAccessToken? value) {
    // Do nothing.
  }

  @override
  Future<void> close() async {
    // Do nothing.
  }

  @override
  Future<void> unauthenticate() async {
    // Do nothing.
  }
}
