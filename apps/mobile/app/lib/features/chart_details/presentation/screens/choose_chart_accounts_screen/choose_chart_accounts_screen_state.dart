import 'package:dart_foundation/dart_foundation.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../charts/models/chart.dart';

class ChooseChartAccountsScreenState {
  ChooseChartAccountsScreenState({
    required this.accounts,
    required this.chartAccounts,
    required this.chart,
  });

  factory ChooseChartAccountsScreenState.initial(Chart chart) {
    return ChooseChartAccountsScreenState(
      accounts: [],
      chartAccounts: const Loading(),
      chart: chart,
    );
  }

  final List<Account> accounts;
  final Async<Option<List<String>>> chartAccounts;
  final Chart chart;
}
