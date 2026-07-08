import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/widgets.dart';
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
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../../../utils/sort.dart';
import '../../../ynab_api/_transaction.dart';
import 'trend_chart.dart';

class IncomeTrendState {
  IncomeTrendState({required this.incomeByMonth});

  factory IncomeTrendState.empty() {
    return IncomeTrendState(incomeByMonth: {});
  }

  final Map<LocalDate, int> incomeByMonth;
}

class IncomeTrendInput {
  const IncomeTrendInput({required this.today, required this.transactions});

  final LocalDate today;
  final List<PastTransaction> transactions;
}

IncomeTrendState calculateIncomeTrendStateSync(IncomeTrendInput input) {
  final groupedByMonth = groupBy(
    input.transactions,
    (t) => t.localDate.firstDayOfMonth(),
  ).sortByKeys(dateAsc);
  final incomeByMonth = groupedByMonth.map(
    (key, value) => MapEntry(key, value.sumAmountFilteredSync(isIncome)),
  );

  return IncomeTrendState(
    incomeByMonth: Map.fromEntries(
      incomeByMonth.entries.whereNot((month) {
        return month.key.isSameMonthAs(input.today) || month.key.isAfter(input.today);
      }),
    ),
  );
}

Future<IncomeTrendState> calculateIncomeTrendStateInWorker({
  required Worker worker,
  required LocalDate today,
  required List<PastTransaction> transactions,
}) {
  final input = IncomeTrendInput(today: today, transactions: transactions);
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateIncomeTrendStateSync(input),
  );
}

class IncomeTrendCubit extends Cubit<Async<IncomeTrendState>> {
  IncomeTrendCubit({required this.month, required this.transactionsRepo, required this.worker})
    : super(const Loading()) {
    fetch();
  }

  factory IncomeTrendCubit.create({required LocalDate month}) {
    return IncomeTrendCubit(month: month, transactionsRepo: inject(), worker: inject());
  }

  final LocalDate month;
  final TransactionsRepository transactionsRepo;
  final Worker worker;
  final subs = CompositeSubscription();

  void fetch() {
    final calculationWorker = worker;
    final last12Months = (
      from: month.subtractYears(1).firstDayOfMonth(),
      to: month.lastDayOfMonth(),
    );
    final transactions = transactionsRepo.watch(
      TransactionsView(
        dateRange: SpecificDateRange(last12Months),
        accounts: const AllAccounts(),
        categories: const AllCategories(),
        filter: const NoFilter(),
      ),
    );
    final sub = transactions.listen((transactions) async {
      final data = await calculateIncomeTrendStateInWorker(
        worker: calculationWorker,
        today: today,
        transactions: transactions,
      );
      safeEmit(Loaded(data));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class IncomeTrend extends HookWidget {
  const IncomeTrend({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();

    return BlocProvider(
      create: (context) => IncomeTrendCubit.create(month: month),
      child: BlocBuilder<IncomeTrendCubit, Async<IncomeTrendState>>(
        builder: (context, state) {
          final $state = state.valueOr(IncomeTrendState.empty());
          return Skeletonizer(
            enabled: state.isLoading,
            child: VLayout(
              spacing: 0,
              children: [
                Text('Income trend', style: context.text.title),
                const Text("Here's how your income has been trending over time."),
                const VSpace(space: Sizes.unit * 3),
                TrendChart(
                  currencyFormat: currencyFormat,
                  source: $state.incomeByMonth.entries.toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
