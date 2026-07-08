import 'package:flutter/material.dart';

import '../../../common/domain/accounts/filters.dart';
import '../../../common/presentation/markdown.dart';
import '../models/chart.dart';
import '../models/chart_type.dart';
import 'widgets/spend_by_category_source.dart';
import 'widgets/spend_by_category_stat.dart';
import 'widgets/spend_by_category_wrapper.dart';

class SpendByCategoryChart extends Chart {
  @override
  String get id => 'spend_by_category_2';

  @override
  String get title => 'Spend by category';

  @override
  List<ChartType> get supportedTypes => [ChartType.pie, ChartType.bar];

  @override
  Widget buildDescription(BuildContext context) {
    return const Text('Charts spending for each category.');
  }

  @override
  Widget buildLongDescription(BuildContext context) {
    const body = '''
Shows spending by category. By default, shows this by category group. Tapping a category group will "dive in" to that group and show spending by category as a percent of that group's spending. If you'd prefer to view spending by category as a percentage of _all_ spending, tap the "Switch to categories" button under the pie chart.
''';
    return const Markdown(data: body);
  }

  @override
  Widget build(BuildContext context) {
    return const SpendByCategoryWrapper();
  }

  @override
  AccountFilter get accountFilter => isOnBudgetAccount;

  @override
  Widget? buildSubtitle(BuildContext context) {
    return const SpendByCategoryStat();
  }

  @override
  Widget? buildMath(BuildContext context) {
    return null;
  }

  @override
  bool get showTransactionDataEntrypoint => true;

  @override
  Widget buildSource(BuildContext context) {
    return SpendByCategorySource(chart: this);
  }
}
