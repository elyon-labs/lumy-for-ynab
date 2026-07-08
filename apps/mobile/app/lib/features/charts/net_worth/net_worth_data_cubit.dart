import 'package:dart_foundation/dart_foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../common/domain/accounts/accounts_repository.dart';
import '../../../common/domain/accounts/accounts_view.dart';
import '../../../common/domain/budgets/budgets_repository.dart';
import '../../../common/domain/calculations/net_worth/fn.dart';
import '../../../common/domain/categories/categories_view.dart';
import '../../../common/domain/transactions/transactions_repository.dart';
import '../../../common/domain/transactions/transactions_view.dart';
import '../../../common/domain/worker/worker.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../../../ynab_api/_budget.dart';
import 'net_worth_chart.dart';

class NetWorthDataCubit extends Cubit<Async<NetWorthData>> {
  NetWorthDataCubit({
    required this.budgetsRepo,
    required this.transactionsRepo,
    required this.accountsRepo,
    required this.settings,
    required this.worker,
  }) : super(const Idle()) {
    fetch();
  }

  factory NetWorthDataCubit.create() {
    return NetWorthDataCubit(
      budgetsRepo: inject(),
      transactionsRepo: inject(),
      accountsRepo: inject(),
      settings: inject(),
      worker: inject(),
    );
  }

  final BudgetsRepository budgetsRepo;
  final TransactionsRepository transactionsRepo;
  final AccountsRepository accountsRepo;
  final Settings settings;
  final Worker worker;
  final subs = CompositeSubscription();

  void fetch() {
    final chart = NetWorthChart();
    final chartAccounts = settings.watchChartAccounts(chart);
    final selectedDateRange = settings.watchSelectedDateRange();
    final selectedBudget = budgetsRepo.watchSelected();

    final sub =
        Rx.combineLatest3(chartAccounts, selectedDateRange, selectedBudget, (a, b, c) => (a, b, c))
            .switchMap((value) async* {
              final (chartAccounts, selectedDateRange, selectedBudget) = value;
              final accountsView = chartAccounts.mapOr(
                AccountsWithIds.new,
                AccountsInFilter(chart.accountFilter),
              );
              final transactions = transactionsRepo.watch(
                TransactionsView(
                  dateRange: const AllTime(),
                  accounts: accountsView,
                  categories: const AllCategories(),
                  filter: const NoFilter(),
                  debugId: 'reports.net_worth.transactions',
                ),
              );
              final accounts = accountsRepo.watch(accountsView);
              yield* Rx.combineLatest2(
                transactions,
                accounts,
                (a, b) => (a, b, selectedDateRange, selectedBudget),
              );
            })
            .switchMap((event) async* {
              final (transactions, accounts, selectedDateRange, selectedBudget) = event;
              final netWorths = await calculateNetWorthInWorker(
                worker: worker,
                startMonth: selectedBudget.toNullable()?.firstMonthDate ?? today.firstDayOfMonth(),
                endMonth: today.lastDayOfMonth(),
                accounts: accounts.toList(),
                transactions: transactions.toList(),
              );

              final netWorthsInDateRange = netWorths.sortByKeys().entries.where((entry) {
                return entry.key.isBetween(selectedDateRange.from, selectedDateRange.to);
              });
              yield Loaded(NetWorthData(monthSummaries: Map.fromEntries(netWorthsInDateRange)));
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

Future<Map<LocalDate, NetWorthSummary>> calculateNetWorthInWorker({
  required Worker worker,
  required LocalDate startMonth,
  required LocalDate endMonth,
  required List<Account> accounts,
  required List<PastTransaction> transactions,
}) {
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateNetWorthSync(
      startMonth: startMonth,
      endMonth: endMonth,
      accounts: accounts,
      transactions: transactions,
    ),
  );
}

class NetWorthData extends Equatable {
  const NetWorthData({required this.monthSummaries});
  final Map<LocalDate, NetWorthSummary> monthSummaries;

  @override
  List<Object?> get props => [monthSummaries];
}
