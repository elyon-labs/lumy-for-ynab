import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/error_reporting/error_reporter.dart';

class ErrorScreenCubit extends Cubit<void> {
  ErrorScreenCubit({
    required ErrorReporter errorReporter,
    required this.error,
    required this.stackTrace,
  }) : _errorReporter = errorReporter,

       super(null) {
    unawaited(_reportError(error, stackTrace));
  }

  factory ErrorScreenCubit.create({Object? error, StackTrace? stackTrace}) {
    return ErrorScreenCubit(errorReporter: inject(), error: error, stackTrace: stackTrace);
  }

  final Object? error;
  final StackTrace? stackTrace;
  final ErrorReporter _errorReporter;

  Future<void> _reportError(Object? error, StackTrace? stackTrace) async {
    await _errorReporter.recordError(error, stackTrace ?? StackTrace.current);
  }
}
