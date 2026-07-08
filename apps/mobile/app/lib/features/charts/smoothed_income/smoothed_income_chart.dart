import 'package:design/design.dart';
import 'package:flutter/material.dart';

import '../../../common/domain/accounts/filters.dart';
import '../../../common/presentation/markdown.dart';
import '../models/chart.dart';
import 'widgets/smoothed_income.dart';
import 'widgets/smoothed_income_math.dart';
import 'widgets/smoothed_income_stat.dart';

class SmoothedIncomeChart extends Chart {
  @override
  String get id => 'daily_net_income';

  @override
  String get title => 'Smoothed income';

  @override
  Widget buildDescription(BuildContext context) {
    return const Text('Line chart that depicts income as being earned smoothly over time.');
  }

  @override
  Widget buildLongDescription(BuildContext context) {
    return const VLayout(
      children: [
        Markdown(
          data:
              'Depicts income as being earned smoothly over time; specifically, '
              'it takes all income for the selected timeframe, sums it, and then '
              'divides it by the number of days in the timeframe. This is your '
              '"daily net income". Expenses are plotted as they occur in reality, '
              'without smoothing. This chart is primarily useful for identifying '
              'periods of unsustainable spending. While you may technically spend '
              'less than you earn in a single month, you may be spending more than '
              'you earn on a daily basis over a longer period of time. This chart '
              'will help you identify that. ',
        ),
      ],
    );
  }

  @override
  AccountFilter get accountFilter => isOnBudgetAccount;

  @override
  Widget build(BuildContext context) {
    return const SmoothedIncome();
  }

  @override
  Widget? buildMath(BuildContext context) {
    return const SmoothedIncomeMath();
  }

  @override
  Widget? buildSubtitle(BuildContext context) {
    return const SmoothedIncomeStat();
  }
}
