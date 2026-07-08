import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'link_email_screen_state.mapper.dart';

@MappableClass()
class LinkEmailScreenState with LinkEmailScreenStateMappable {
  LinkEmailScreenState({
    required this.login,
    required this.isExistingUser,
    required this.isUserLoggedIn,
    required this.isUserAnonymous,
    required this.timeUntilMagicLinkResend,
  });

  factory LinkEmailScreenState.initial({required bool isExistingUser}) {
    return LinkEmailScreenState(
      login: const Idle(),
      isExistingUser: isExistingUser,
      isUserLoggedIn: false,
      isUserAnonymous: false,
      timeUntilMagicLinkResend: Duration.zero,
    );
  }

  final bool isExistingUser;
  final bool isUserLoggedIn;
  final bool isUserAnonymous;
  final Duration timeUntilMagicLinkResend;
  final Async<Object> login;
}
