import 'package:dart_foundation/dart_foundation.dart';

class AboutAppScreenState {
  AboutAppScreenState({required this.appVersion});

  factory AboutAppScreenState.initial() {
    return AboutAppScreenState(appVersion: const Loading());
  }

  final Async<String> appVersion;
}
