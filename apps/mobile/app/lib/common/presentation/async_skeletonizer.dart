import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AsyncSkeletonizer<T extends Object> extends StatelessWidget {
  const AsyncSkeletonizer({
    super.key,
    required this.value,
    required this.builder,
    this.loading,
    this.error,
  });

  final Async<T> value;
  final Widget Function(T data) builder;
  final WidgetBuilder? loading;
  final WidgetBuilder? error;

  @override
  Widget build(BuildContext context) {
    return switch (value) {
      Loaded<T>(:final value) => builder(value),
      Idle<T>() => loading?.call(context) ?? const Skeletonizer(child: Bone()),
      Loading<T>() => loading?.call(context) ?? const Skeletonizer(child: Bone()),
      Error<T>() => error?.call(context) ?? const Skeletonizer(child: Bone()),
    };
  }
}
