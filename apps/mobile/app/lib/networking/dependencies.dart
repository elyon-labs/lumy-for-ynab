import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../app/environment/environment.dart';
import '../external/http_client.dart';
import '../persistence/settings.dart';
import '../ynab_api/oauth/ynab_auth_helper.dart';
import '../ynab_api/oauth/ynab_auth_intercepter.dart';
import 'logging_interceptor.dart';
import 'metadata_interceptor.dart';

HttpClient createYnabHttpClient({
  required Environment environment,
  required Logger logger,
  required YnabAuthHelper ynabAuthHelper,
  required PackageInfo packageInfo,
  required Settings settings,
}) {
  final logging = LoggingInterceptor(logger: logger);
  final innerDio = Dio()
    ..interceptors.addAll([
      MetadataInterceptor(packageInfo: packageInfo, settings: settings),
      logging,
    ]);
  final dio = Dio(BaseOptions(baseUrl: environment.ynabBaseUrl))
    ..interceptors.addAll([YnabAuthIntercepter.create(dio: innerDio), logging]);
  return HttpClient(dio: dio);
}

HttpClient createDiscordHttpClient({required Environment environment, required Logger logger}) {
  return HttpClient(
    dio: Dio(BaseOptions(baseUrl: 'https://discord.com/api/webhooks/'))
      ..interceptors.addAll([LoggingInterceptor(logger: logger)]),
  );
}
