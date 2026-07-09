import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import '../../../app/feature_flags/feature_flags_cubit.dart';
import '../../../common/domain/accounts/filters.dart';
import 'chart_type.dart';

abstract class Chart extends Equatable {
  /// The unique identifier for this chart.
  String get id;

  /// The title of this chart.
  String get title;

  AccountFilter get accountFilter;

  bool isEnabled(FeatureFlagState state) => true;

  /// Whether or not the user should be able to view transactions for this
  /// chart.
  bool get showTransactionDataEntrypoint => false;

  /// The short description of this chart.
  Widget buildDescription(BuildContext context);

  /// The long description of this chart, containing more information than the
  /// short description.
  Widget buildLongDescription(BuildContext context);

  /// The widget to display for this chart.
  Widget build(BuildContext context);

  /// A stat to show for this chart, such as an average or the current value.
  Widget? buildSubtitle(BuildContext context);

  /// A math widget to show for this chart that explains how the chart is
  /// calculated.
  Widget? buildMath(BuildContext context);

  Widget? buildSource(BuildContext context) {
    return null;
  }

  List<ChartType> get supportedTypes => [];

  ChartType get defaultChartType => supportedTypes.first;

  @override
  List<Object?> get props => [id];
}

extension ListChartIdX on List<String> {
  List<Chart> toCharts(List<Chart> allCharts) {
    // Charts can be removed from `allCharts`, so allow for that.
    return map((e) => allCharts.singleWhereOrNull((c) => c.id == e)) //
        .nonNulls
        .toList();
  }
}

extension ListChartX on List<Chart> {
  Iterable<String> get ids => map((e) => e.id);

  Iterable<Chart> select(List<String> ids) {
    return where((c) => ids.contains(c.id));
  }

  Chart selectSingle(String id) {
    return singleWhere((c) => c.id == id);
  }

  Iterable<Chart> orderedWithPriority(List<String> order) sync* {
    final seen = <String>{};
    for (final id in order) {
      final chart = firstWhereOrNull((c) => c.id == id);
      if (chart != null && seen.add(id)) {
        yield chart;
      }
    }
    for (final chart in this) {
      if (seen.add(chart.id)) {
        yield chart;
      }
    }
  }
}
