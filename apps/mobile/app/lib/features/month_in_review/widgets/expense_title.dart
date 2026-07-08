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
import '../../../common/presentation/_int.dart';
import '../../../common/presentation/currency.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';

class ExpenseTitleState {
  ExpenseTitleState({required this.amount, required this.comparisonAmount});

  factory ExpenseTitleState.empty() {
    return ExpenseTitleState(amount: 0, comparisonAmount: 0);
  }

  final int amount;
  final int comparisonAmount;
}

class ExpenseTitleInput {
  const ExpenseTitleInput({required this.actual, required this.comparison});

  final List<PastTransaction> actual;
  final List<PastTransaction> comparison;
}

ExpenseTitleState calculateExpenseTitleStateSync(ExpenseTitleInput input) {
  return ExpenseTitleState(
    amount: input.actual.sumAmountFilteredSync(isExpense),
    comparisonAmount: input.comparison.sumAmountFilteredSync(isExpense),
  );
}

Future<ExpenseTitleState> calculateExpenseTitleStateInWorker({
  required Worker worker,
  required List<PastTransaction> actual,
  required List<PastTransaction> comparison,
}) {
  final input = ExpenseTitleInput(actual: actual, comparison: comparison);
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateExpenseTitleStateSync(input),
  );
}

class ExpenseTitleCubit extends Cubit<Async<ExpenseTitleState>> {
  ExpenseTitleCubit({
    required this.month,
    required this.settings,
    required this.transactionsRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory ExpenseTitleCubit.create({required LocalDate month}) {
    return ExpenseTitleCubit(
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

  LocalDate get comparisonMonth => month.subtractMonths(1);

  Stream<List<PastTransaction>> calculate(LocalDate month) {
    final categoryViewId = settings.watchMonthInReviewCategoryViewStream();
    return categoryViewId.switchMap((value) {
      final categoryView = value.mapOr(CategoriesInView.new, const ExpenseCategories());
      return transactionsRepo.watch(
        TransactionsView(
          dateRange: SpecificDateRange((from: month.firstDayOfMonth(), to: month.lastDayOfMonth())),
          accounts: const OnBudgetAccounts(),
          categories: categoryView,
          filter: const ExpenseFilter(),
        ),
      );
    });
  }

  final subs = CompositeSubscription();

  void fetch() {
    final actual = calculate(month);
    final comparison = calculate(comparisonMonth.subtractMonths(1));
    final calculationWorker = worker;

    subs.add(
      Rx.combineLatest2(actual, comparison, (a, b) => (a, b)).listen((state) async {
        final (actual, comparison) = state;
        final data = await calculateExpenseTitleStateInWorker(
          worker: calculationWorker,
          actual: actual,
          comparison: comparison,
        );
        safeEmit(Loaded(data));
      }),
    );
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ExpenseTitle extends HookWidget {
  const ExpenseTitle({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();

    return BlocProvider(
      create: (context) => ExpenseTitleCubit.create(month: month),
      child: BlocBuilder<ExpenseTitleCubit, Async<ExpenseTitleState>>(
        builder: (context, state) {
          final $state = state.mapOr((value) => value, ExpenseTitleState.empty());
          return VLayout(
            spacing: 0,
            children: [
              Text('Expenses', style: context.text.title),
              const Text("That's a wrap! You spent"),
              const VSpace(),
              Skeletonizer(
                enabled: state.isLoading,
                child: Text($state.amount.format(currencyFormat), style: context.text.headline),
              ),
              Skeletonizer(
                enabled: state.isLoading,
                child: Builder(
                  builder: (context) {
                    final month = context.read<ExpenseTitleCubit>().comparisonMonth;
                    final monthName = month.monthOfYear.toMonthName();
                    final amount = $state.comparisonAmount.format(currencyFormat);
                    return Text(
                      '$monthName: $amount',
                      style: context.text.body.copyWith(color: context.colors.muted),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
