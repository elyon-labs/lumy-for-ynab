import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/features/auth/data/repositories/auth_repository.dart';
import 'package:lumy/features/auth/domain/models/user.dart';
import 'package:lumy/features/auth/domain/use_cases/change_email.dart';
import 'package:lumy/features/auth/domain/use_cases/watch_user.dart';
import 'package:lumy/features/auth/presentation/screens/change_email_screen/change_email_screen.dart';
import 'package:lumy/features/auth/presentation/screens/change_email_screen/change_email_screen_cubit.dart';
import 'package:lumy/persistence/settings.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../factory/environment_factory.dart';
import '../../../../../utilities/fake_auth_api.dart';
import '../../../../../utilities/fake_shared_preferences.dart';

void main() {
  group('ChangeEmailScreen', () {
    test('buildSettingsRoute', () {
      expect(ChangeEmailScreen.buildSettingsRoute(), '/settings/sync-status/change-email');
    });
  });

  group('ChangeEmailScreenCubit', () {
    test('loads current and pending email from watched user', () async {
      final cubit = ChangeEmailScreenCubit(
        changeEmail: _FakeChangeEmail(),
        watchUser: _FakeWatchUser(
          AuthenticatedUser(
            id: 'user-id',
            accessToken: const None(),
            isAnonymous: false,
            email: 'old@example.com',
            pendingEmail: 'new@example.com',
          ),
        ),
        settings: Settings(FakeSharedPreferences()),
      );

      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.currentEmail, 'old@example.com');
      expect(cubit.state.pendingEmail, 'new@example.com');
      await cubit.close();
    });

    test('submit calls use case and returns to idle on success', () async {
      final changeEmail = _FakeChangeEmail();
      final cubit = ChangeEmailScreenCubit(
        changeEmail: changeEmail,
        watchUser: _FakeWatchUser(
          AuthenticatedUser(
            id: 'user-id',
            accessToken: const None(),
            isAnonymous: false,
            email: 'old@example.com',
          ),
        ),
        settings: Settings(FakeSharedPreferences()),
      );

      final result = await cubit.submit('new@example.com');

      expect(result.isOk(), isTrue);
      expect(changeEmail.email, 'new@example.com');
      expect(cubit.state.changeEmail, isA<Idle>());
      await cubit.close();
    });

    test('submit stores error on failure', () async {
      final exception = Exception('failed');
      final cubit = ChangeEmailScreenCubit(
        changeEmail: _FakeChangeEmail(result: Err(exception)),
        watchUser: _FakeWatchUser(
          AuthenticatedUser(
            id: 'user-id',
            accessToken: const None(),
            isAnonymous: false,
            email: 'old@example.com',
          ),
        ),
        settings: Settings(FakeSharedPreferences()),
      );

      final result = await cubit.submit('new@example.com');

      expect(result.err().toNullable(), exception);
      expect(cubit.state.changeEmail, isA<Error>());
      expect(cubit.state.changeEmail.error.unwrap(), exception);
      await cubit.close();
    });
  });
}

class _FakeChangeEmail extends ChangeEmail {
  _FakeChangeEmail({this.result = const Ok(null)})
    : super(
        authRepository: AuthRepository(api: FakeAuthApi()),
        settings: Settings(FakeSharedPreferences()),
        environment: EnvironmentFactory.build(),
      );

  final Result<void, Exception> result;
  String? email;

  @override
  Future<Result<void, Exception>> call({required String email}) async {
    this.email = email;
    return result;
  }
}

class _FakeWatchUser extends WatchUser {
  _FakeWatchUser(this.user) : super(authRepository: AuthRepository(api: FakeAuthApi()));

  final User user;

  @override
  Stream<User> call() {
    return Stream.value(user);
  }
}
