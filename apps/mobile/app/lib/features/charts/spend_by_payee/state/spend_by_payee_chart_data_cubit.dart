import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/domain/categories/categories_repository.dart';
import '../../../../common/domain/categories/categories_view.dart';
import '../../../../common/domain/payees/payees_repository.dart';
import '../../../../common/domain/payees/payees_view.dart';
import '../../../../common/domain/transactions/filters.dart';
import '../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../common/domain/transactions/transactions_view.dart';
import '../../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../../common/domain/worker/_transactions_sync.dart';
import '../../../../common/domain/worker/worker.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../../../utils/sort.dart';
import '../spend_by_payee_pie_chart.dart';

class SpendByPayeeChartDataCubit extends Cubit<Async<SpendByPayeeChartData>> {
  SpendByPayeeChartDataCubit({
    required this.settings,
    required this.categoriesRepo,
    required this.payeesRepo,
    required this.transactionsRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory SpendByPayeeChartDataCubit.create() {
    return SpendByPayeeChartDataCubit(
      settings: inject(),
      categoriesRepo: inject(),
      payeesRepo: inject(),
      transactionsRepo: inject(),
      worker: inject(),
    );
  }

  final Settings settings;
  final CategoriesRepository categoriesRepo;
  final PayeesRepository payeesRepo;
  final TransactionsRepository transactionsRepo;
  final Worker worker;
  final subs = CompositeSubscription();

  void fetch() {
    final chart = SpendByPayeePieChart();
    final accountsSetting = settings.watchChartAccounts(chart);
    final sub = accountsSetting
        .switchMap((accounts) async* {
          final payees = payeesRepo.watch(const AllPayees());
          final categories = categoriesRepo.watchCategories(const ExpensesInSelectedView());
          final transactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: const SelectedDateRange(),
              accounts: accounts.mapOr(AccountsWithIds.new, AccountsInFilter(chart.accountFilter)),
              categories: const ExpensesInSelectedView(),
              filter: const ExpenseFilter(),
              debugId: 'reports.spend_by_payee.transactions',
            ),
          );
          yield* Rx.combineLatest3(payees, categories, transactions, (a, b, c) => (a, b, c));
        })
        .switchMap((event) async* {
          final (payees, categories, transactions) = event;
          final data = await calculateSpendByPayeeInWorker(
            worker: worker,
            payees: payees,
            categories: categories,
            transactions: transactions,
          );
          yield Loaded(data);
        })
        .listen(safeEmit);
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

Future<SpendByPayeeChartData> calculateSpendByPayeeInWorker({
  required Worker worker,
  required List<Payee> payees,
  required List<Category> categories,
  required List<PastTransaction> transactions,
}) {
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateSpendByPayeeSync(
      payees: payees,
      categories: categories,
      transactions: transactions,
    ),
  );
}

SpendByPayeeChartData calculateSpendByPayeeSync({
  required List<Payee> payees,
  required List<Category> categories,
  required List<PastTransaction> transactions,
}) {
  final expenses = transactions.groupByCategorySync(categories.toList());
  final totalSpend = <Category, int>{};
  for (final entry in expenses.entries) {
    totalSpend[entry.key] = entry.value.sumAmountFilteredSync(isExpenseInCategory(entry.key));
  }
  final transactionsByPayee = transactions.groupByPayeeSync(payees);

  final spendByPayee = <Option<Payee>, int>{};
  final payeeToTransactions = <Option<Payee>, Map<LocalDate, List<PastTransaction>>>{};
  for (final e in transactionsByPayee.entries) {
    payeeToTransactions[e.key] = e.value.groupByDateSync(dateDesc);
    final spend = e.value.sumAmountFilteredSync(isExpenseFromPayee(e.key));
    if (spend.isNegative) spendByPayee[e.key] = spend;
  }

  final totalPayeeSpend = spendByPayee.values.sum;

  final percents = spendByPayee.mapNotNull((payee, spend) {
    if (spend >= 0 || totalPayeeSpend == 0) return null;
    final percent = spend / totalPayeeSpend;
    return MapEntry(payee, percent * 100);
  });

  final payeeSpendData = spendByPayee.entries.map((e) {
    final payee = e.key;
    final spend = e.value;
    final percent = percents[payee] ?? 0.0;
    return SinglePayeeSpendData(payee: payee, spend: spend, percentOfTotalSpend: percent);
  }).toList();

  return SpendByPayeeChartData(
    payeeSpendData: payeeSpendData,
    totalSpend: totalSpend.values.sum,
    payeesToTransactions: payeeToTransactions,
  );
}

sealed class PayeeSpendData {
  const PayeeSpendData({required this.spend, required this.percentOfTotalSpend});

  final int spend;
  final double percentOfTotalSpend;

  String get name {
    return switch (this) {
      SinglePayeeSpendData(:final payee) => payee.mapOr((p) => p.name, 'No Payee'),
      OtherPayeesSpendData() => 'Everyone else',
    };
  }
}

class SinglePayeeSpendData extends PayeeSpendData {
  const SinglePayeeSpendData({
    required this.payee,
    required super.spend,
    required super.percentOfTotalSpend,
  });

  final Option<Payee> payee;
}

class OtherPayeesSpendData extends PayeeSpendData {
  const OtherPayeesSpendData({required super.spend, required super.percentOfTotalSpend});
}

class SpendByPayeeChartData extends Equatable {
  const SpendByPayeeChartData({
    required this.totalSpend,
    required this.payeeSpendData,
    required this.payeesToTransactions,
  });

  final int totalSpend;
  final List<SinglePayeeSpendData> payeeSpendData;
  final Map<Option<Payee>, Map<LocalDate, List<PastTransaction>>> payeesToTransactions;

  @override
  List<Object?> get props => [payeeSpendData, totalSpend, payeesToTransactions];
}

extension SinglePayeeSpendDataX on List<SinglePayeeSpendData> {
  List<SinglePayeeSpendData> get sortedBySpendAsc {
    return List.from(this)..sort((a, b) => a.spend.compareTo(b.spend));
  }

  List<SinglePayeeSpendData> get sortedBySpendDesc {
    return List.from(this)..sort((a, b) => b.spend.compareTo(a.spend));
  }
}
