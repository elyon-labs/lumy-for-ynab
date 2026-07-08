import 'package:collection/collection.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';

extension WidgetX on Widget {
  Widget debugBoundaries({Color color = Colors.red, ValueKey<String>? key}) {
    return ColoredBox(key: key, color: color, child: this);
  }

  Widget onTap(void Function() onTap, {bool withRipple = true}) {
    return withRipple
        ? InkWell(
            onTap: onTap,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
            ),
            child: this,
          )
        : GestureDetector(onTap: onTap, child: this);
  }

  Widget trackedBy(String eventName, {Map<String, Object>? parameters}) {
    return this;
  }

  bool get isSpacer => this is Spacer || this is VSpace;
}

extension IterableWidgetX on Iterable<Widget> {
  List<Widget> spaced({
    double space = Sizes.unit / 2,
    Axis axis = Axis.horizontal,
    bool leadingSpace = false,
    bool trailingSpace = false,
  }) {
    final box = axis == Axis.horizontal ? SizedBox(width: space) : SizedBox(height: space);
    return expandIndexed((index, element) {
      return [
        if (index == 0 && leadingSpace) box,
        element,
        if (index != length - 1 || trailingSpace) box,
      ];
    }).toList();
  }
}
