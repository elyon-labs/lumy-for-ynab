import 'package:dio/dio.dart';

class HttpClient {
  HttpClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<HttpClientResponse<T>> execute<T>(HttpClientRequest<T> request) async {
    String? inferContentType() {
      return request.headers['Content-Type'] == Headers.formUrlEncodedContentType
          ? Headers.formUrlEncodedContentType
          : null;
    }

    try {
      final response = await _dio.request<T>(
        request.path,
        data: switch (request.body) {
          JsonRequestBody(:final data) => data,
          RawRequestBody(:final data) => data,
          EmptyRequestBody() => null,
        },
        cancelToken: request.cancelToken,
        queryParameters: request.queryParameters,
        options: Options(
          contentType: inferContentType(),
          method: request.method,
          headers: request.headers,
        ),
      );

      return SuccessResponse(response: response);
    } on DioException catch (e) {
      return ErrorResponse(
        response: e.response,
        error: e,
        statusCode: e.response?.statusCode,
        message: e.response?.statusMessage,
      );
    }
  }
}

sealed class HttpClientResponse<T> {}

class SuccessResponse<T> extends HttpClientResponse<T> {
  SuccessResponse({required this.response});

  final Response<T> response;
}

class ErrorResponse<T> extends HttpClientResponse<T> {
  ErrorResponse({
    required this.response,
    required this.error,
    required this.statusCode,
    required this.message,
  });

  final Response<dynamic>? response;
  final DioException error;
  final int? statusCode;
  final String? message;
}

sealed class HttpClientRequest<T> {
  HttpClientRequest({
    required this.path,
    required this.method,
    required this.headers,
    required this.queryParameters,
    required this.body,
    required this.cancelToken,
  });

  final String path;
  final String method;
  final Map<String, String> headers;
  final Map<String, dynamic> queryParameters;
  final HttpClientRequestBody body;
  final CancelToken? cancelToken;
}

class GetRequest<T> extends HttpClientRequest<T> {
  GetRequest(
    String path, {
    super.headers = const {},
    super.queryParameters = const {},
    super.body = const EmptyRequestBody(),
    super.cancelToken,
  }) : super(method: 'GET', path: path);
}

class PostRequest<T> extends HttpClientRequest<T> {
  PostRequest(
    String path, {
    super.headers = const {},
    super.queryParameters = const {},
    required super.body,
    super.cancelToken,
  }) : super(method: 'POST', path: path);
}

sealed class HttpClientRequestBody {
  const HttpClientRequestBody();
}

class JsonRequestBody extends HttpClientRequestBody {
  JsonRequestBody(this.data);

  final Map<String, dynamic> data;
}

class RawRequestBody extends HttpClientRequestBody {
  RawRequestBody(this.data);

  final Object data;
}

class EmptyRequestBody extends HttpClientRequestBody {
  const EmptyRequestBody();
}
