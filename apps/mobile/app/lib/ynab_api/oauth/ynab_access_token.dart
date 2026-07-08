import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'ynab_access_token.mapper.dart';

/// A token used for authenticating with the YNAB API.
@MappableClass()
class YnabAccessToken extends Equatable with YnabAccessTokenMappable {
  const YnabAccessToken({
    required this.accessToken,
    required this.refreshToken,
    required this.createdAt,
    required this.expiresIn,
    required this.scope,
  });

  final String accessToken;
  final String refreshToken;
  final int createdAt;
  final int expiresIn;
  final String scope;

  static String readOnlyScope = 'read-only';
  static String writeScope = 'public';

  @override
  List<Object?> get props => [accessToken, refreshToken, createdAt, expiresIn, scope];
}

extension YnabAccessTokenX on YnabAccessToken {
  bool get hasWriteAccess => scope.contains(YnabAccessToken.writeScope);
}
