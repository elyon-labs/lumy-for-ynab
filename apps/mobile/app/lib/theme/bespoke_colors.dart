import 'package:flutter/material.dart';

class BespokeColors extends ThemeExtension<BespokeColors> {
  const BespokeColors({
    // Secondary component colors
    required this.bodyVariant,
    // Shimmer colors
    required this.shimmer,
    required this.onShimmer,
    // Chart colors
    required this.chartOne,
    required this.chartTwo,
    required this.chartThree,
    required this.chartFour,
    required this.chartFive,
    required this.chartSix,
    required this.chartSeven,
    required this.chartEight,
    required this.chartNine,
    required this.chartTen,
    required this.chartCompare,
    required this.chartAxisTitle,
    required this.chartTooltip,
  });

  final Color bodyVariant;
  // Shimmer colors
  final Color shimmer;
  final Color onShimmer;

  // Chart colors
  final Color chartOne;
  final Color chartTwo;
  final Color chartThree;
  final Color chartFour;
  final Color chartFive;
  final Color chartSix;
  final Color chartSeven;
  final Color chartEight;
  final Color chartNine;
  final Color chartTen;
  final Color chartCompare;
  final Color chartAxisTitle;
  final Color chartTooltip;

  List<Color> get chartColors {
    return [
      chartOne,
      chartTwo,
      chartThree,
      chartFour,
      chartFive,
      chartSix,
      chartSeven,
      chartEight,
      chartNine,
      chartTen,
    ];
  }

  @override
  BespokeColors copyWith({
    Color? secondaryInteractive,
    Color? onSecondaryInteractive,
    Color? bodyVariant,
    Color? shimmer,
    Color? onShimmer,
    Color? chartOne,
    Color? chartTwo,
    Color? chartThree,
    Color? chartFour,
    Color? chartFive,
    Color? chartSix,
    Color? chartSeven,
    Color? chartEight,
    Color? chartNine,
    Color? chartTen,
    Color? chartCompare,
    Color? chartAxisTitle,
    Color? chartTooltip,
  }) {
    return BespokeColors(
      // Secondary component colors
      bodyVariant: bodyVariant ?? this.bodyVariant,
      // Shimmer colors
      shimmer: shimmer ?? this.shimmer,
      onShimmer: onShimmer ?? this.onShimmer,
      // Chart colors
      chartOne: chartOne ?? this.chartOne,
      chartTwo: chartTwo ?? this.chartTwo,
      chartThree: chartThree ?? this.chartThree,
      chartFour: chartFour ?? this.chartFour,
      chartFive: chartFive ?? this.chartFive,
      chartSix: chartSix ?? this.chartSix,
      chartSeven: chartSeven ?? this.chartSeven,
      chartEight: chartEight ?? this.chartEight,
      chartNine: chartNine ?? this.chartNine,
      chartTen: chartTen ?? this.chartTen,
      chartCompare: chartCompare ?? this.chartCompare,
      chartAxisTitle: chartAxisTitle ?? this.chartAxisTitle,
      chartTooltip: chartTooltip ?? this.chartTooltip,
    );
  }

  @override
  BespokeColors lerp(covariant BespokeColors? other, double t) {
    if (other is! BespokeColors) {
      return this;
    }
    return BespokeColors(
      // Secondary component colors
      bodyVariant: Color.lerp(bodyVariant, other.bodyVariant, t)!,
      // Shimmer colors
      shimmer: Color.lerp(shimmer, other.shimmer, t)!,
      onShimmer: Color.lerp(onShimmer, other.onShimmer, t)!,
      chartOne: Color.lerp(chartOne, other.chartOne, t)!,
      chartTwo: Color.lerp(chartTwo, other.chartTwo, t)!,
      chartThree: Color.lerp(chartThree, other.chartThree, t)!,
      chartFour: Color.lerp(chartFour, other.chartFour, t)!,
      chartFive: Color.lerp(chartFive, other.chartFive, t)!,
      chartSix: Color.lerp(chartSix, other.chartSix, t)!,
      chartSeven: Color.lerp(chartSeven, other.chartSeven, t)!,
      chartEight: Color.lerp(chartEight, other.chartEight, t)!,
      chartNine: Color.lerp(chartNine, other.chartNine, t)!,
      chartTen: Color.lerp(chartTen, other.chartTen, t)!,
      chartCompare: Color.lerp(chartCompare, other.chartCompare, t)!,
      chartAxisTitle: Color.lerp(chartAxisTitle, other.chartAxisTitle, t)!,
      chartTooltip: Color.lerp(chartTooltip, other.chartTooltip, t)!,
    );
  }
}
