import 'package:design/design.dart';
import 'package:flutter/material.dart';

class Badged extends StatelessWidget {
  const Badged({super.key, this.child, this.showBadge = true, this.label, this.color});

  final Color? color;
  final Widget? child;
  final bool showBadge;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return Badge(
      backgroundColor: color ?? context.colors.accent,
      isLabelVisible: showBadge,
      smallSize: 10,
      label: label,
      child: child,
    );
  }
}
