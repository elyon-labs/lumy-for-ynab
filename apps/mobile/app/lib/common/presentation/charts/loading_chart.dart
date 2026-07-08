import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../features/charts/templates/cartesian_chart_template.dart';

class LoadingChart extends StatelessWidget {
  const LoadingChart({super.key, this.showAxisDetails = true});

  final bool showAxisDetails;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: CartesianChart(
        showYAxis: showAxisDetails,
        showXAxis: showAxisDetails,
        series: const [],
      ),
    );
  }
}
