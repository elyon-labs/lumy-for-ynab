import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../../../ynab_api/oauth/ynab_access_token.dart';
import '../../data/repositories/auth_repository.dart';

class RequestYnabAccessToken {
  RequestYnabAccessToken({required AuthRepository authRepository})
    : _authRepository = authRepository;

  factory RequestYnabAccessToken.create() {
    return RequestYnabAccessToken(authRepository: inject());
  }

  final AuthRepository _authRepository;

  Future<Result<YnabAccessToken, Exception>> call({required bool includeWriteScope}) async {
    final result = await _authRepository.requestYnabAccessToken(
      includeWriteScope: includeWriteScope,
    );

    return result;
  }
}
