import 'package:design/design.dart';
import 'package:flutter/material.dart';

class BottomGlowContainer extends StatelessWidget {
  const BottomGlowContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VLayout(
      spacing: 0,
      children: [
        Container(
          height: 1,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: context.colors.card, blurRadius: 4, spreadRadius: 1)],
          ),
          child: Divider(color: context.colors.card, endIndent: 0, indent: 0),
        ),
        SafeArea(
          child: ColoredBox(
            color: context.colors.body,
            child: VEdgePadding(
              padding: Sizes.unit,
              child: HEdgePadding(child: HStretch(child: child)),
            ),
          ),
        ),
      ],
    );
  }
}
