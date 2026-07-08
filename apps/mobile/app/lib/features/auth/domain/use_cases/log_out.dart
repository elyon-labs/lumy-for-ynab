import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../../../persistence/drift/local_database.dart';
import '../../../../persistence/settings.dart';
import '../../data/repositories/auth_repository.dart';

class LogOut {
  LogOut({
    required AuthRepository authRepository,
    required LocalDatabase localDatabase,
    required Settings settings,
  }) : _authRepository = authRepository,
       _localDatabase = localDatabase,
       _settings = settings;

  factory LogOut.create() {
    return LogOut(authRepository: inject(), localDatabase: inject(), settings: inject());
  }

  final AuthRepository _authRepository;
  final LocalDatabase _localDatabase;
  final Settings _settings;

  Future<Result<void, Exception>> call() async {
    final result = await _authRepository.logOut();

    if (result.isOk()) {
      await _localDatabase.clearData();
      await _settings.clear();
    }

    return result;
  }
}
