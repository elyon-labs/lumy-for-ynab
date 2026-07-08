import 'package:oxidized/oxidized.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../../../app/di.dart';
import '../../../../app/environment/environment.dart';
import '../../../../persistence/settings.dart';
import '../../data/repositories/auth_repository.dart';

class LogInWithEmail {
  LogInWithEmail({
    required AuthRepository authRepository,
    required Settings settings,
    required Environment environment,
  }) : _authRepository = authRepository,
       _settings = settings,
       _environment = environment;

  factory LogInWithEmail.create() {
    return LogInWithEmail(authRepository: inject(), settings: inject(), environment: inject());
  }

  final AuthRepository _authRepository;
  final Settings _settings;
  final Environment _environment;

  Future<Result<void, Exception>> call({required String email}) async {
    String buildRedirectUri() {
      if (UniversalPlatform.isWeb) {
        return '${_environment.webDeeplinkUri}/budget';
      } else {
        return '${_environment.mobileDeeplinkUri}/budget';
      }
    }

    final result = await _authRepository.logInWithEmail(
      email: email,
      redirectUri: buildRedirectUri(),
    );

    if (result.isOk()) {
      await _settings.setMagicLinkSentTimestamp();
    }

    return result;
  }
}
