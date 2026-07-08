import 'package:oxidized/oxidized.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../../../app/di.dart';
import '../../../../app/environment/environment.dart';
import '../../../../persistence/settings.dart';
import '../../data/repositories/auth_repository.dart';

class ChangeEmail {
  ChangeEmail({
    required AuthRepository authRepository,
    required Settings settings,
    required Environment environment,
  }) : _authRepository = authRepository,
       _settings = settings,
       _environment = environment;

  factory ChangeEmail.create() {
    return ChangeEmail(authRepository: inject(), settings: inject(), environment: inject());
  }

  final AuthRepository _authRepository;
  final Settings _settings;
  final Environment _environment;

  Future<Result<void, Exception>> call({required String email}) async {
    String buildRedirectUri() {
      const path = '/settings/sync-status?email-change-confirmed=true';
      if (UniversalPlatform.isWeb) {
        return '${_environment.webDeeplinkUri}$path';
      } else {
        return '${_environment.mobileDeeplinkUri}$path';
      }
    }

    final result = await _authRepository.changeEmail(email: email, redirectUri: buildRedirectUri());

    if (result.isOk()) {
      await _settings.setMagicLinkSentTimestamp();
    }

    return result;
  }
}
