import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../data/repositories/auth_repository.dart';

class UpsertUser {
  UpsertUser({required AuthRepository authRepository}) : _authRepository = authRepository;

  factory UpsertUser.create() {
    return UpsertUser(authRepository: inject());
  }

  final AuthRepository _authRepository;

  Future<Result<String, Exception>> call({
    required String id,
    required String? ynabUserId,
    required String? email,
  }) {
    return _authRepository.upsertUser(id: id, ynabUserId: ynabUserId, email: email);
  }
}
