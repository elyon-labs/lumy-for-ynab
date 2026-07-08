import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/auth_repository.dart';

class RemoveYnabAccessToken {
  RemoveYnabAccessToken({required AuthRepository authRepository})
    : _authRepository = authRepository;

  factory RemoveYnabAccessToken.create() {
    return RemoveYnabAccessToken(authRepository: inject());
  }

  final AuthRepository _authRepository;

  Future<Result<void, Exception>> call() async {
    final result = await _authRepository.removeYnabAccessToken();

    return result;
  }
}
