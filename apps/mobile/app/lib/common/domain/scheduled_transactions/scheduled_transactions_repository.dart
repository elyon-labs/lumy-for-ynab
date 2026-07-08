import 'package:flutter/foundation.dart' hide Category;
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../features/date_range/domain/models/date_range.dart';
import '../../../features/recurring_transactions/hydrated_scheduled_transaction.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_local_date.dart';
import '../../../ynab_api/_base_transaction.dart';
import '../../../ynab_api/_category.dart';
import '../../../ynab_api/_payee.dart';
import '../../../ynab_api/_scheduled_transaction.dart';
import '../accounts/accounts_repository.dart';
import '../accounts/accounts_view.dart';
import '../categories/categories_repository.dart';
import '../categories/categories_view.dart';
import '../payees/payees_repository.dart';
import '../payees/payees_view.dart';
import '../transactions/transactions_view.dart';
import '../typedefs.dart';
import '../worker/_base_transactions_sync.dart';
import '../worker/worker.dart';

/// A repository that provides access to transactions via a [TransactionsView].
class ScheduledTransactionsRepository {
  ScheduledTransactionsRepository({
    required BudgetDataWatcher<List<ScheduledTransaction>> transactions,
    required ValueGetter<Stream<Option<String>>> budgetId,
    required ValueGetter<Stream<DateRange>> selectedDateRange,
    required CategoriesRepository categoriesRepo,
    required AccountsRepository accountsRepo,
    required PayeesRepository payeesRepo,
    required Worker worker,
  }) : _transactions = transactions,
       _accountsRepo = accountsRepo,
       _payeesRepo = payeesRepo,
       _budgetId = budgetId,
       _selectedDateRange = selectedDateRange,
       _worker = worker,
       _categoriesRepo = categoriesRepo {
    _streamFromDatabase();
  }

  /// Creates a new [ScheduledTransactionsRepository] instance.
  factory ScheduledTransactionsRepository.create() {
    return ScheduledTransactionsRepository(
      transactions: (bId) => inject<LocalDatabase>().watchScheduledTransactions(budgetId: bId),
      budgetId: inject<Settings>().watchSelectedBudgetId,
      selectedDateRange: inject<Settings>().watchSelectedDateRange,
      categoriesRepo: inject(),
      accountsRepo: inject(),
      payeesRepo: inject(),
      worker: inject(),
    );
  }

  final BudgetDataWatcher<List<ScheduledTransaction>> _transactions;
  final ValueGetter<Stream<Option<String>>> _budgetId;
  final ValueGetter<Stream<DateRange>> _selectedDateRange;
  final CategoriesRepository _categoriesRepo;
  final AccountsRepository _accountsRepo;
  final PayeesRepository _payeesRepo;
  final Worker _worker;

  final _all = BehaviorSubject<List<HydratedScheduledTransaction>>();

  void _streamFromDatabase() {
    Rx.combineLatest3(
          _payeesRepo.watch(const AllPayees()),
          _categoriesRepo.watchCategories(const AllCategories()),
          _budgetId(),
          (payees, categories, budgetId) {
            return (payees, categories, budgetId);
          },
        )
        .switchMap((event) {
          final (payees, categories, budgetId) = event;

          switch (budgetId) {
            case Some<String>(:final some):
              return _transactions(some).switchMap((txns) async* {
                final payeesMap = payees.toMap();
                final categoriesMap = categories.toMap();
                yield txns
                    .toHydratedScheduledTransactions(
                      payeesMap: payeesMap,
                      categoriesMap: categoriesMap,
                    )
                    .toList();
              });
            case None<String>():
              return Stream.value(List<HydratedScheduledTransaction>.empty());
          }
        })
        .listen(_all.add);
  }

  ValueStream<List<HydratedScheduledTransaction>> watch(TransactionsView view) {
    return Rx.combineLatest4(
      _all,
      _categoriesRepo.watchCategories(view.categories),
      _accountsRepo.watch(view.accounts),
      _selectedDateRange(),
      (transactions, categories, accounts, dateRange) {
        return (transactions, categories, accounts, dateRange);
      },
    ).asyncMap((event) async {
      final (transactions, categories, accounts, dateRange) = event;
      return await _worker.run(_applyView(view, dateRange, transactions, accounts, categories));
    }).shareValue();
  }

  Future<void> dispose() {
    return _all.close();
  }
}

/// Applies the given [view] to [allTransactions].
Iterable<HydratedScheduledTransaction> _iterateTxn(
  TransactionsView view,
  DateRange selectedDateRange,
  Iterable<HydratedScheduledTransaction> allTransactions,
  Iterable<Account> accountsInView,
  Iterable<Category> categoriesInView,
) sync* {
  final range = switch (view.dateRange) {
    AllTime() => (from: LocalDate(1970, 1, 1), to: today),
    SelectedDateRange() => selectedDateRange,
    SpecificDateRange(:final dateRange) => dateRange,
  };
  final accounts = accountsInView;
  final categories = categoriesInView;
  final filter = view.filter.filter;
  final categoryIds = categories.ids;

  for (final t in allTransactions) {
    // Don't yield if this transaction is outside the date range.
    if (view.dateRange is! AllTime && !t.localDateFirst.isBetween(range.from, range.to)) {
      continue;
    }
    // Don't yield if this transaction is not in the selected accounts.
    if (view.accounts is! AllAccounts && !accounts.any((a) => a.id == t.accountId)) {
      continue;
    }
    // Yield if we don't care about categories or filters.
    if (view.categories is AllCategories && view.filter is NoFilter) {
      yield t;
      continue;
    }

    // Yield only if this transaction is in the selected categories and passes the filter.
    // Also, filter its sub-transactions.
    yield* [t].filterSync((txn, parent) {
      return txn.categoryIds.any(categoryIds.contains) && filter(txn, parent);
    });
  }
}

/// A pass-through function that invokes [_iterateTxn] with the given arguments.
///
/// TODO: I'd like to collapse this and [_iterateTxn] but passing sync* functions
/// over an isolate directly is tricky/impossible?
List<HydratedScheduledTransaction> Function() _applyView(
  TransactionsView view,
  DateRange selectedDateRange,
  Iterable<HydratedScheduledTransaction> allTransactions,
  Iterable<Account> allAccounts,
  Iterable<Category> categoriesInView,
) {
  return () {
    return _iterateTxn(
      view,
      selectedDateRange,
      allTransactions,
      allAccounts,
      categoriesInView,
    ).toList();
  };
}
