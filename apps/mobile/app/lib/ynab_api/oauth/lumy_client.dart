import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../external/http_client.dart';
import '../../networking/logging_interceptor.dart';
import '../../networking/metadata_interceptor.dart';
import '../../persistence/settings.dart';

HttpClient createLumyHttpClient({
  required Logger logger,
  required PackageInfo packageInfo,
  required Settings settings,
}) {
  final dio = Dio()
    ..interceptors.addAll([
      MetadataInterceptor(packageInfo: packageInfo, settings: settings),
      LoggingInterceptor(logger: logger),
    ]);
  return HttpClient(dio: dio);
}
