import 'dart:isolate';
import 'package:flutter/foundation.dart' show kIsWeb;

enum IsolateType { background, main }

class Worker {
  Worker._(this._useBackground);

  factory Worker.on(IsolateType type) {
    // On web, isolates are not supported; always run on the main isolate.
    final useBackground = type == IsolateType.background && !kIsWeb;
    return Worker._(useBackground);
  }

  final bool _useBackground;

  /// Run CPU-bound synchronous work, optionally on a background isolate.
  ///
  /// Note: [action] must be synchronous when executed in background.
  /// If you need async inside, perform the async work before calling [run]
  /// and pass a pure synchronous computation here.
  Future<T> run<T>(T Function() action) async {
    if (_useBackground) {
      return Isolate.run<T>(action);
    }
    return Future<T>.value(action());
  }
}

Future<T> runTransactionCalculation<T>({required Worker worker, required T Function() calculate}) {
  return worker.run(calculate);
}
