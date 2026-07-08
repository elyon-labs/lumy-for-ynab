import 'package:design/design.dart';
import 'package:flutter/material.dart';

class DecoratedChild extends StatelessWidget {
  const DecoratedChild({super.key, required this.child, this.color, this.padding});

  final Color? color;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color ?? context.colors.primary,
        shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(Sizes.unit * 1.5)),
      ),
      child: Padding(
        padding:
            padding ??
            const EdgeInsets.symmetric(horizontal: Sizes.unit * 1.5, vertical: Sizes.unit / 2),
        child: DefaultTextStyle.merge(
          child: child,
          style: TextStyle(color: context.colors.onPrimary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
