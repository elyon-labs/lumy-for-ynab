import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../features/date_range/domain/models/date_range.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_local_date.dart';
import '../../../ynab_api/_base_transaction.dart';
import '../../../ynab_api/_transaction.dart';
import '../accounts/accounts_repository.dart';
import '../accounts/accounts_view.dart';
import '../categories/categories_repository.dart';
import '../categories/categories_view.dart';
import '../typedefs.dart';
import '../worker/_base_transactions_sync.dart';
import 'transactions_view.dart';

/// A repository that provides access to transactions via a [TransactionsView].
class TransactionsRepository {
  TransactionsRepository({
    required BudgetDataWatcher<List<PastTransaction>> transactions,
    required ValueGetter<Stream<Option<String>>> budgetId,
    required ValueGetter<Stream<DateRange>> selectedDateRange,
    required CategoriesRepository categoriesRepo,
    required AccountsRepository accountsRepo,
  }) : _transactions = transactions,
       _accountsRepo = accountsRepo,
       _budgetId = budgetId,
       _selectedDateRange = selectedDateRange,
       _categoriesRepo = categoriesRepo {
    _streamFromDatabase();
  }

  /// Creates a new [TransactionsRepository] instance.
  factory TransactionsRepository.create() {
    return TransactionsRepository(
      transactions: (bId) => inject<LocalDatabase>().watchTransactions(budgetId: bId),
      budgetId: inject<Settings>().watchSelectedBudgetId,
      selectedDateRange: inject<Settings>().watchSelectedDateRange,
      categoriesRepo: inject(),
      accountsRepo: inject(),
    );
  }

  final BudgetDataWatcher<List<PastTransaction>> _transactions;
  final ValueGetter<Stream<Option<String>>> _budgetId;
  final ValueGetter<Stream<DateRange>> _selectedDateRange;
  final CategoriesRepository _categoriesRepo;
  final AccountsRepository _accountsRepo;

  final _all = BehaviorSubject<List<PastTransaction>>();
  final _subs = CompositeSubscription();
  final _baseStreams = <_TransactionsBaseView, Stream<List<PastTransaction>>>{};
  final _viewStreams = <TransactionsView, Stream<List<PastTransaction>>>{};

  void _streamFromDatabase() {
    final sub = _budgetId()
        .switchMap((budgetId) {
          switch (budgetId) {
            case Some<String>(:final some):
              return _transactions(some);
            case None<String>():
              return Stream.value(List<PastTransaction>.empty());
          }
        })
        .listen(_all.add);
    _subs.add(sub);
  }

  Stream<List<PastTransaction>> watch(TransactionsView view) {
    return _cacheWhileObserved(_viewStreams, view, () => _watchUncached(view));
  }

  Stream<List<PastTransaction>> _watchUncached(TransactionsView view) {
    final baseView = _TransactionsBaseView(dateRange: view.dateRange, accounts: view.accounts);
    final baseStream = _cacheWhileObserved(_baseStreams, baseView, () => _watchBase(baseView));

    if (view.categories is AllCategories && view.filter is NoFilter) {
      return baseStream;
    }

    return Rx.combineLatest2(baseStream, _categoriesRepo.watchCategories(view.categories), (
      transactions,
      categories,
    ) {
      return (transactions, categories);
    }).asyncMap((event) async {
      final (transactions, categories) = event;
      return _applyCategoryView(view, transactions, categories);
    });
  }

  Stream<List<PastTransaction>> _watchBase(_TransactionsBaseView baseView) {
    final dateRangeStream = switch (baseView.dateRange) {
      SelectedDateRange() => _selectedDateRange(),
      SpecificDateRange(:final dateRange) => Stream.value(dateRange),
      AllTime() => Stream.value((from: LocalDate(1970, 1, 1), to: today)),
    };

    return Rx.combineLatest3(_all, _accountsRepo.watch(baseView.accounts), dateRangeStream, (
      transactions,
      accounts,
      dateRange,
    ) {
      return (transactions, accounts, dateRange);
    }).asyncMap((event) async {
      final (transactions, accounts, dateRange) = event;
      return _applyBaseView(
        view: baseView,
        selectedDateRange: dateRange,
        allTransactions: transactions,
        allAccounts: accounts,
      );
    });
  }

  Future<void> dispose() async {
    _baseStreams.clear();
    _viewStreams.clear();
    await _subs.dispose();
    await _all.close();
  }
}

Stream<V> _cacheWhileObserved<K, V>(Map<K, Stream<V>> cache, K key, Stream<V> Function() create) {
  final existing = cache[key];
  if (existing != null) return existing;

  var listenerCount = 0;
  late final Stream<V> cached;
  cached = create().doOnListen(() => listenerCount++).doOnCancel(() {
    listenerCount--;
    if (listenerCount == 0 && identical(cache[key], cached)) {
      cache.remove(key);
    }
  }).shareValue();
  cache[key] = cached;
  return cached;
}

class _TransactionsBaseView extends Equatable {
  const _TransactionsBaseView({required this.dateRange, required this.accounts});

  final DateRangeReq dateRange;
  final AccountsView accounts;

  @override
  List<Object?> get props => [dateRange, accounts];
}

List<PastTransaction> _applyBaseView({
  required _TransactionsBaseView view,
  required DateRange selectedDateRange,
  required Iterable<PastTransaction> allTransactions,
  required Iterable<Account> allAccounts,
}) {
  return _iterateBaseTxn(view, selectedDateRange, allTransactions, allAccounts).toList();
}

Iterable<PastTransaction> _iterateBaseTxn(
  _TransactionsBaseView view,
  DateRange selectedDateRange,
  Iterable<PastTransaction> allTransactions,
  Iterable<Account> accountsInView,
) sync* {
  final range = switch (view.dateRange) {
    AllTime() => (from: LocalDate(1970, 1, 1), to: today),
    SelectedDateRange() => selectedDateRange,
    SpecificDateRange(:final dateRange) => dateRange,
  };
  final accountIds = accountsInView.map((a) => a.id).toSet();

  for (final t in allTransactions) {
    // Don't yield if this transaction is outside the date range.
    if (view.dateRange is! AllTime && !t.localDate.isBetween(range.from, range.to)) {
      continue;
    }
    // Don't yield if this transaction is not in the selected accounts.
    if (view.accounts is! AllAccounts && !accountIds.contains(t.accountId)) {
      continue;
    }
    yield t;
  }
}

List<PastTransaction> _applyCategoryView(
  TransactionsView view,
  Iterable<PastTransaction> transactions,
  Iterable<Category> categoriesInView,
) {
  return _iterateCategoryTxn(view, transactions, categoriesInView).toList();
}

Iterable<PastTransaction> _iterateCategoryTxn(
  TransactionsView view,
  Iterable<PastTransaction> transactions,
  Iterable<Category> categoriesInView,
) sync* {
  final categoryIds = categoriesInView.map((c) => c.id).toSet();
  final filter = view.filter.filter;

  for (final t in transactions) {
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
