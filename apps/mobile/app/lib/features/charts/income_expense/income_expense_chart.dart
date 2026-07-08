import 'package:flutter/material.dart';

import '../../../common/domain/accounts/filters.dart';
import '../../../common/presentation/markdown.dart';
import '../models/chart.dart';
import '../models/chart_type.dart';
import 'widgets/income_expense_stat.dart';
import 'widgets/income_expense_wrapper.dart';

class IncomeExpenseChart extends Chart {
  @override
  String get id => 'income_expense_2';

  @override
  String get title => 'Income v expense';

  @override
  List<ChartType> get supportedTypes => [ChartType.bar, ChartType.line];

  @override
  Widget buildDescription(BuildContext context) {
    return const Text('Charts income vs expenses.');
  }

  @override
  Widget buildLongDescription(BuildContext context) {
    const body = '''
Income is plotted in a positive direction, expenses in a negative direction. When viewed as a bar chart, a third (line) series is shown that plots net income. Net income is calculated as the _sum_ of income and expenses.

**Definitions:**
- **Income:** Transactions that are categorized as _Ready to Assign_ and are not Starting Balance transactions. This can even be an outflow.
- **Expense:** Transactions that are categorized and are not Starting Balance transactions or income.
''';
    return const Markdown(data: body);
  }

  @override
  AccountFilter get accountFilter => isOnBudgetAccount;

  @override
  Widget build(BuildContext context) {
    return const IncomeExpenseWrapper();
  }

  @override
  Widget? buildSubtitle(BuildContext context) {
    return const IncomeExpenseStat();
  }

  @override
  Widget? buildMath(BuildContext context) {
    return null;
  }
}
