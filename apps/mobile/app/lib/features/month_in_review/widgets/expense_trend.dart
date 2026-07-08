import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../common/domain/accounts/accounts_view.dart';
import '../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../common/domain/categories/categories_view.dart';
import '../../../common/domain/transactions/filters.dart';
import '../../../common/domain/transactions/transactions_repository.dart';
import '../../../common/domain/transactions/transactions_view.dart';
import '../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../common/domain/worker/worker.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../../../utils/sort.dart';
import '../../../ynab_api/_transaction.dart';
import 'trend_chart.dart';

class ExpenseTrendState {
  ExpenseTrendState({required this.expensesByMonth});

  factory ExpenseTrendState.empty() {
    return ExpenseTrendState(expensesByMonth: {});
  }

  final Map<LocalDate, int> expensesByMonth;
}

class ExpenseTrendInput {
  const ExpenseTrendInput({required this.today, required this.transactions});

  final LocalDate today;
  final List<PastTransaction> transactions;
}

ExpenseTrendState calculateExpenseTrendStateSync(ExpenseTrendInput input) {
  final groupedByMonth = groupBy(
    input.transactions,
    (t) => t.localDate.firstDayOfMonth(),
  ).sortByKeys(dateAsc);
  final expensesByMonth = groupedByMonth.map(
    (key, value) => MapEntry(key, value.sumAmountFilteredSync(isExpense)),
  );

  return ExpenseTrendState(
    expensesByMonth: Map.fromEntries(
      expensesByMonth.entries.whereNot((month) {
        return month.key.isSameMonthAs(input.today) || month.key.isAfter(input.today);
      }),
    ),
  );
}

Future<ExpenseTrendState> calculateExpenseTrendStateInWorker({
  required Worker worker,
  required LocalDate today,
  required List<PastTransaction> transactions,
}) {
  final input = ExpenseTrendInput(today: today, transactions: transactions);
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateExpenseTrendStateSync(input),
  );
}

class ExpenseTrendCubit extends Cubit<Async<ExpenseTrendState>> {
  ExpenseTrendCubit({
    required this.month,
    required this.settings,
    required this.transactionsRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory ExpenseTrendCubit.create({required LocalDate month}) {
    return ExpenseTrendCubit(
      month: month,
      settings: inject(),
      transactionsRepo: inject(),
      worker: inject(),
    );
  }

  final LocalDate month;
  final Settings settings;
  final TransactionsRepository transactionsRepo;
  final Worker worker;
  final subs = CompositeSubscription();

  void fetch() {
    final calculationWorker = worker;
    final last12Months = (
      from: month.subtractYears(1).firstDayOfMonth(),
      to: month.lastDayOfMonth(),
    );
    final categoryViewId = settings.watchMonthInReviewCategoryViewStream();
    final sub = categoryViewId
        .switchMap((value) {
          final categoryView = value.mapOr(CategoriesInView.new, const ExpenseCategories());
          final transactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange(last12Months),
              accounts: const AllAccounts(),
              categories: categoryView,
              filter: const ExpenseFilter(),
            ),
          );
          return transactions.asyncMap((transactions) async {
            return calculateExpenseTrendStateInWorker(
              worker: calculationWorker,
              today: today,
              transactions: transactions,
            );
          });
        })
        .listen((event) {
          safeEmit(Loaded(event));
        });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ExpenseTrend extends HookWidget {
  const ExpenseTrend({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();

    return BlocProvider(
      create: (context) => ExpenseTrendCubit.create(month: month),
      child: BlocBuilder<ExpenseTrendCubit, Async<ExpenseTrendState>>(
        builder: (context, state) {
          final $state = state.valueOr(ExpenseTrendState.empty());
          return Skeletonizer(
            enabled: state.isLoading,
            child: VLayout(
              spacing: 0,
              children: [
                Text('Expenses trend', style: context.text.title),
                const Text("Here's how your expenses have been trending over time."),
                const VSpace(space: Sizes.unit * 3),
                TrendChart(
                  currencyFormat: currencyFormat,
                  source: $state.expensesByMonth.entries.toList().mapValues((value) => value * -1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
