import 'dart:async';

import 'package:lumy/common/domain/accounts/accounts_view.dart';
import 'package:lumy/common/domain/accounts/filters.dart';
import 'package:lumy/common/domain/categories/categories_view.dart';
import 'package:lumy/common/domain/transactions/transactions_repository.dart';
import 'package:lumy/common/domain/transactions/transactions_view.dart';
import 'package:lumy/common/domain/typedefs.dart';
import 'package:lumy/features/date_range/domain/models/date_range.dart';
import 'package:lumy/utils/_local_date.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../factory/account_factory.dart';
import '../../../factory/category_factory.dart';
import '../../../factory/transaction_factory.dart';
import '../../../utilities/fake_accounts_repository.dart';
import '../../../utilities/fake_categories_repository.dart';

void main() {
  group('TransactionsRepository', () {
    BudgetDataWatcher<List<PastTransaction>> transactions() {
      return (budgetId) {
        if (budgetId == 'abcd12345') {
          return Stream.value([TransactionFactory.build(id: 'abcd12345')]).shareValue();
        }
        return Stream.value([TransactionFactory.build(id: 'other')]).shareValue();
      };
    }

    Stream<DateRange> dateRange() {
      return Stream.value((from: LocalDate(1970, 1, 1), to: today));
    }

    group('watch', () {
      test('it emits empty when no budgetId is selected', () async {
        final subject = TransactionsRepository(
          transactions: transactions(),
          categoriesRepo: FakeCategoriesRepository(),
          accountsRepo: FakeAccountsRepository(),
          budgetId: () => Stream.value(const None<String>()).shareValue(),
          selectedDateRange: () => dateRange().shareValue(),
        );

        expect(subject.watch(TransactionsView.all()), emits([]));
      });

      test('it emits transactions when budgetId is selected', () async {
        // ignore: prefer_function_declarations_over_variables
        final stream = () => Stream.value(const Some('abcd12345')).shareValue();

        BudgetDataWatcher<List<PastTransaction>> transactions() {
          final transaction = TransactionFactory.build();
          return (budgetId) {
            return Stream.value([transaction.copyWith(id: 'other')]).shareValue();
          };
        }

        final subject = TransactionsRepository(
          transactions: transactions(),
          categoriesRepo: FakeCategoriesRepository(),
          accountsRepo: FakeAccountsRepository(),
          budgetId: stream,
          selectedDateRange: () => dateRange().shareValue(),
        );

        expect(
          subject.watch(TransactionsView.all()),
          emits([isA<PastTransaction>().having((p0) => p0.id, 'id', 'other')]),
        );
      });

      test('it allows multiple subscribers', () async {
        // ignore: prefer_function_declarations_over_variables
        final budgetId = () => Stream.value(const Some('abcd12345')).shareValue();

        BudgetDataWatcher<List<PastTransaction>> transactions() {
          final transaction = TransactionFactory.build();
          return (budgetId) {
            return Stream.value([transaction.copyWith(id: 'other')]).shareValue();
          };
        }

        final subject = TransactionsRepository(
          transactions: transactions(),
          categoriesRepo: FakeCategoriesRepository(),
          accountsRepo: FakeAccountsRepository(),
          budgetId: budgetId,
          selectedDateRange: () => dateRange().shareValue(),
        );

        final emitted1 = <List<PastTransaction>>[];
        final observer1 = subject.watch(TransactionsView.all()).listen(emitted1.add);

        final emitted2 = <List<PastTransaction>>[];
        final observer2 = subject.watch(TransactionsView.all()).listen(emitted2.add);

        await pumpEventQueue();

        expect(emitted1, isNotEmpty);
        expect(emitted2, isNotEmpty);

        await observer1.cancel();
        await observer2.cancel();

        final emitted3 = <List<PastTransaction>>[];
        final observer3 = subject.watch(TransactionsView.all()).listen(emitted3.add);

        await pumpEventQueue();

        expect(emitted3, isNotEmpty);

        await observer3.cancel();
      });

      test('it replays a shared base view to a later filtered subscriber', () async {
        final transactions = BehaviorSubject<List<PastTransaction>>.seeded([
          TransactionFactory.build(
            id: 'expense',
            amount: -1000,
            date: '2026-01-15',
            categoryId: 'category',
            isDeleted: false,
            subTransactions: const [],
          ),
        ]);
        final subject = TransactionsRepository(
          transactions: (_) => transactions,
          categoriesRepo: FakeCategoriesRepository(
            categories: [CategoryFactory.build(id: 'category', isDeleted: false, isHidden: false)],
          ),
          accountsRepo: FakeAccountsRepository(),
          budgetId: () => Stream.value(const Some('abcd12345')),
          selectedDateRange: dateRange,
        );
        const baseView = TransactionsView(
          dateRange: SelectedDateRange(),
          accounts: AllAccounts(),
          categories: AllCategories(),
          filter: NoFilter(),
        );
        const filteredView = TransactionsView(
          dateRange: SelectedDateRange(),
          accounts: AllAccounts(),
          categories: CategoriesInSelectedView(),
          filter: NoFilter(),
        );

        final baseSubscription = subject.watch(baseView).listen((_) {});
        await pumpEventQueue();

        final filtered = await subject
            .watch(filteredView)
            .first
            .timeout(const Duration(seconds: 1));

        expect(filtered.map((transaction) => transaction.id), ['expense']);

        await baseSubscription.cancel();
        await subject.dispose();
        await transactions.close();
      });

      test('it recreates an evicted stream for a later subscriber', () async {
        final transactions = BehaviorSubject<List<PastTransaction>>.seeded([
          TransactionFactory.build(id: 'january', date: '2026-01-15'),
          TransactionFactory.build(id: 'february', date: '2026-02-15'),
        ]);
        final selectedDateRange = BehaviorSubject<DateRange>.seeded((
          from: LocalDate(2026, 1, 1),
          to: LocalDate(2026, 1, 31),
        ));
        final subject = TransactionsRepository(
          transactions: (_) => transactions,
          categoriesRepo: FakeCategoriesRepository(),
          accountsRepo: FakeAccountsRepository(),
          budgetId: () => Stream.value(const Some('abcd12345')),
          selectedDateRange: () => selectedDateRange,
        );
        const view = TransactionsView(
          dateRange: SelectedDateRange(),
          accounts: AllAccounts(),
          categories: AllCategories(),
          filter: NoFilter(),
        );

        final firstStream = subject.watch(view);
        final firstEmitted = <List<PastTransaction>>[];
        final firstSubscription = firstStream.listen(firstEmitted.add);
        await pumpEventQueue();

        expect(firstEmitted.single.map((transaction) => transaction.id), ['january']);

        await firstSubscription.cancel();

        final secondStream = subject.watch(view);
        final secondEmitted = <List<PastTransaction>>[];
        final secondSubscription = secondStream.listen(secondEmitted.add);
        await pumpEventQueue();

        expect(identical(firstStream, secondStream), false);

        selectedDateRange.add((from: LocalDate(2026, 2, 1), to: LocalDate(2026, 2, 28)));
        await pumpEventQueue();

        expect(secondEmitted.last.map((transaction) => transaction.id), ['february']);

        await secondSubscription.cancel();
        await subject.dispose();
        await transactions.close();
        await selectedDateRange.close();
      });

      test('it reuses streams for equivalent transaction views', () async {
        var accountsWatchCount = 0;
        final subject = TransactionsRepository(
          transactions: transactions(),
          categoriesRepo: FakeCategoriesRepository(),
          accountsRepo: FakeAccountsRepository(
            accounts: (_) {
              accountsWatchCount++;
              return const [];
            },
          ),
          budgetId: () => Stream.value(const Some('abcd12345')).shareValue(),
          selectedDateRange: () => dateRange().shareValue(),
        );

        final first = subject.watch(TransactionsView.all());
        final second = subject.watch(TransactionsView.all());

        expect(identical(first, second), true);
        expect(accountsWatchCount, 1);

        await subject.dispose();
      });

      test('it reuses streams for views that only differ by debug id', () async {
        var accountsWatchCount = 0;
        final subject = TransactionsRepository(
          transactions: transactions(),
          categoriesRepo: FakeCategoriesRepository(),
          accountsRepo: FakeAccountsRepository(
            accounts: (_) {
              accountsWatchCount++;
              return const [];
            },
          ),
          budgetId: () => Stream.value(const Some('abcd12345')).shareValue(),
          selectedDateRange: () => dateRange().shareValue(),
        );

        const firstView = TransactionsView(
          dateRange: AllTime(),
          accounts: AccountsInFilter(isOnBudgetAccount),
          categories: AllCategories(),
          filter: NoFilter(),
          debugId: 'first',
        );
        const secondView = TransactionsView(
          dateRange: AllTime(),
          accounts: AccountsInFilter(isOnBudgetAccount),
          categories: AllCategories(),
          filter: NoFilter(),
          debugId: 'second',
        );

        final first = subject.watch(firstView);
        final second = subject.watch(secondView);

        expect(identical(first, second), true);
        expect(accountsWatchCount, 1);

        await subject.dispose();
      });

      test('it reuses date and account filtering for related transaction views', () async {
        var accountsWatchCount = 0;
        final subject = TransactionsRepository(
          transactions: transactions(),
          categoriesRepo: FakeCategoriesRepository(),
          accountsRepo: FakeAccountsRepository(
            accounts: (_) {
              accountsWatchCount++;
              return const [];
            },
          ),
          budgetId: () => Stream.value(const Some('abcd12345')).shareValue(),
          selectedDateRange: () => dateRange().shareValue(),
        );

        const [
          TransactionsView(
            dateRange: SelectedDateRange(),
            accounts: AccountsInFilter(isOnBudgetAccount),
            categories: CategoriesInSelectedView(),
            filter: ExpenseFilter(),
          ),
          TransactionsView(
            dateRange: SelectedDateRange(),
            accounts: AccountsInFilter(isOnBudgetAccount),
            categories: ExpensesInSelectedView(),
            filter: ExpenseFilter(),
          ),
        ].forEach(subject.watch);

        expect(accountsWatchCount, 1);

        await subject.dispose();
      });

      test('it filters by account and category using the hydrated views', () async {
        const accountId = 'account-id';
        const categoryId = 'category-id';
        final account = AccountFactory.build(id: accountId);
        final category = CategoryFactory.build(id: categoryId);
        final matching = TransactionFactory.build(
          id: 'matching',
          accountId: accountId,
          categoryId: categoryId,
          date: '2026-01-01',
          subTransactions: const [],
        );
        final wrongAccount = TransactionFactory.build(
          id: 'wrong-account',
          accountId: 'other-account-id',
          categoryId: categoryId,
          date: '2026-01-01',
          subTransactions: const [],
        );
        final wrongCategory = TransactionFactory.build(
          id: 'wrong-category',
          accountId: accountId,
          categoryId: 'other-category-id',
          date: '2026-01-01',
          subTransactions: const [],
        );

        final subject = TransactionsRepository(
          transactions: (_) => Stream.value([matching, wrongAccount, wrongCategory]).shareValue(),
          categoriesRepo: FakeCategoriesRepository(categories: [category]),
          accountsRepo: FakeAccountsRepository(accounts: (_) => [account]),
          budgetId: () => Stream.value(const Some('abcd12345')).shareValue(),
          selectedDateRange: () => dateRange().shareValue(),
        );

        expect(
          subject.watch(
            const TransactionsView(
              dateRange: AllTime(),
              accounts: AccountsWithIds([accountId]),
              categories: CategoriesWithIds([categoryId]),
              filter: NoFilter(),
            ),
          ),
          emits([isA<PastTransaction>().having((t) => t.id, 'id', 'matching')]),
        );
      });

      test(
        'it preserves matching split parents and removes non-matching subtransactions',
        () async {
          const accountId = 'account-id';
          const categoryId = 'category-id';
          final account = AccountFactory.build(id: accountId);
          final category = CategoryFactory.build(id: categoryId);
          final transaction = TransactionFactory.build(
            id: 'split',
            accountId: accountId,
            categoryId: null,
            date: '2026-01-01',
            subTransactions: [
              SubTransactionFactory.build(
                id: 'matching-subtransaction',
                amount: -1000,
                categoryId: categoryId,
              ),
              SubTransactionFactory.build(
                id: 'other-subtransaction',
                amount: -2000,
                categoryId: 'other-category-id',
              ),
            ],
          );

          final subject = TransactionsRepository(
            transactions: (_) => Stream.value([transaction]).shareValue(),
            categoriesRepo: FakeCategoriesRepository(categories: [category]),
            accountsRepo: FakeAccountsRepository(accounts: (_) => [account]),
            budgetId: () => Stream.value(const Some('abcd12345')).shareValue(),
            selectedDateRange: () => dateRange().shareValue(),
          );

          expect(
            subject.watch(
              const TransactionsView(
                dateRange: AllTime(),
                accounts: AccountsWithIds([accountId]),
                categories: CategoriesWithIds([categoryId]),
                filter: ExpenseFilter(),
              ),
            ),
            emits([
              isA<PastTransaction>().having((t) => t.id, 'id', 'split').having(
                (t) => t.subTransactions.map((s) => s.id),
                'subtransaction ids',
                ['matching-subtransaction'],
              ),
            ]),
          );
        },
      );

      test('it ignores selected date range changes for all time and specific date views', () async {
        final selectedDateRange = BehaviorSubject<DateRange>.seeded((
          from: LocalDate(2026, 1, 1),
          to: LocalDate(2026, 1, 31),
        ));
        var selectedDateRangeSubscriptionCount = 0;
        final transaction = TransactionFactory.build(
          id: 'transaction',
          date: '2026-01-15',
          subTransactions: const [],
        );

        final subject = TransactionsRepository(
          transactions: (_) => Stream.value([transaction]).shareValue(),
          categoriesRepo: FakeCategoriesRepository(),
          accountsRepo: FakeAccountsRepository(),
          budgetId: () => Stream.value(const Some('abcd12345')).shareValue(),
          selectedDateRange: () {
            selectedDateRangeSubscriptionCount++;
            return selectedDateRange;
          },
        );

        final allTimeEmitted = <List<PastTransaction>>[];
        final allTimeSub = subject.watch(TransactionsView.all()).listen(allTimeEmitted.add);
        final specificEmitted = <List<PastTransaction>>[];
        final specificRange = (from: LocalDate(2026, 1, 1), to: LocalDate(2026, 1, 31));
        final specificSub = subject
            .watch(
              TransactionsView(
                dateRange: SpecificDateRange(specificRange),
                accounts: const AllAccounts(),
                categories: const AllCategories(),
                filter: const NoFilter(),
              ),
            )
            .listen(specificEmitted.add);

        await pumpEventQueue();

        expect(selectedDateRangeSubscriptionCount, 0);
        expect(allTimeEmitted, hasLength(1));
        expect(specificEmitted, hasLength(1));

        selectedDateRange.add((from: LocalDate(2026, 2, 1), to: LocalDate(2026, 2, 28)));
        await pumpEventQueue();

        expect(selectedDateRangeSubscriptionCount, 0);
        expect(allTimeEmitted, hasLength(1));
        expect(specificEmitted, hasLength(1));

        await allTimeSub.cancel();
        await specificSub.cancel();
        await selectedDateRange.close();
      });
    });
  });
}
