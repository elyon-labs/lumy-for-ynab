import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/worker/worker.dart';
import '../calculate_frugal_month_data.dart';
import '../models/frugal_month.dart';
import '../models/frugal_month_data.dart';

class CalculateFrugalMonthData {
  CalculateFrugalMonthData({required Worker worker}) : _worker = worker;

  factory CalculateFrugalMonthData.create() {
    return CalculateFrugalMonthData(worker: inject());
  }

  final Worker _worker;

  Future<FrugalMonthData> call(
    FrugalMonth month, {

    /// Transactions that are on-budget from *all time*. This function
    /// has a default look back period of 12 months.
    required List<PastTransaction> onBudgetTransactions,
  }) {
    return runTransactionCalculation(
      worker: _worker,
      calculate: () =>
          calculateFrugalMonthDataSync(month, onBudgetTransactions: onBudgetTransactions),
    );
  }
}
