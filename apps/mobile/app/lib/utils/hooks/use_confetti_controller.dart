import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ConfettiController useConfettiController({Duration? duration, List<Object?>? keys}) {
  return use(_ConfettiControllerHook(duration: duration, keys: keys));
}

class _ConfettiControllerHook extends Hook<ConfettiController> {
  const _ConfettiControllerHook({this.duration, super.keys});

  final Duration? duration;

  @override
  HookState<ConfettiController, Hook<ConfettiController>> createState() =>
      _ConfettiControllerHookState();
}

class _ConfettiControllerHookState extends HookState<ConfettiController, _ConfettiControllerHook> {
  late final controller = ConfettiController(duration: hook.duration ?? 3.seconds);

  @override
  ConfettiController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useConfettiController';
}
