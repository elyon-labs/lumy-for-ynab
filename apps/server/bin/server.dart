import 'dart:io';

import 'package:dio/dio.dart' hide Response;
import 'package:dotenv/dotenv.dart';
import 'package:server/endpoints/get_token.dart';
import 'package:server/environment/environment.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  late final InternetAddress ip = InternetAddress.anyIPv4;
  final env = DotEnv(includePlatformEnvironment: true);
  final isDevelopment = env['ENVIRONMENT'] == 'development';
  if (isDevelopment) {
    print('Running in development, loading ${Directory.current.path}/.env');
    env.load(['.env']);
  }
  final resolvedEnvironment = ServerEnvironment.fromDotEnv(env);

  final Dio httpClient = Dio(BaseOptions(baseUrl: resolvedEnvironment.baseUrl));

  final router =
      Router()
        ..get('/', _rootHandler)
        ..post(
          '/token',
          GetToken(environment: resolvedEnvironment, httpClient: httpClient),
        );

  final headers = {
    'Access-Control-Allow-Origin': resolvedEnvironment.allowedCorsOrigin,
    'Content-Type': 'application/json',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers':
        'Content-Type, Authorization, X-User-Id, X-App-Version',
    'Access-Control-Max-Age': '600',
  };

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests()) //
      .addMiddleware(
        corsHeaders(
          headers: headers,
          originChecker: originOneOf([resolvedEnvironment.allowedCorsOrigin]),
        ),
      )
      .addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);

  print('Server listening on port ${server.port}');
}
