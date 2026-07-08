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
import '../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../common/domain/categories/categories_repository.dart';
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
import '../../../ynab_api/_transaction.dart';

class Movement extends Equatable {
  const Movement({
    required this.actualMonth,
    required this.actualValue,
    required this.comparisonMonth,
    required this.comparisonValue,
    required this.difference,
    required this.max,
  });

  final LocalDate actualMonth;
  final int actualValue;
  final LocalDate comparisonMonth;
  final int comparisonValue;
  final int difference;
  final int max;

  @override
  List<Object?> get props => [
    actualMonth,
    actualValue,
    comparisonMonth,
    comparisonValue,
    difference,
    max,
  ];
}

class TopMoversState extends Equatable {
  const TopMoversState({required this.movements});

  factory TopMoversState.empty() {
    return const TopMoversState(movements: {});
  }

  final Map<Category, Movement> movements;

  @override
  List<Object?> get props => [movements];
}

class TopMoversInput {
  const TopMoversInput({
    required this.month,
    required this.categories,
    required this.actual,
    required this.average,
  });

  final LocalDate month;
  final List<Category> categories;
  final List<PastTransaction> actual;
  final List<PastTransaction> average;
}

TopMoversState calculateTopMoversStateSync(TopMoversInput input) {
  final comparisonMonth = input.month.subtractMonths(1);
  final actualGrouped = input.actual.groupByCategorySync(input.categories);
  final averageGrouped = groupBy(input.average, (t) => t.localDate.firstDayOfMonth());

  final averages = Map.fromEntries(
    input.categories.map((category) {
      final sums = averageGrouped.values.map((value) {
        return value.sumAmountFilteredSync(isExpenseInCategory(category));
      });
      final average = sums.isEmpty ? 0 : sums.average.toInt();
      return MapEntry(category, average);
    }),
  );

  final movements = actualGrouped.map((category, actual) {
    final actualTotal = actual.sumAmountFilteredSync(isExpense);
    final average = averages[category] ?? 0;
    final difference = actualTotal - average;
    final movement = Movement(
      actualMonth: input.month,
      actualValue: actualTotal,
      comparisonMonth: comparisonMonth,
      comparisonValue: average,
      difference: difference,
      max: averages[category] ?? 0,
    );
    return MapEntry(category, movement);
  });

  final map = Map.fromEntries(
    movements.entries
        // Don't include categories with no difference
        .where((m) => m.value.difference != 0)
        // Sort by difference, biggest first
        .sortedByCompare((e) => e.value.difference, (a, b) => a.compareTo(b)),
  );

  return TopMoversState(movements: map);
}

Future<TopMoversState> calculateTopMoversStateInWorker({
  required Worker worker,
  required LocalDate month,
  required List<Category> categories,
  required List<PastTransaction> actual,
  required List<PastTransaction> average,
}) {
  final input = TopMoversInput(
    month: month,
    categories: categories,
    actual: actual,
    average: average,
  );
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateTopMoversStateSync(input),
  );
}

class TopMoversCubit extends Cubit<Async<TopMoversState>> {
  TopMoversCubit({
    required this.month,
    required this.settings,
    required this.transactionsRepo,
    required this.categoriesRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory TopMoversCubit.create({required LocalDate month}) {
    return TopMoversCubit(
      month: month,
      settings: inject(),
      transactionsRepo: inject(),
      categoriesRepo: inject(),
      worker: inject(),
    );
  }

  final LocalDate month;
  final Settings settings;
  final TransactionsRepository transactionsRepo;
  final CategoriesRepository categoriesRepo;
  final Worker worker;
  final subs = CompositeSubscription();

  LocalDate get comparisonMonth => month.subtractMonths(1);

  void fetch() {
    final calculationWorker = worker;
    final calculationMonth = month;
    final categoryViewId = settings.watchMonthInReviewCategoryViewStream();
    final sub = categoryViewId
        .switchMap((viewId) {
          final categoryView = viewId.mapOr(CategoriesInView.new, const ExpenseCategories());
          final categories = categoriesRepo.watchCategories(categoryView);
          final actualTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange((from: month, to: month.lastDayOfMonth())),
              accounts: const OnBudgetAccounts(),
              categories: categoryView,
              filter: const ExpenseFilter(),
            ),
          );
          final averageTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: const AllTime(),
              accounts: const OnBudgetAccounts(),
              categories: categoryView,
              filter: const ExpenseFilter(),
            ),
          );
          return Rx.combineLatest3(
            categories,
            actualTransactions,
            averageTransactions,
            (a, b, c) => (a, b, c),
          );
        })
        .asyncMap((event) async {
          final (categories, actual, average) = event;
          final data = await calculateTopMoversStateInWorker(
            worker: calculationWorker,
            month: calculationMonth,
            categories: categories,
            actual: actual,
            average: average,
          );
          return Loaded(data);
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

class TopMovers extends HookWidget {
  const TopMovers({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();

    return BlocBuilder<TopMoversCubit, Async<TopMoversState>>(
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.isLoading,
          child: VLayout(
            spacing: 0,
            children: [
              Text('Top movers', style: context.text.title),
              const Text(
                'These categories saw the biggest changes in spending compared to average.',
              ),
              const VSpace(),
              Theme(
                data: context.theme.copyWith(
                  dividerTheme: context.theme.dividerTheme.copyWith(indent: 0, endIndent: 0),
                ),
                child: Builder(
                  builder: (context) {
                    final movements = state.valueOr(TopMoversState.empty()).movements;
                    final top3 = movements.entries.take(3);
                    return VLayout(
                      children: [
                        for (final e in top3) ...[
                          VLayout(
                            spacing: 0,
                            children: [
                              Text(e.key.name, style: context.text.title),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  // Calculate bar widths based on the max usable width
                                  // Use no more than 90% of the available width
                                  final maxUsableWidth = constraints.maxWidth * 0.90;
                                  final didDecrease = e.value.difference.isPositive;
                                  // Since these are expenses, the higher value is actually the most negative
                                  final higherValue = [
                                    e.value.actualValue,
                                    e.value.comparisonValue,
                                  ].min.abs();
                                  final lowerValue = [
                                    e.value.actualValue,
                                    e.value.comparisonValue,
                                  ].max.abs();
                                  final maxValue = top3
                                      .expand((e) => [e.value.actualValue, e.value.comparisonValue])
                                      .min
                                      .abs();
                                  final longerWidth = higherValue == 0
                                      ? 0.0
                                      : maxUsableWidth * (higherValue / maxValue);
                                  final shorterWidth = lowerValue == 0
                                      ? 0.0
                                      : maxUsableWidth * (lowerValue / maxValue);
                                  final comparisonWidth = didDecrease ? longerWidth : shorterWidth;
                                  final actualWidth = didDecrease ? shorterWidth : longerWidth;
                                  return VLayout(
                                    children: [
                                      VLayout(
                                        children: [
                                          Text(
                                            'Average ${e.value.comparisonValue.format(currencyFormat)}',
                                            style: TextStyle(color: context.colors.muted),
                                          ),
                                          Container(
                                            color: context.colors.muted,
                                            width: comparisonWidth,
                                            height: Sizes.unit * 2,
                                          ),
                                          Text(
                                            '${e.value.actualMonth.monthOfYear.toMonthName()} ${e.value.actualValue.format(currencyFormat)}',
                                          ),
                                          Container(
                                            color: context.colors.accent,
                                            width: actualWidth,
                                            height: Sizes.unit * 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              if (e.key != top3.last.key) const VSpace(),
                            ],
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
