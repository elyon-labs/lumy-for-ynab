import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../../../ynab_api/oauth/ynab_auth_helper.dart';
import '../../data/repositories/auth_repository.dart';

class RefreshYnabAccessToken {
  RefreshYnabAccessToken({required AuthRepository authRepository})
    : _authRepository = authRepository;

  factory RefreshYnabAccessToken.create() {
    return RefreshYnabAccessToken(authRepository: inject());
  }

  final AuthRepository _authRepository;

  Future<Result<RefreshTokenOutcome, Exception>> call() async {
    final result = await _authRepository.refreshYnabAccessToken();

    return result;
  }
}
