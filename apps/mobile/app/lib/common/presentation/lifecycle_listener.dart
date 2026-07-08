import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LifecycleListener extends HookWidget {
  const LifecycleListener({
    super.key,
    required this.child,
    this.onResumed,
    this.onPaused,
    this.onInactive,
    this.onDetached,
    this.onHidden,
  });

  final Widget child;
  final VoidCallback? onResumed;
  final VoidCallback? onPaused;
  final VoidCallback? onInactive;
  final VoidCallback? onDetached;
  final VoidCallback? onHidden;

  @override
  Widget build(BuildContext context) {
    final lifecycle = useAppLifecycleState();
    useEffect(() {
      switch (lifecycle) {
        case AppLifecycleState.resumed:
          onResumed?.call();
        case AppLifecycleState.paused:
          onPaused?.call();
        case AppLifecycleState.inactive:
          onInactive?.call();
        case AppLifecycleState.detached:
          onDetached?.call();
        case AppLifecycleState.hidden:
          onHidden?.call();
        case null:
          break;
      }
      return null;
    }, [lifecycle]);
    return child;
  }
}
