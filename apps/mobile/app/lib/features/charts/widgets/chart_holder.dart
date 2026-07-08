import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../models/chart.dart';
import 'visual_card.dart';

class ChartHolder extends StatelessWidget {
  const ChartHolder({super.key, required this.chart, required this.onDetailsTapped});

  final Chart chart;
  final VoidCallback? onDetailsTapped;

  @override
  Widget build(BuildContext context) {
    final subtitle = chart.buildSubtitle(context);
    return VisualCard(
      title: Text(chart.title),
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(child: subtitle, style: context.text.headline)
          : null,
      button: const Icon(Ionicons.chevron_forward, size: Sizes.unit * 2.5).opacity(0.25),
      onTap: onDetailsTapped,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.edgePadding / 2),
        child: chart.build(context),
      ),
    );
  }
}
