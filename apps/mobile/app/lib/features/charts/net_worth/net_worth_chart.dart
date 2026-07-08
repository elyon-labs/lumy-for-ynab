import 'package:flutter/material.dart';

import '../../../common/domain/accounts/filters.dart';
import '../../../common/presentation/markdown.dart';
import '../models/chart.dart';
import 'widgets/net_worth.dart';
import 'widgets/net_worth_stat.dart';

class NetWorthChart extends Chart {
  @override
  String get id => 'net_worth';

  @override
  String get title => 'Net worth';

  @override
  Widget buildDescription(BuildContext context) {
    return const Text('Bar chart showing net worth over time.');
  }

  @override
  Widget buildLongDescription(BuildContext context) {
    const body = '''
Both assets and liabilities are plotted in the positive direction. A third (line) series is shown that plots net worth. Net worth is calculated as the _sum_ of assets and liabilities.

**Important note:** This chart may not be accurate if your budget contains a loan account. See [here](https://github.com/toolkit-for-ynab/toolkit-for-ynab/issues/2900) for more details.

**Definitions:**
- **Asset:** In this context, an account with a positive balance/value. This means that credit cards, when carrying a positive balance, are included as assets.
- **Liability:** In this context, an account with a negative balance/value. This means that a checking account, when overdrawn, is included as a liability.
''';
    return const Markdown(data: body);
  }

  /// Since we have to calculate NetWorth manually, we need *all* accounts,
  /// even if they're closed. So we don't filter any accounts.
  @override
  AccountFilter get accountFilter => includeAccount;

  @override
  Widget build(BuildContext context) {
    return const NetWorth();
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return const NetWorthStat();
  }

  @override
  Widget? buildMath(BuildContext context) {
    return null;
  }
}
