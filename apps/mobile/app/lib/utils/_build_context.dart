import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../app/scaffold_messenger/scaffold_messenger.dart';

extension BuildContextX on BuildContext {
  void showToast(Widget content, {Duration? duration}) {
    rootScaffoldKey.showSnackBar(SnackBar(content: content, duration: duration ?? 3.seconds));
  }

  T whenPortrait<T>(T Function(BuildContext) builder, {required T Function(BuildContext) orElse}) {
    final orientation = MediaQuery.of(this).orientation;
    if (orientation == Orientation.portrait) {
      return builder(this);
    } else {
      return orElse(this);
    }
  }
}
