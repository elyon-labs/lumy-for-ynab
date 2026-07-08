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
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../../../utils/sort.dart';
import '../../../ynab_api/_transaction.dart';
import 'amount_compare.dart';

class IncomeCompareState extends Equatable {
  const IncomeCompareState({
    required this.actualIncome,
    required this.averageIncome,
    required this.incomeDifferencePercent,
  });

  factory IncomeCompareState.empty() {
    return const IncomeCompareState(actualIncome: 0, averageIncome: 0, incomeDifferencePercent: 0);
  }

  final int actualIncome;
  final int averageIncome;
  final int incomeDifferencePercent;

  @override
  List<Object?> get props => [actualIncome, averageIncome, incomeDifferencePercent];
}

class IncomeCompareInput {
  const IncomeCompareInput({
    required this.averageIncomeTransactions,
    required this.actualIncomeTransactions,
  });

  final List<PastTransaction> averageIncomeTransactions;
  final List<PastTransaction> actualIncomeTransactions;
}

IncomeCompareState calculateIncomeCompareStateSync(IncomeCompareInput input) {
  final totalIncome = input.averageIncomeTransactions.sumAmountFilteredSync(isIncome);
  final months = groupBy(
    input.averageIncomeTransactions,
    (t) => t.localDate.firstDayOfMonth(),
  ).sortByKeys(dateDesc);
  final numMonths = months.length;
  final averageIncome = numMonths == 0 ? 0 : totalIncome ~/ numMonths;
  final actualIncome = input.actualIncomeTransactions.sumAmountFilteredSync(isIncome);
  final incomeDifferencePercent = averageIncome == 0
      ? 0
      : ((actualIncome - averageIncome) / averageIncome * 100).round();

  return IncomeCompareState(
    actualIncome: actualIncome,
    averageIncome: averageIncome,
    incomeDifferencePercent: incomeDifferencePercent,
  );
}

Future<IncomeCompareState> calculateIncomeCompareStateInWorker({
  required Worker worker,
  required List<PastTransaction> averageIncomeTransactions,
  required List<PastTransaction> actualIncomeTransactions,
}) {
  final input = IncomeCompareInput(
    averageIncomeTransactions: averageIncomeTransactions,
    actualIncomeTransactions: actualIncomeTransactions,
  );
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateIncomeCompareStateSync(input),
  );
}

class IncomeCompareCubit extends Cubit<Async<IncomeCompareState>> {
  IncomeCompareCubit({required this.month, required this.transactionsRepo, required this.worker})
    : super(const Loading()) {
    fetch();
  }

  factory IncomeCompareCubit.create({required LocalDate month}) {
    return IncomeCompareCubit(month: month, transactionsRepo: inject(), worker: inject());
  }

  final LocalDate month;
  final TransactionsRepository transactionsRepo;
  final Worker worker;
  final subs = CompositeSubscription();

  void fetch() {
    final calculationWorker = worker;
    final averageIncomeTransactions = transactionsRepo.watch(
      TransactionsView(
        dateRange: SpecificDateRange((
          from: month.subtractMonths(1).subtractYears(1).firstDayOfMonth(),
          to: month.subtractMonths(1).lastDayOfMonth(),
        )),
        accounts: const AllAccounts(),
        categories: const AllCategories(),
        filter: const NoFilter(),
      ),
    );
    final actualIncomeTransactions = transactionsRepo.watch(
      TransactionsView(
        dateRange: SpecificDateRange((from: month.firstDayOfMonth(), to: month.lastDayOfMonth())),
        accounts: const AllAccounts(),
        categories: const AllCategories(),
        filter: const NoFilter(),
      ),
    );
    final sub =
        Rx.combineLatest2(averageIncomeTransactions, actualIncomeTransactions, (a, b) => (a, b))
            .asyncMap((event) async {
              final (averageIncomeTransactions, actualIncomeTransactions) = event;
              return calculateIncomeCompareStateInWorker(
                worker: calculationWorker,
                averageIncomeTransactions: averageIncomeTransactions,
                actualIncomeTransactions: actualIncomeTransactions,
              );
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

class IncomeCompare extends HookWidget {
  const IncomeCompare({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncomeCompareCubit.create(month: month),
      child: BlocBuilder<IncomeCompareCubit, Async<IncomeCompareState>>(
        builder: (context, state) {
          final $state = state.valueOr(IncomeCompareState.empty());
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
                      '${$state.incomeDifferencePercent.abs()}%',
                      style: context.text.headline.copyWith(height: 1),
                    ),
                    Text(
                      '${$state.incomeDifferencePercent.isNegative ? 'less' : 'more'} than average',
                    ),
                  ].spaced(),
                ),
                Builder(
                  builder: (context) {
                    if (state.isLoading) {
                      return const LoadingChart(showAxisDetails: false);
                    }
                    return AmountCompare(
                      comparison: $state.averageIncome,
                      actual: $state.actualIncome,
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
