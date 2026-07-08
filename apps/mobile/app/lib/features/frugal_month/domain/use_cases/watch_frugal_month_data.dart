import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/domain/categories/categories_view.dart';
import '../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../common/domain/transactions/transactions_view.dart';
import '../models/frugal_month_data.dart';
import 'calculate_frugal_month_data.dart';
import 'watch_frugal_months.dart';

class WatchFrugalMonthData {
  WatchFrugalMonthData({
    required WatchFrugalMonths watchFrugalMonths,
    required CalculateFrugalMonthData calculateFrugalMonthData,
    required TransactionsRepository transactionsRepository,
  }) : _watchFrugalMonths = watchFrugalMonths,
       _calculateFrugalMonthData = calculateFrugalMonthData,
       _transactionsRepository = transactionsRepository;

  factory WatchFrugalMonthData.create() {
    return WatchFrugalMonthData(
      watchFrugalMonths: WatchFrugalMonths.create(),
      calculateFrugalMonthData: CalculateFrugalMonthData.create(),
      transactionsRepository: inject(),
    );
  }

  final WatchFrugalMonths _watchFrugalMonths;
  final CalculateFrugalMonthData _calculateFrugalMonthData;
  // TODO: Replace with WatchTransactions when available
  final TransactionsRepository _transactionsRepository;

  ValueStream<FrugalMonthData> call(String frugalMonthId) {
    final frugalMonthsStream = _watchFrugalMonths();
    const onBudgetTransactionsView = TransactionsView(
      dateRange: AllTime(),
      accounts: OnBudgetAccounts(),
      categories: AllCategories(),
      filter: NoFilter(),
    );
    final onBudgetTransactionsStream = _transactionsRepository.watch(onBudgetTransactionsView);

    return Rx.combineLatest2(
      onBudgetTransactionsStream,
      frugalMonthsStream,
      (onBudgetTransactions, frugalMonths) => (onBudgetTransactions, frugalMonths),
    ).switchMap((event) async* {
      final (onBudgetTransactions, frugalMonths) = event;
      final frugalMonth = frugalMonths.singleWhere(
        (frugalMonth) => frugalMonth.id == frugalMonthId,
      );
      yield await _calculateFrugalMonthData(
        frugalMonth,
        onBudgetTransactions: onBudgetTransactions,
      );
    }).shareValue();
  }
}
