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

class IncomeTitleState {
  IncomeTitleState({required this.amount, required this.comparisonAmount});

  factory IncomeTitleState.empty() {
    return IncomeTitleState(amount: 0, comparisonAmount: 0);
  }

  final int amount;
  final int comparisonAmount;
}

class IncomeTitleInput {
  const IncomeTitleInput({required this.actual, required this.comparison});

  final List<PastTransaction> actual;
  final List<PastTransaction> comparison;
}

IncomeTitleState calculateIncomeTitleStateSync(IncomeTitleInput input) {
  return IncomeTitleState(
    amount: input.actual.sumAmountFilteredSync(isIncome),
    comparisonAmount: input.comparison.sumAmountFilteredSync(isIncome),
  );
}

Future<IncomeTitleState> calculateIncomeTitleStateInWorker({
  required Worker worker,
  required List<PastTransaction> actual,
  required List<PastTransaction> comparison,
}) {
  final input = IncomeTitleInput(actual: actual, comparison: comparison);
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateIncomeTitleStateSync(input),
  );
}

class IncomeTitleCubit extends Cubit<Async<IncomeTitleState>> {
  IncomeTitleCubit({
    required this.month,
    required this.settings,
    required this.transactionsRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory IncomeTitleCubit.create({required LocalDate month}) {
    return IncomeTitleCubit(
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
    return transactionsRepo.watch(
      TransactionsView(
        dateRange: SpecificDateRange((from: month.firstDayOfMonth(), to: month.lastDayOfMonth())),
        accounts: const OnBudgetAccounts(),
        categories: const AllCategories(),
        filter: const NoFilter(),
      ),
    );
  }

  final subs = CompositeSubscription();

  void fetch() {
    final actual = calculate(month);
    final comparison = calculate(comparisonMonth.subtractMonths(1));
    final calculationWorker = worker;

    subs.add(
      Rx.combineLatest2(actual, comparison, (a, b) => (a, b)).listen((state) async {
        final (actual, comparison) = state;
        final data = await calculateIncomeTitleStateInWorker(
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

class IncomeTitle extends HookWidget {
  const IncomeTitle({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();

    return BlocProvider(
      create: (context) => IncomeTitleCubit.create(month: month),
      child: BlocBuilder<IncomeTitleCubit, Async<IncomeTitleState>>(
        builder: (context, state) {
          final $state = state.mapOr((value) => value, IncomeTitleState.empty());
          return VLayout(
            spacing: 0,
            children: [
              Text('Income', style: context.text.title),
              const Text('Nice work! You earned'),
              const VSpace(),
              Skeletonizer(
                enabled: state.isLoading,
                child: Text($state.amount.format(currencyFormat), style: context.text.headline),
              ),
              Skeletonizer(
                enabled: state.isLoading,
                child: Builder(
                  builder: (context) {
                    final month = context.watch<IncomeTitleCubit>().comparisonMonth;
                    final monthName = month.monthOfYear.toMonthName();
                    final $comparison = $state.comparisonAmount.format(currencyFormat);
                    return Text(
                      '$monthName: ${$comparison}',
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
