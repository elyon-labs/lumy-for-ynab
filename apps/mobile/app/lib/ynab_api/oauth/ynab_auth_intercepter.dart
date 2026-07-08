import 'dart:async';

import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';

import '../../features/auth/domain/use_cases/get_ynab_access_token.dart';
import '../../features/auth/domain/use_cases/refresh_ynab_access_token.dart';
import '../../features/auth/domain/use_cases/remove_ynab_access_token.dart';
import 'ynab_auth_helper.dart';

class YnabAuthIntercepter extends Interceptor {
  YnabAuthIntercepter({
    required GetYnabAccessToken getYnabAccessToken,
    required RefreshYnabAccessToken refreshYnabAccessToken,
    required RemoveYnabAccessToken removeYnabAccessToken,
    required Dio dio,
  }) : _getYnabAccessToken = getYnabAccessToken,
       _refreshYnabAccessToken = refreshYnabAccessToken,
       _removeYnabAccessToken = removeYnabAccessToken,
       _dio = dio;

  factory YnabAuthIntercepter.create({required Dio dio}) {
    return YnabAuthIntercepter(
      getYnabAccessToken: GetYnabAccessToken.create(),
      refreshYnabAccessToken: RefreshYnabAccessToken.create(),
      removeYnabAccessToken: RemoveYnabAccessToken.create(),
      dio: dio,
    );
  }

  final GetYnabAccessToken _getYnabAccessToken;
  final RefreshYnabAccessToken _refreshYnabAccessToken;
  final RemoveYnabAccessToken _removeYnabAccessToken;
  final Dio _dio;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final maybeAccessToken = await _getYnabAccessToken();
    final accessToken = maybeAccessToken.toNullable();
    if (accessToken != null) {
      options.headers = options.headers.addBearer(accessToken.accessToken);
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Future<void> requestTokenAndRetry() async {
    //   // The refresh token failed, we need to request a new YNAB access token.
    //   final requestTokenResult = await _requestYnabAccessToken(includeWriteScope: false);
    //   await requestTokenResult.whenAsync(
    //     ok: (token) async {
    //       final request = err.requestOptions;
    //       try {
    //         final response = await _dio.request(
    //           request.uri.toString(),
    //           options: Options(
    //             method: request.method,
    //             headers: request.headers.addBearer(token.accessToken),
    //           ),
    //           data: request.data,
    //         );
    //         return handler.resolve(response);
    //       } on DioException catch (e) {
    //         return handler.next(e);
    //       }
    //     },
    //     err: (error) async {
    //       // Failed to request a new YNAB access token.
    //       handler.reject(
    //         DioException(
    //           requestOptions: err.requestOptions,
    //           error: error,
    //           type: DioExceptionType.badResponse,
    //         ),
    //       );
    //     },
    //   );
    // }

    Future<void> refreshTokenAndRetry() async {
      final refreshResult = await _refreshYnabAccessToken();
      switch (refreshResult) {
        case Ok(:final value):
          switch (value) {
            case RefreshTokenSuccess():
              final request = err.requestOptions;
              try {
                final response = await _dio.request(
                  request.uri.toString(),
                  options: Options(
                    method: request.method,
                    headers: request.headers.addBearer(value.accessToken.accessToken),
                  ),
                  data: request.data,
                );
                return handler.resolve(response);
              } on DioException catch (e) {
                return handler.next(e);
              }
            case RefreshTokenFailure(:final isUnauthorized):
              if (isUnauthorized) {
                await _removeYnabAccessToken();
              } else {
                // Something failed in the flow, but the user may still have a valid token.
                return handler.next(err);
              }
          }
        case Err():
          // Something unexpected occured in the flow, but the user may still have a valid token.
          return handler.next(err);
      }
    }

    if (err.response?.statusCode == 401) {
      final hasToken = err.requestOptions.headers.containsKey('Authorization');
      if (hasToken) {
        await refreshTokenAndRetry();
        return;
      } else {
        // This would be a weird edge case, but leaving it here if for some reason
        // an access token is on disk but not being attached to the request.
        await _removeYnabAccessToken();
        return;
      }
    }

    super.onError(err, handler);
  }
}

extension on Map<String, dynamic> {
  Map<String, dynamic> operator +(Map<String, dynamic> other) {
    return {...this, ...other};
  }

  Map<String, dynamic> addBearer(String token) {
    return this + {'Authorization': 'Bearer $token'};
  }
}
