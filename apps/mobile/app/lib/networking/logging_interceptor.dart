import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

const _requestStartMicrosKey = 'lumy_request_start_micros';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_requestStartMicrosKey] = DateTime.now().microsecondsSinceEpoch;
    _logger.d(
      'REQUEST ${options.method} ${options.uri} '
      'headers=${options.headers.length} ${_summarizeData(options.data)}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final elapsedMs = _elapsedMs(err.requestOptions);
    _logger.e(
      '[${err.response?.statusCode}] ERROR ${err.requestOptions.method} '
      '${err.requestOptions.uri} elapsedMs=$elapsedMs error=${err.type} '
      '${_summarizeData(err.response?.data)}',
    );
    super.onError(err, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final elapsedMs = _elapsedMs(response.requestOptions);
    _logger.d(
      '[${response.statusCode}] RESPONSE ${response.requestOptions.method} '
      '${response.requestOptions.uri} elapsedMs=$elapsedMs '
      'headers=${response.headers.map.length} ${_summarizeData(response.data)}',
    );
    super.onResponse(response, handler);
  }

  int? _elapsedMs(RequestOptions options) {
    final startMicros = options.extra[_requestStartMicrosKey];
    if (startMicros is! int) return null;
    return (DateTime.now().microsecondsSinceEpoch - startMicros) ~/ 1000;
  }

  String _summarizeData(Object? data) {
    return switch (data) {
      null => 'data=null',
      final List<Object?> list => 'data=List(length=${list.length})',
      final Map<String, dynamic> map => 'data=Map(${_summarizeMap(map)})',
      final Map<Object?, Object?> map => 'data=Map(length=${map.length})',
      final String value => 'data=String(length=${value.length})',
      _ => 'data=${data.runtimeType}',
    };
  }

  String _summarizeMap(Map<String, dynamic> map) {
    final data = map['data'];
    if (data is Map<String, dynamic>) {
      final childLists = data.entries
          .where((entry) => entry.value is List<Object?>)
          .map((entry) {
            final list = entry.value as List<Object?>;
            return '${entry.key}:${list.length}';
          })
          .join(',');
      return [
        'keys=${map.keys.length}',
        'dataKeys=${data.keys.length}',
        if (childLists.isNotEmpty) 'dataLists=$childLists',
      ].join(' ');
    }
    return 'keys=${map.keys.length}';
  }
}
