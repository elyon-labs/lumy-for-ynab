import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../common/domain/accounts/accounts_view.dart';
import '../../../common/domain/categories/categories_view.dart';
import '../../../common/domain/payees/payees_repository.dart';
import '../../../common/domain/payees/payees_view.dart';
import '../../../common/domain/scheduled_transactions/scheduled_transactions_repository.dart';
import '../../../common/domain/transactions/transactions_view.dart';
import '../../../common/domain/worker/_base_transactions_async.dart';
import '../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../../../ynab_api/_scheduled_transaction.dart';
import '../../date_range/domain/models/date_range.dart';
import '../hydrated_scheduled_transaction.dart';
import 'recurring_transactions_payee_tab.dart';
import 'recurring_transactions_timeline_tab.dart';
import 'widgets/recurring_transactions_options_sheet.dart';

class RecurringTransaction {
  RecurringTransaction({required this.payee, required this.transaction});

  final Option<Payee> payee;
  final HydratedScheduledTransaction transaction;
}

sealed class ScheduleNode {
  const ScheduleNode({required this.date});

  final LocalDate date;
}

class EmptyNode extends ScheduleNode {
  const EmptyNode({required super.date});
}

class TransactionsNode extends ScheduleNode {
  const TransactionsNode({required super.date, required this.instances});

  final List<ScheduledTransactionInstance> instances;
}

class RecurringTransactionsScreenState {
  RecurringTransactionsScreenState({
    required this.transactions,
    required this.timeline,
    required this.showAnnualPricing,
    required this.sortType,
  });

  factory RecurringTransactionsScreenState.initial() {
    return RecurringTransactionsScreenState(
      transactions: const Loading(),
      timeline: const Loading(),
      showAnnualPricing: false,
      sortType: RecurringTransactionsSortType.amountAsc,
    );
  }

  final Async<Map<Option<Payee>, List<RecurringTransaction>>> transactions;
  final Async<List<ScheduleNode>> timeline;
  final bool showAnnualPricing;
  final RecurringTransactionsSortType sortType;
}

class RecurringTransactionsScreenCubit extends Cubit<RecurringTransactionsScreenState> {
  RecurringTransactionsScreenCubit({
    required this.repo,
    required this.payeesRepo,
    required this.settings,
  }) : super(RecurringTransactionsScreenState.initial()) {
    fetch();
  }

  factory RecurringTransactionsScreenCubit.create() {
    return RecurringTransactionsScreenCubit(
      repo: inject(),
      payeesRepo: inject(),
      settings: inject(),
    );
  }

  final Settings settings;
  final ScheduledTransactionsRepository repo;
  final PayeesRepository payeesRepo;

  final subs = CompositeSubscription();

  void fetch() {
    final sub =
        Rx.combineLatest3(
              repo.watch(
                TransactionsView(
                  accounts: const AllAccounts(),
                  categories: const CategoriesInSelectedView(),
                  dateRange: const AllTime(),
                  filter: CustomFilter((t, _) {
                    return t is HydratedScheduledTransaction;
                  }),
                ),
              ),
              payeesRepo.watch(const AllPayees()),
              settings.watchRecurringTransactionsSortType(),
              (transactions, payees, sortType) => (transactions, payees, sortType),
            )
            .switchMap((event) async* {
              final (transactions, payees, sortType) = event;

              Future<Map<Option<Payee>, List<RecurringTransaction>>>
              payeesToRecurringTransactions() async {
                final transactionsWithFrequencies = transactions.where((t) {
                  return t.frequency != ScheduledTransactionFrequency.never;
                });

                final groupedByPayee = await transactionsWithFrequencies.groupByPayee(payees);

                final payeesToTransactions = groupedByPayee.entries
                    .map((entry) {
                      final payee = entry.key;
                      final transactions = entry.value;

                      final recurringTransactions = transactions.map((transaction) {
                        return RecurringTransaction(payee: payee, transaction: transaction);
                      }).toList();

                      return MapEntry(payee, recurringTransactions);
                    })
                    .sorted((a, b) {
                      if (sortType == RecurringTransactionsSortType.alphabeticallyAsc ||
                          sortType == RecurringTransactionsSortType.alphabeticallyDesc) {
                        final nameA = a.key.mapOr((p) => p.name, '');
                        final nameB = b.key.mapOr((p) => p.name, '');
                        return sortType == RecurringTransactionsSortType.alphabeticallyAsc
                            ? nameA.compareTo(nameB)
                            : nameB.compareTo(nameA);
                      } else {
                        // Using `sync` methods here because this should be a very small number of transactions.
                        final totalA = a.value
                            .map((s) => s.transaction)
                            .sumAmountFilteredSync((_, __) => true);
                        final totalB = b.value
                            .map((s) => s.transaction)
                            .sumAmountFilteredSync((_, __) => true);
                        return sortType == RecurringTransactionsSortType.amountAsc
                            ? totalA.compareTo(totalB)
                            : totalB.compareTo(totalA);
                      }
                    });

                return Map.fromEntries(payeesToTransactions);
              }

              Future<List<ScheduleNode>> timeline() async {
                final startDate = today;
                final endDate = startDate.addYears(1);
                final nodes = <ScheduleNode>[];
                final allInstances = transactions.occurrencesUntil(endDate);
                final groupedByDate = groupBy(
                  allInstances,
                  (t) => t.date,
                ).fillWith((from: startDate, to: endDate).daysInRange(), fill: (_) => []);
                for (final entry in groupedByDate.entries.sorted(
                  (a, b) => a.key.compareTo(b.key),
                )) {
                  final date = entry.key;
                  final transactions = entry.value;

                  if (transactions.isEmpty) {
                    if (nodes.isNotEmpty) {
                      final lastNode = nodes.last;
                      final lastDate = lastNode.date;
                      final daysBetween = date.subtractInternal(lastDate).inDays;
                      nodes.addAll(
                        List.generate(daysBetween, (i) => EmptyNode(date: lastDate.addDays(i + 1))),
                      );
                    } else {
                      nodes.add(EmptyNode(date: date));
                    }
                  } else {
                    nodes.add(TransactionsNode(date: date, instances: transactions));
                  }
                }

                return nodes;
              }

              yield RecurringTransactionsScreenState(
                transactions: Loaded(await payeesToRecurringTransactions()),
                timeline: Loaded(await timeline()),
                showAnnualPricing: state.showAnnualPricing,
                sortType: sortType,
              );
            })
            .listen(safeEmit);

    subs.add(sub);
  }

