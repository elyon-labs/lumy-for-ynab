import 'package:design/design.dart';
import 'package:flutter/material.dart';

import '../../../common/presentation/colored_dot.dart';

class TooltipRow extends StatelessWidget {
  const TooltipRow({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return HLayout(
      children: [
        ColoredDot(color: color),
        DefaultTextStyle.merge(
          style: const TextStyle(fontWeight: FontWeight.bold),
          child: Text(text),
        ),
      ],
    );
  }
}
