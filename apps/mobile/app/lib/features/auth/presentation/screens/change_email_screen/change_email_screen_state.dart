import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'change_email_screen_state.mapper.dart';

@MappableClass()
class ChangeEmailScreenState with ChangeEmailScreenStateMappable {
  ChangeEmailScreenState({
    required this.changeEmail,
    required this.currentEmail,
    required this.pendingEmail,
    required this.timeUntilEmailChangeResend,
  });

  factory ChangeEmailScreenState.initial() {
    return ChangeEmailScreenState(
      changeEmail: const Idle(),
      currentEmail: null,
      pendingEmail: null,
      timeUntilEmailChangeResend: Duration.zero,
    );
  }

  final Async<Object> changeEmail;
  final String? currentEmail;
  final String? pendingEmail;
  final Duration timeUntilEmailChangeResend;
}
