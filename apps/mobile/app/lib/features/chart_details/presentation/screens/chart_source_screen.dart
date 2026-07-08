import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../charts/all_charts.dart';
import '../../../charts/models/chart.dart';

class ChartSourceScreen extends HookWidget {
  const ChartSourceScreen({super.key, required this.chartId});
  final String chartId;

  static String buildRoute(String chartId) {
    return '/reports/chart_details/$chartId/source';
  }

  @override
  Widget build(BuildContext context) {
    final chart = allCharts.selectSingle(chartId);
    final widget = chart.buildSource(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Chart data')),
      body: widget,
    );
  }
}
