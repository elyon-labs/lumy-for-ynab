import 'package:flutter/material.dart';

import '../../../common/domain/accounts/filters.dart';
import '../../../common/presentation/markdown.dart';
import '../models/chart.dart';
import 'widgets/spend_by_payee_pie.dart';
import 'widgets/spend_by_payee_source.dart';
import 'widgets/spend_by_payee_stat.dart';

class SpendByPayeePieChart extends Chart {
  @override
  String get id => 'spend_by_payee_pie_2';

  @override
  String get title => 'Spend by payee';

  @override
  Widget buildDescription(BuildContext context) {
    return const Text('Pie chart showing combined spending by payee.');
  }

  @override
  Widget buildLongDescription(BuildContext context) {
    const body = '''
Shows spending for each payee. Each row in the table below the chart shows the total amount spend with that payee and the percentage of total spending that represents. The pie chart shows the same data, but in a visual format. The table is sorted by total spending, with the highest spending payee at the top.
''';
    return const Markdown(data: body);
  }

  @override
  AccountFilter get accountFilter => isOnBudgetAccount;

  @override
  Widget build(BuildContext context) {
    return const SpendByPayeePie();
  }

  @override
  Widget? buildSubtitle(BuildContext context) {
    return const SpendByPayeeStat();
  }

  @override
  Widget? buildMath(BuildContext context) {
    return null;
  }

  @override
  bool get showTransactionDataEntrypoint => true;

  @override
  Widget buildSource(BuildContext context) {
    return const SpendByPayeeSource();
  }
}
