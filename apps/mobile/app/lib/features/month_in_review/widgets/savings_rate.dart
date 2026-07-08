import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import '../../../common/presentation/_int.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';

class SavingsRateCompareState extends Equatable {
  const SavingsRateCompareState({required this.actual, required this.comparison});

  factory SavingsRateCompareState.empty() {
    return const SavingsRateCompareState(actual: 0, comparison: 0);
  }

  final double actual;
  final double comparison;

  @override
  List<Object?> get props => [actual, comparison];
}

class SavingsRateInput {
  const SavingsRateInput({required this.allTransactions, required this.expenseTransactions});

  final List<PastTransaction> allTransactions;
  final List<PastTransaction> expenseTransactions;
}

double calculateSavingsRateSync(SavingsRateInput input) {
  final income = input.allTransactions.sumAmountFilteredSync(isIncome);
  final expenses = input.expenseTransactions.sumAmountFilteredSync(isExpense);

  if (income <= 0) {
    return 0;
  }

  if (expenses >= 0) {
    return 100;
  }

  return (((income + expenses) / income) * 100).clamp(0, 100).toDouble();
}

Future<double> calculateSavingsRateInWorker({
  required Worker worker,
  required List<PastTransaction> allTransactions,
  required List<PastTransaction> expenseTransactions,
}) {
  final input = SavingsRateInput(
    allTransactions: allTransactions,
    expenseTransactions: expenseTransactions,
  );
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateSavingsRateSync(input),
  );
}

class SavingsRateCompareCubit extends Cubit<Async<SavingsRateCompareState>> {
  SavingsRateCompareCubit({
    required this.month,
    required this.transactionsRepo,
    required this.settings,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory SavingsRateCompareCubit.create({required LocalDate month}) {
    return SavingsRateCompareCubit(
      month: month,
      transactionsRepo: inject(),
      settings: inject(),
      worker: inject(),
    );
  }

  final LocalDate month;
  final TransactionsRepository transactionsRepo;
  final Settings settings;
  final Worker worker;
  final subs = CompositeSubscription();

  LocalDate get comparisonMonth => month.subtractMonths(1);

  Stream<double> calculate(LocalDate month) {
    final calculationWorker = worker;
    final categoryViewId = settings.watchMonthInReviewCategoryViewStream();
    return categoryViewId
        .switchMap((value) {
          final categoryView = value.mapOr(CategoriesInView.new, const ExpenseCategories());
          final allTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange((
                from: month.firstDayOfMonth(),
                to: month.lastDayOfMonth(),
              )),
              accounts: const OnBudgetAccounts(),
              categories: const AllCategories(),
              filter: const NoFilter(),
            ),
          );
          final expenseTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange((from: month, to: month.lastDayOfMonth())),
              accounts: const OnBudgetAccounts(),
              categories: categoryView,
              filter: const ExpenseFilter(),
            ),
          );
          return Rx.combineLatest2(allTransactions, expenseTransactions, (a, b) => (a, b));
        })
        .asyncMap((event) async {
          final (allTransactions, expenseTransactions) = event;
          return calculateSavingsRateInWorker(
            worker: calculationWorker,
            allTransactions: allTransactions,
            expenseTransactions: expenseTransactions,
          );
        });
  }

  void fetch() {
    final actual = calculate(month);
    final comparison = calculate(comparisonMonth);

    final sub = Rx.combineLatest2(actual, comparison, (a, b) => (a, b)).listen((event) {
      final (actual, comparison) = event;
      safeEmit(Loaded(SavingsRateCompareState(actual: actual, comparison: comparison)));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class SavingsRateCompare extends HookWidget {
  const SavingsRateCompare({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavingsRateCompareCubit.create(month: month),
      child: BlocBuilder<SavingsRateCompareCubit, Async<SavingsRateCompareState>>(
        builder: (context, state) {
          final $state = state.mapOr((value) => value, SavingsRateCompareState.empty());
          return VLayout(
            spacing: 0,
            children: [
              Text('Savings rate', style: context.text.title),
              Skeletonizer(
                enabled: state.isLoading,
                child: Text('${$state.actual.toStringAsFixed(2)}%', style: context.text.headline),
              ),
              const VSpace(),
              const Text(
                'Your savings rate is simply the percentage of income that is not spent. '
                'The higher the percent, the more within your means you are living!',
              ),
              const VSpace(),
              _Visual(month),
            ],
          );
        },
      ),
    );
  }
}

class _Visual extends StatelessWidget {
  const _Visual(this.month);

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    final actualMonth = month;
    final comparisonMonth = context.watch<SavingsRateCompareCubit>().comparisonMonth;

    return BlocBuilder<SavingsRateCompareCubit, Async<SavingsRateCompareState>>(
      builder: (context, state) {
        final $state = state.mapOr((value) => value, SavingsRateCompareState.empty());
        return VLayout(
          children: [
            Skeletonizer(
              enabled: state.isLoading,
              child: Builder(
                builder: (context) {
                  final comparisonRate = $state.comparison;
                  return VLayout(
                    children: [
                      Text(
                        '${comparisonMonth.monthOfYear.toMonthName()}: ${comparisonRate.toStringAsFixed(2)}%',
                        style: context.text.body.copyWith(color: context.colors.muted),
                      ),
                      _SavingsRateRow(rate: comparisonRate.toInt()),
                    ],
                  );
                },
              ),
            ),
            Skeletonizer(
              enabled: state.isLoading,
              child: Builder(
                builder: (context) {
                  final actualRate = $state.actual;
                  return VLayout(
                    children: [
                      Text(
                        '${actualMonth.monthOfYear.toMonthName()}: ${actualRate.toStringAsFixed(2)}%',
                      ),
                      _SavingsRateRow(rate: actualRate.toInt()),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SavingsRateRow extends StatelessWidget {
  const _SavingsRateRow({required this.rate});

  final int rate;

  @override
  Widget build(BuildContext context) {
    return HLayout(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: rate,
          child: Container(height: Sizes.unit * 4, color: context.colors.accent),
        ),
        Expanded(
          flex: 100 - rate,
          child: Container(height: Sizes.unit * 4, color: context.colors.muted),
        ),
      ],
    );
  }
}
