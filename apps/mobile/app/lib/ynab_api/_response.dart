import 'package:dio/dio.dart';

import 'ynab_api_error.dart';

extension YnabApiResponseX on Response<dynamic> {
  /// Attempts to parse and return a [YnabApiError] object from the receiver.
  /// See https://api.ynab.com/#errors
  YnabApiError? get ynabApiError {
    if (data is! Map<String, dynamic>) return null;
    final error = (data as Map<String, dynamic>)['error'];
    return error is Map<String, dynamic> ? YnabApiErrorMapper.fromMap(error) : null;
  }
}
