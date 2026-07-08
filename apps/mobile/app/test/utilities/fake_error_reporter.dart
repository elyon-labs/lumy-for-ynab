import 'package:lumy/app/error_reporting/error_reporter.dart';

class FakeErrorReporter implements ErrorReporter {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> setUserIdentifier(String userId) async {}

  @override
  Future<void> testCrash() async {}

  @override
  Future<void> log(String message) async {}

  @override
  // ignore: avoid_annotating_with_dynamic
  Future<void> recordError(dynamic error, StackTrace stack) async {}
}
