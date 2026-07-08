import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart' as st;

class ErrorReporter {
  ErrorReporter({required Logger logger}) : _logger = logger;

  final Logger _logger;

  Future<void> initialize() async {
    FlutterError.onError = (details) {
      _logger.e(details.exceptionAsString(), error: details.exception, stackTrace: details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (error is ParallelWaitError) {
        for (final error in error.errors as Iterable) {
          if (error is AsyncError) {
            _logger.e('Parallel wait error', error: error.error, stackTrace: error.stackTrace);
          }
        }
      }
      final chain = st.Chain.forTrace(stack);
      _logger.e('Platform: $error\n${chain.terse}', error: error);
      return true;
    };
  }

  Future<void> log(String message) async {
    _logger.i(message);
  }

  // ignore: avoid_annotating_with_dynamic
  Future<void> recordError(dynamic error, StackTrace stack) async {
    _logger.e('Recorded error', error: error, stackTrace: stack);
  }

  Future<void> setUserIdentifier(String userId) async {}

  Future<void> testCrash() async {}
}
