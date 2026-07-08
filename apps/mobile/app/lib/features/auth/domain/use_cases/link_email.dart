import 'package:oxidized/oxidized.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../../../app/di.dart';
import '../../../../app/environment/environment.dart';
import '../../../../persistence/settings.dart';
import '../../data/repositories/auth_repository.dart';

class LinkEmail {
  LinkEmail({
    required AuthRepository authRepository,
    required Settings settings,
    required Environment environment,
  }) : _authRepository = authRepository,
       _settings = settings,
       _environment = environment;

  factory LinkEmail.create() {
    return LinkEmail(authRepository: inject(), settings: inject(), environment: inject());
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

    final redirectUri = buildRedirectUri();

    final result = await _authRepository.linkEmail(email: email, redirectUri: redirectUri);

    if (result.isOk()) {
      await _settings.setMagicLinkSentTimestamp();
    }

    return result;
  }
}
