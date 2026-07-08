import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/blend/blend.dart';
import 'package:material_color_utilities/hct/hct.dart';

extension ColorX on Color {
  Color blendedTo(Color other) {
    return Color(
      Blend.harmonize(
        // ignore: deprecated_member_use
        value,
        // ignore: deprecated_member_use
        Hct.fromInt(other.value).toInt(),
      ),
    );
  }

  String toHex() {
    // Extract the ARGB components
    // ignore: deprecated_member_use
    final hex = value.toRadixString(16);

    // Ensure the hex string is of length 8
    if (hex.length == 8) {
      return '#$hex';
    } else {
      // Pad with leading zeros if necessary
      return '#${hex.padLeft(8, '0')}';
    }
  }

  Color withAlphaOf(double alpha) {
    // ignore: deprecated_member_use
    return withOpacity(alpha);
  }
}

extension ElyonColorsX on ElyonColors {
  Color forPercent(double percent) {
    if (percent == 0) return error;
    // Clamp the percent to the nearest 10%
    final clamped = (percent * 10).round() / 10;

    final hsv = switch (clamped) {
      >= .50 => HSVColor.lerp(
        HSVColor.fromColor(warning),
        HSVColor.fromColor(good),
        (clamped - .50) / .50,
      ),
      >= .25 => HSVColor.lerp(
        HSVColor.fromColor(error),
        HSVColor.fromColor(warning),
        (clamped - .25) / .25,
      ),
      _ => HSVColor.fromColor(error),
    };
    return hsv!.toColor();
  }
}
