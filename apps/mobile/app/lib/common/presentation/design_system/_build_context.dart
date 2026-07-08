import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart' as s;

import '../../../theme/bespoke_colors.dart';

extension DesignSystemBuildContextX on BuildContext {
  BespokeColors get bespokeColors => Theme.of(this).extension<BespokeColors>()!;

  s.SkeletonizerConfigData get skeletonizerTheme {
    return s.SkeletonizerConfigData(
      effect: s.ShimmerEffect(
        baseColor: bespokeColors.shimmer,
        highlightColor: bespokeColors.onShimmer,
      ),
      textBorderRadius: s.TextBoneBorderRadius(BorderRadius.circular(Sizes.borderRadius)),
    );
  }

  bool get isDesktop => MediaQuery.sizeOf(this).width >= 1024;

  bool get isTablet => MediaQuery.sizeOf(this).width >= 600 && MediaQuery.sizeOf(this).width < 1024;

  bool get isMobile => MediaQuery.sizeOf(this).width < 600;
}