  void setSortType(RecurringTransactionsSortType sortType) {
    settings.setRecurringTransactionsSortType(sortType);
  }

  void toggleAnnualPricing() {
    safeEmit(
      RecurringTransactionsScreenState(
        transactions: state.transactions,
        timeline: state.timeline,
        showAnnualPricing: !state.showAnnualPricing,
        sortType: state.sortType,
      ),
    );
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class RecurringTransactionsScreen extends HookWidget {
  const RecurringTransactionsScreen({super.key});

  static String route = '/reports/recurring_transactions';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recurring Transactions'),
          bottom: const TabBar(
            dividerHeight: 0,
            tabs: [
              Tab(child: Text('Payees')),
              Tab(child: Text('Timeline')),
            ],
          ),
        ),
        body: BlocProvider(
          create: (_) => RecurringTransactionsScreenCubit.create(),
          child: const TabBarView(
            children: [RecurringTransactionsPayeeTab(), RecurringTransactionsTimelineTab()],
          ),
        ),
      ),
    );
  }
}

extension on List<HydratedScheduledTransaction> {
  /// Returns a new [List] of [HydratedScheduledTransaction] with instances based
  /// on the frequency of the transactions until the given [date].
  List<ScheduledTransactionInstance> occurrencesUntil(LocalDate date) {
    return expand((transaction) => transaction.occurrencesUntil(date)).toList();
  }
}

extension on HydratedScheduledTransaction {
  /// Returns a new [List] of [HydratedScheduledTransaction] with instances based
  /// on the frequency of the transaction until the given [date].
  List<ScheduledTransactionInstance> occurrencesUntil(LocalDate date) {
    final occurrences = <ScheduledTransactionInstance>[];
    var next = localDateNext;
    while (next <= date) {
      occurrences.add(instance(next));
      next = next.addFrequency(frequency);
      if (next == localDateNext) break;
    }
    return occurrences;
  }

  ScheduledTransactionInstance instance(LocalDate date) {
    return ScheduledTransactionInstance(transaction: this, date: date);
  }
}

extension on LocalDate {
  LocalDate addFrequency(ScheduledTransactionFrequency frequency) {
    return switch (frequency) {
      ScheduledTransactionFrequency.never => this,
      ScheduledTransactionFrequency.daily => addDays(1),
      ScheduledTransactionFrequency.weekly => addWeeks(1),
      ScheduledTransactionFrequency.everyOtherWeek => addWeeks(2),
      ScheduledTransactionFrequency.twiceAMonth => addDays(15),
      ScheduledTransactionFrequency.every4Weeks => addWeeks(4),
      ScheduledTransactionFrequency.monthly => addMonths(1),
      ScheduledTransactionFrequency.everyOtherMonth => addMonths(2),
      ScheduledTransactionFrequency.every3Months => addMonths(3),
      ScheduledTransactionFrequency.every4Months => addMonths(4),
      ScheduledTransactionFrequency.twiceAYear => addMonths(6),
      ScheduledTransactionFrequency.yearly => addYears(1),
      ScheduledTransactionFrequency.everyOtherYear => addYears(2),
    };
  }
}

class ScheduledTransactionInstance {
  ScheduledTransactionInstance({required this.transaction, required this.date});

  final HydratedScheduledTransaction transaction;
  final LocalDate date;
}
