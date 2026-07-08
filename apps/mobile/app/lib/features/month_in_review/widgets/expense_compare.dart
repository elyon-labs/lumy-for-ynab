import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../common/domain/accounts/accounts_view.dart';
import '../../../common/domain/categories/categories_view.dart';
import '../../../common/domain/transactions/filters.dart';
import '../../../common/domain/transactions/transactions_repository.dart';
import '../../../common/domain/transactions/transactions_view.dart';
import '../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../common/domain/worker/worker.dart';
import '../../../common/presentation/charts/loading_chart.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../../../utils/sort.dart';
import '../../../ynab_api/_transaction.dart';
import 'amount_compare.dart';

class ExpenseCompareState extends Equatable {
  const ExpenseCompareState({
    required this.actualExpenses,
    required this.averageExpenses,
    required this.expenseDifferencePercent,
  });

  factory ExpenseCompareState.empty() {
    return const ExpenseCompareState(
      actualExpenses: 0,
      averageExpenses: 0,
      expenseDifferencePercent: 0,
    );
  }

  final int actualExpenses;
  final int averageExpenses;
  final int expenseDifferencePercent;

  @override
  List<Object?> get props => [actualExpenses, averageExpenses, expenseDifferencePercent];
}

class ExpenseCompareInput {
  const ExpenseCompareInput({
    required this.averageExpenseTransactions,
    required this.actualExpenseTransactions,
  });

  final List<PastTransaction> averageExpenseTransactions;
  final List<PastTransaction> actualExpenseTransactions;
}

ExpenseCompareState calculateExpenseCompareStateSync(ExpenseCompareInput input) {
  final totalIncome = input.averageExpenseTransactions.sumAmountFilteredSync(isExpense);
  final months = groupBy(
    input.averageExpenseTransactions,
    (t) => t.localDate.firstDayOfMonth(),
  ).sortByKeys(dateDesc);
  final numMonths = months.length;
  final averageExpenses = numMonths == 0 ? 0 : totalIncome ~/ numMonths;
  final actualExpenses = input.actualExpenseTransactions.sumAmountFilteredSync(isExpense);
  final incomeDifferencePercent = averageExpenses == 0
      ? 0
      : ((actualExpenses - averageExpenses) / averageExpenses * 100).round();

  return ExpenseCompareState(
    actualExpenses: actualExpenses,
    averageExpenses: averageExpenses,
    expenseDifferencePercent: incomeDifferencePercent,
  );
}

Future<ExpenseCompareState> calculateExpenseCompareStateInWorker({
  required Worker worker,
  required List<PastTransaction> averageExpenseTransactions,
  required List<PastTransaction> actualExpenseTransactions,
}) {
  final input = ExpenseCompareInput(
    averageExpenseTransactions: averageExpenseTransactions,
    actualExpenseTransactions: actualExpenseTransactions,
  );
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateExpenseCompareStateSync(input),
  );
}

class ExpenseCompareCubit extends Cubit<Async<ExpenseCompareState>> {
  ExpenseCompareCubit({
    required this.month,
    required this.settings,
    required this.transactionsRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory ExpenseCompareCubit.create({required LocalDate month}) {
    return ExpenseCompareCubit(
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
    final categoryViewId = settings.watchMonthInReviewCategoryViewStream();
    final sub = categoryViewId
        .switchMap((value) {
          final categoryView = value.mapOr(CategoriesInView.new, const ExpenseCategories());
          final averageExpenseTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange((
                from: month.subtractMonths(1).subtractYears(1).firstDayOfMonth(),
                to: month.subtractMonths(1).lastDayOfMonth(),
              )),
              accounts: const AllAccounts(),
              categories: categoryView,
              filter: const ExpenseFilter(),
            ),
          );
          final actualExpenseTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange((
                from: month.firstDayOfMonth(),
                to: month.lastDayOfMonth(),
              )),
              accounts: const AllAccounts(),
              categories: categoryView,
              filter: const ExpenseFilter(),
            ),
          );
          return Rx.combineLatest2(
            averageExpenseTransactions,
            actualExpenseTransactions,
            (a, b) => (a, b),
          ).asyncMap((event) async {
            final (averageExpenseTransactions, actualExpenseTransactions) = event;
            return calculateExpenseCompareStateInWorker(
              worker: calculationWorker,
              averageExpenseTransactions: averageExpenseTransactions,
              actualExpenseTransactions: actualExpenseTransactions,
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

class ExpenseCompare extends HookWidget {
  const ExpenseCompare({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseCompareCubit.create(month: month),
      child: BlocBuilder<ExpenseCompareCubit, Async<ExpenseCompareState>>(
        builder: (context, state) {
          final $state = state.valueOr(ExpenseCompareState.empty());
          return Skeletonizer(
            enabled: state.isLoading,
            child: VLayout(
              spacing: 0,
              children: [
                HLayout(
                  spacing: 0,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("That's"),
                    Text(
                      '${$state.expenseDifferencePercent.abs()}%',
                      style: context.text.headline.copyWith(height: 1),
                    ),
                    Text(
                      '${$state.expenseDifferencePercent.isNegative ? 'less' : 'more'} than average',
                    ),
                  ].spaced(),
                ),
                const VSpace(),
                Builder(
                  builder: (context) {
                    final isLoading = state.isLoading;
                    if (isLoading) {
                      return const LoadingChart(showAxisDetails: false);
                    }
                    return AmountCompare(
                      comparison: $state.averageExpenses,
                      actual: $state.actualExpenses,
                      isExpenses: true,
                      actualDate: month,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
