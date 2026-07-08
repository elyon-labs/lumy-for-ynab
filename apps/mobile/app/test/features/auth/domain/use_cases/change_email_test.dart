import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/features/auth/data/repositories/auth_repository.dart';
import 'package:lumy/features/auth/domain/use_cases/change_email.dart';
import 'package:lumy/persistence/settings.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../factory/environment_factory.dart';
import '../../../../utilities/fake_auth_api.dart';
import '../../../../utilities/fake_shared_preferences.dart';

void main() {
  group('ChangeEmail', () {
    test('calls auth repository with mobile redirect', () async {
      String? changedEmail;
      String? changeEmailRedirectUri;
      final api = FakeAuthApi(
        onChangeEmail: ({required email, required redirectUri}) {
          changedEmail = email;
          changeEmailRedirectUri = redirectUri;
        },
      );
      final prefs = FakeSharedPreferences();
      final settings = Settings(prefs);
      final useCase = ChangeEmail(
        authRepository: AuthRepository(api: api),
        settings: settings,
        environment: EnvironmentFactory.build(mobileDeeplinkUri: 'lumy://app'),
      );

      final result = await useCase(email: 'new@example.com');

      expect(result.isOk(), isTrue);
      expect(changedEmail, 'new@example.com');
      expect(changeEmailRedirectUri, 'lumy://app/settings/sync-status?email-change-confirmed=true');
      expect(prefs.getInt('magic_link_sent_timestamp'), isNotNull);
    });

    test('returns failure and does not set resend timestamp', () async {
      final exception = Exception('nope');
      final api = FakeAuthApi(changeEmailResult: Err(exception));
      final prefs = FakeSharedPreferences();
      final settings = Settings(prefs);
      final useCase = ChangeEmail(
        authRepository: AuthRepository(api: api),
        settings: settings,
        environment: EnvironmentFactory.build(mobileDeeplinkUri: 'lumy://app'),
      );

      final result = await useCase(email: 'new@example.com');

      expect(result.err().toNullable(), exception);
      expect(prefs.getInt('magic_link_sent_timestamp'), isNull);
    });
  });
}
