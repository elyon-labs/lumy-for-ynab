import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/auth_repository.dart';

class LogInAnonymously {
  LogInAnonymously({required AuthRepository authRepository}) : _authRepository = authRepository;

  factory LogInAnonymously.create() {
    return LogInAnonymously(authRepository: inject());
  }

  final AuthRepository _authRepository;

  Future<Result<void, Exception>> call() async {
    final result = await _authRepository.logInAnonymously();

    return result;
  }
}
