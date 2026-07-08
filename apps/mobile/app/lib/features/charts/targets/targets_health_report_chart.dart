import 'package:flutter/material.dart';

import '../../../common/domain/accounts/filters.dart';
import '../../../common/presentation/markdown.dart';
import '../models/chart.dart';
import '../spend_by_payee/widgets/spend_by_payee_source.dart';
import 'widgets/targets_health_report.dart';

class TargetsHealthReportChart extends Chart {
  @override
  String get id => 'targets_health_report';

  @override
  String get title => 'Targets Health';

  @override
  Widget buildDescription(BuildContext context) {
    return const Text('Chart displaying funding targets against actual spending.');
  }

  @override
  Widget buildLongDescription(BuildContext context) {
    const body = '''
Helps visualize your actual spending against your funding targets. This helps to highlight whether you're funding your targets appropriately.

**Notes:**

- **Targets** are coerced to their monthly funding amounts. For example, a yearly target will have it's target balance divided by 12. A weekly target will have its target balance multiplied by 4.35 to get an approximation of a monthly amount. This is done for a few reasons. First, our budgets are funded/viewed monthly--even if we don't get paid monthly. Secondly, this makes the visualization much simpler to understand when considering targets that have vastly different cadences (e.g every 2 weeks vs every 2 years). Lastly, Lumy right now is limited to monthly time periods. In the future I plan on making this more flexible, but for now I try to make the app feel consistent so it's not confusing.
- **Spending amount** reflects the average spent per month for the months in the selected date range. For categories with targets that have durations that are longer than the selected date range (e.g. you've selected a 3 month date range but a category has a 12 month target), spending is based on the full duration of that category's target. This is done so that viewing a date range smaller than the target duration doesn't skew the results.
''';
    return const Markdown(data: body);
  }

  @override
  AccountFilter get accountFilter => isOnBudgetAccount;

  @override
  Widget build(BuildContext context) {
    return const TargetsHealthReport();
  }

  @override
  Widget? buildSubtitle(BuildContext context) {
    return null;
  }

  @override
  Widget? buildMath(BuildContext context) {
    return null;
  }

  @override
  bool get showTransactionDataEntrypoint => false;

  @override
  Widget buildSource(BuildContext context) {
    return const SpendByPayeeSource();
  }
}
