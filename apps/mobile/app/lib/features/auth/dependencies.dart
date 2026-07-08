import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../app/environment/environment.dart';
import '../../app/error_reporting/error_reporter.dart';
import '../../persistence/settings.dart';
import '../../ynab_api/oauth/ynab_auth_helper.dart';

Future<YnabAuthHelper> createYnabAuthHelper({
  required Logger logger,
  required Environment environment,
  required ErrorReporter errorReporter,
  required PackageInfo packageInfo,
  required Settings settings,
}) {
  String buildRedirectUri() {
    if (UniversalPlatform.isWeb) {
      return '${environment.webDeeplinkUri}/auth.html';
    } else {
      return '${environment.mobileDeeplinkUri}/oauth';
    }
  }

  return YnabAuthHelper.create(
    authorizationUrl: environment.authorizationUrl,
    redirectUrl: buildRedirectUri(),
    tokenUrl: environment.tokenUrl,
    clientId: environment.clientId,
    errorReporter: errorReporter,
    logger: logger,
    packageInfo: packageInfo,
    settings: settings,
  );
}
