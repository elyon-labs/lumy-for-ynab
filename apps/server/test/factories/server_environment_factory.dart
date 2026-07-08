import 'package:faker/faker.dart';
import 'package:server/environment/environment.dart';

abstract class ServerEnvironmentFactory {
  static ServerEnvironment create({
    String? tokenUrl,
    String? redirectUri,
    String? clientId,
    String? clientSecret,
    String? baseUrl,
    String? allowedCorsOrigin,
  }) {
    final faker = Faker();

    return ServerEnvironment(
      tokenUrl: tokenUrl ?? faker.internet.httpsUrl(),
      redirectUri: redirectUri ?? faker.internet.httpsUrl(),
      clientId: clientId ?? faker.guid.guid(),
      clientSecret: clientSecret ?? faker.guid.guid(),
      baseUrl: baseUrl ?? faker.internet.httpsUrl(),
      allowedCorsOrigin: allowedCorsOrigin ?? faker.internet.httpsUrl(),
    );
  }
}
