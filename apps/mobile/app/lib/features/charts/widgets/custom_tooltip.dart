import 'package:design/design.dart';
import 'package:flutter/material.dart';

import '../../../common/presentation/design_system/_build_context.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.bespokeColors.chartTooltip,
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      child: Padding(padding: const EdgeInsets.all(Sizes.unit), child: child),
    );
  }
}
