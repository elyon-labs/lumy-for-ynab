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

import '../../../app/di.dart';
import '../../../common/domain/accounts/accounts_repository.dart';
import '../../../common/domain/accounts/accounts_view.dart';
import '../../../common/domain/calculations/days_buffer/fn.dart';
import '../../../common/domain/categories/categories_repository.dart';
import '../../../common/domain/categories/categories_view.dart';
import '../../../common/domain/transactions/transactions_repository.dart';
import '../../../common/domain/transactions/transactions_view.dart';
import '../../../common/presentation/_int.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';

class DaysBufferCompareState extends Equatable {
  const DaysBufferCompareState({
    required this.actual,
    required this.comparison,
    required this.delta,
    required this.max,
  });

  factory DaysBufferCompareState.empty() {
    return const DaysBufferCompareState(actual: 0, comparison: 0, delta: 0, max: 1);
  }

  final double actual;
  final double comparison;
  final double delta;
  final double max;

  @override
  List<Object?> get props => [actual, comparison, delta, max];
}

class DaysBufferCompareCubit extends Cubit<Async<DaysBufferCompareState>> {
  DaysBufferCompareCubit({
    required this.month,
    required this.categoriesRepo,
    required this.accountsRepo,
    required this.transactionsRepo,
    required this.settings,
  }) : super(const Loading()) {
    fetch();
  }

  factory DaysBufferCompareCubit.create({required LocalDate month}) {
    return DaysBufferCompareCubit(
      month: month,
      categoriesRepo: inject(),
      accountsRepo: inject(),
      transactionsRepo: inject(),
      settings: inject(),
    );
  }

  final LocalDate month;
  final CategoriesRepository categoriesRepo;
  final AccountsRepository accountsRepo;
  final TransactionsRepository transactionsRepo;
  final Settings settings;
  final subs = CompositeSubscription();

  LocalDate get comparisonMonth => month.subtractMonths(1);

  Stream<DaysBufferResult> calculate(LocalDate month) {
    final last12Months = (
      from: month.subtractYears(1).firstDayOfMonth(),
      to: month.lastDayOfMonth(),
    );
    final categoryViewId = settings.watchMonthInReviewCategoryViewStream();
    return categoryViewId
        .switchMap((value) async* {
          final categoryView = value.mapOr(CategoriesInView.new, const ExpenseCategories());
          const accountsView = OnBudgetAccounts();
          final allTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange(last12Months),
              accounts: const OnBudgetAccounts(),
              categories: const AllCategories(),
              filter: const NoFilter(),
            ),
          );
          final expenseTransactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: SpecificDateRange(last12Months),
              accounts: const OnBudgetAccounts(),
              categories: categoryView,
              filter: const ExpenseFilter(),
            ),
          );
          yield* Rx.combineLatest4(
            allTransactions,
            expenseTransactions,
            accountsRepo.watch(accountsView),
            categoriesRepo.watchCategories(categoryView),
            (a, b, c, d) => (a, b, c, d, last12Months),
          );
        })
        .flatMap((event) async* {
          final (allTransactions, expenseTransactions, accounts, categories, selectedDateRange) =
              event;
          yield await calculateDaysBuffer(
            allTransactionsInDateRange: allTransactions,
            expenseTransactionsInDateRange: expenseTransactions,
            accounts: accounts,
            categories: categories,
            dateRange: selectedDateRange,
          );
        });
  }

  void fetch() {
    final actual = calculate(month);
    final comparison = calculate(comparisonMonth);

    final sub = Rx.combineLatest2(actual, comparison, (a, b) => (a, b))
        .map((event) {
          final (actual, comparison) = event;
          final delta = (actual.currentBuffer ?? 0) - (comparison.currentBuffer ?? 0);
          final max = [actual.currentBuffer ?? 0, comparison.currentBuffer ?? 0].max;
          return Loaded(
            DaysBufferCompareState(
              actual: actual.currentBuffer?.toDouble() ?? 0,
              comparison: comparison.currentBuffer?.toDouble() ?? 0,
              delta: delta.toDouble(),
              max: max.toDouble(),
            ),
          );
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

class DaysBufferCompare extends HookWidget {
  const DaysBufferCompare({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DaysBufferCompareCubit.create(month: month),
      child: BlocBuilder<DaysBufferCompareCubit, Async<DaysBufferCompareState>>(
        builder: (context, state) {
          final $state = state.valueOr(DaysBufferCompareState.empty());
          return Skeletonizer(
            enabled: state.isLoading,
            child: VLayout(
              spacing: 0,
              children: [
                Text('Days of buffer', style: context.text.title),
                Builder(
                  builder: (context) {
                    final delta = $state.delta;
                    return Text(
                      delta.isNegative ? '${delta.floor()} days' : '+ ${delta.floor()} days',
                      style: context.text.headline,
                    );
                  },
                ),
                const VSpace(),
                const Text('A larger buffer gives you more options, so a high number is best.'),
                const VSpace(),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final delta = $state.delta;
                    final comparison = $state.comparison;
                    final actual = $state.actual;
                    final max = $state.max;
                    // Calculate bar widths based on the max usable width
                    // Use no more than 75% of the available width
                    final maxUsableWidth = constraints.maxWidth * 0.75;
                    final didDecrease = delta.isNegative;
                    final longerValue = [comparison, actual].max;
                    final shorterValue = [comparison, actual].min;
                    final longerWidth = maxUsableWidth * (longerValue / max);
                    final shorterWidth = maxUsableWidth * (shorterValue / max);
                    final prevMonthWidth = didDecrease ? longerWidth : shorterWidth;
                    final mirWidth = didDecrease ? shorterWidth : longerWidth;
                    return VLayout(
                      children: [
                        VLayout(
                          children: [
                            HLayout(
                              children: [
                                Text(
                                  context
                                      .watch<DaysBufferCompareCubit>()
                                      .comparisonMonth
                                      .monthOfYear
                                      .toMonthName(),
                                ),
                                Text('${comparison.floor()} days'),
                              ],
                            ),
                            Container(
                              color: context.colors.muted,
                              width: prevMonthWidth,
                              height: Sizes.unit * 4,
                            ),
                          ],
                        ),
                        VLayout(
                          children: [
                            HLayout(
                              children: [
                                Text(month.monthOfYear.toMonthName()),
                                Text('${actual.floor()} days'),
                              ],
                            ),
                            Container(
                              width: mirWidth,
                              height: Sizes.unit * 4,
                              color: context.colors.accent,
                            ),
                          ],
                        ),
                      ],
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
