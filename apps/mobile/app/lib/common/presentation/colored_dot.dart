import 'package:design/design.dart';
import 'package:flutter/material.dart';

class ColoredDot extends StatelessWidget {
  const ColoredDot({super.key, required this.color, this.size = Sizes.unit});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
