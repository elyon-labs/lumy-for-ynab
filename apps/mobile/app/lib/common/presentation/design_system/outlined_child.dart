import 'package:design/layout/sizes.dart';
import 'package:design/theme/_build_context.dart';
import 'package:flutter/material.dart';

class OutlinedChild extends StatelessWidget {
  const OutlinedChild({
    super.key,
    this.showOutline = true,
    required this.child,
    this.color,
    this.backgroundColor,
    this.width = 1,
  });

  final bool showOutline;
  final Widget child;
  final Color? backgroundColor;
  final Color? color;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (!showOutline) return child;
    return Material(
      color: backgroundColor,
      shape: RoundedSuperellipseBorder(
        side: BorderSide(color: color ?? context.colors.divider, width: width),
        borderRadius: BorderRadius.circular(Sizes.borderRadius * 3),
      ),
      child: child,
    );
  }
}
