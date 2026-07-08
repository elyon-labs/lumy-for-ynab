import 'package:flutter/material.dart';

import '../../../common/domain/accounts/filters.dart';
import '../../../common/presentation/markdown.dart';
import '../models/chart.dart';
import 'widgets/days_buffer.dart';
import 'widgets/days_buffer_math.dart';
import 'widgets/days_buffer_stat.dart';

class DaysBufferChart extends Chart {
  @override
  String get id => 'days_buffer';

  @override
  String get title => 'Days of buffer';

  @override
  Widget buildDescription(BuildContext context) {
    return const Text('Line chart showing days of buffer.');
  }

  @override
  Widget buildLongDescription(BuildContext context) {
    const body = '''
Shows the amount of buffer within the budget; that is, the number of days the current budget balance would support when spending at the average daily rate. 
''';
    return const Markdown(data: body);
  }

  @override
  AccountFilter get accountFilter => isOnBudgetAccount;

  @override
  Widget build(BuildContext context) {
    return const DaysBuffer();
  }

  @override
  Widget? buildSubtitle(BuildContext context) {
    return const DaysBufferStat();
  }

  @override
  Widget? buildMath(BuildContext context) {
    return const DaysBufferMath();
  }
}
