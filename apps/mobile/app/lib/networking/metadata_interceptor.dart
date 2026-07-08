import 'package:dart_foundation/dart_foundation.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../persistence/settings.dart';

class MetadataInterceptor extends Interceptor {
  MetadataInterceptor({required PackageInfo packageInfo, required Settings settings})
    : _packageInfo = packageInfo,
      _settings = settings;

  final PackageInfo _packageInfo;
  final Settings _settings;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers = Map.fromEntries([
      ...options.headers.entries,
      MapEntry('X-User-Id', await _settings.watchYnabUserId().nextValue()),
      MapEntry('X-App-Version', _packageInfo.version),
    ]);

    super.onRequest(options, handler);
  }
}
