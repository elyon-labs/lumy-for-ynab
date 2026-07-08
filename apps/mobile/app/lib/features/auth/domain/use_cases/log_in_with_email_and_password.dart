import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/auth_repository.dart';

class LogInWithEmailAndPassword {
  LogInWithEmailAndPassword({required AuthRepository authRepository})
    : _authRepository = authRepository;

  factory LogInWithEmailAndPassword.create() {
    return LogInWithEmailAndPassword(authRepository: inject());
  }

  final AuthRepository _authRepository;

  Future<Result<void, Exception>> call({required String email, required String password}) async {
    final result = await _authRepository.logInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result;
  }
}
