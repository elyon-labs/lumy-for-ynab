import 'package:faker/faker.dart';
import 'package:lumy/ynab_api/oauth/ynab_access_token.dart';

final _faker = Faker();

abstract class YnabAccessTokenFactory {
  static YnabAccessToken build({String? accessToken, String? refreshToken, int? expiresIn}) {
    return YnabAccessToken(
      accessToken: accessToken ?? _faker.guid.guid(),
      refreshToken: refreshToken ?? _faker.guid.guid(),
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      expiresIn:
          expiresIn ??
          DateTime.now().add(const Duration(hours: 1)).difference(DateTime.now()).inSeconds,
      scope: 'public',
    );
  }
}
