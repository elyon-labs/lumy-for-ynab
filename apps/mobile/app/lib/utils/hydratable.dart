import 'dart:async';

/// A mixin that provides a [Future] that completes when [complete] is called,
/// indicating that the object is hydrated and ready for use.
mixin Hydratable<T> {
  final Completer<T> _completer = Completer();

  Future<T> get future => _completer.future;

  void complete(T value) {
    if (!_completer.isCompleted) {
      _completer.complete(value);
    }
  }
}
