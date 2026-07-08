import 'package:blackbird/blackbird.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/domain/worker/worker.dart';
import 'package:lumy/features/date_range/domain/models/date_range.dart';
import 'package:lumy/features/spend_tracker/domain/models/spend_tracker.dart';
import 'package:lumy/features/spend_tracker/domain/models/transaction_conditions.dart';
import 'package:lumy/features/spend_tracker/domain/use_cases/watch_spend_tracker_data.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../factory/account_factory.dart';
import '../../../../factory/category_factory.dart';
import '../../../../factory/category_group_factory.dart';
import '../../../../factory/payee_factory.dart';
import '../../../../factory/spend_tracker_factory.dart';
import '../../../../factory/transaction_factory.dart';

void main() {
  group('calculateSpendTrackerDataSync', () {
    const categoryId = 'category-id';
    const categoryGroupId = 'category-group-id';
    const payeeId = 'payee-id';
    const accountId = 'account-id';
    final dateRange = (from: LocalDate(2026, 1, 1), to: LocalDate(2026, 2, 28));

    SpendTrackerDataInput input({
      required TransactionCondition condition,
      required List<PastTransaction> transactions,
    }) {
      final category = CategoryFactory.build(
        id: categoryId,
        name: 'Groceries',
        categoryGroupId: categoryGroupId,
      );
      final categoryGroup = CategoryGroupFactory.build(
        id: categoryGroupId,
        name: 'Everyday',
        categories: [category],
      );
      return (
        spendTracker: SpendTrackerFactory.build(condition: condition),
        onBudgetTransactions: transactions,
        categoryGroups: [categoryGroup],
        categories: [category],
        payees: [PayeeFactory.build(id: payeeId, name: 'Store')],
        accounts: [AccountFactory.build(id: accountId, name: 'Checking')],
        selectedDateRange: dateRange,
      );
    }

    test('returns empty spend data when no transactions match', () {
      final args = input(
        condition: IsTrue(const HasMemoKeyword('coffee')),
        transactions: [
          TransactionFactory.build(
            memo: 'groceries',
            amount: -1000,
            categoryId: categoryId,
            date: '2026-01-10',
            subTransactions: const [],
          ),
        ],
      );

      final data = calculateSpendTrackerDataSync(
        spendTracker: args.spendTracker,
        onBudgetTransactions: args.onBudgetTransactions,
        categoryGroups: args.categoryGroups,
        categories: args.categories,
        payees: args.payees,
        accounts: args.accounts,
        selectedDateRange: args.selectedDateRange,
      );

      expect(data.netTotal, 0);
      expect(data.transactionsCount, 0);
      expect(data.monthsToTransactions, isEmpty);
      expect(data.monthsToSpend.values, everyElement(0));
    });

    test('keeps matching split parents and trims non-matching subtransactions', () {
      final args = input(
        condition: IsTrue(const HasCategoryId(categoryId)),
        transactions: [
          TransactionFactory.build(
            id: 'split',
            categoryId: null,
            date: '2026-01-10',
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
          ),
        ],
      );

      final data = calculateSpendTrackerDataSync(
        spendTracker: args.spendTracker,
        onBudgetTransactions: args.onBudgetTransactions,
        categoryGroups: args.categoryGroups,
        categories: args.categories,
        payees: args.payees,
        accounts: args.accounts,
        selectedDateRange: args.selectedDateRange,
      );

      expect(data.netTotal, -1000);
      expect(data.transactionsCount, 1);
      expect(data.monthsToTransactions.values.single.single.id, 'split');
      expect(
        data.monthsToTransactions.values.single.single.subTransactions.single.id,
        ['matching-subtransaction'].single,
      );
    });

    test('matches transactions by category group', () {
      final args = input(
        condition: IsTrue(const HasCategoryGroupId(categoryGroupId)),
        transactions: [
          TransactionFactory.build(
            amount: -1500,
            categoryId: categoryId,
            date: '2026-01-10',
            subTransactions: const [],
          ),
          TransactionFactory.build(
            amount: -2500,
            categoryId: 'other-category-id',
            date: '2026-01-11',
            subTransactions: const [],
          ),
        ],
      );

      final data = calculateSpendTrackerDataSync(
        spendTracker: args.spendTracker,
        onBudgetTransactions: args.onBudgetTransactions,
        categoryGroups: args.categoryGroups,
        categories: args.categories,
        payees: args.payees,
        accounts: args.accounts,
        selectedDateRange: args.selectedDateRange,
      );

      expect(data.netTotal, -1500);
      expect(data.transactionsCount, 1);
      expect(data.description, 'Transactions categorized as **Everyday**.');
    });

    test('separates income and expenses', () {
      final transactions = [
        TransactionFactory.build(
          amount: 5000,
          categoryName: 'Inflow: Ready to Assign',
          payeeName: 'Paycheck',
          date: '2026-01-10',
          subTransactions: const [],
        ),
        TransactionFactory.build(
          amount: -1200,
          categoryId: categoryId,
          date: '2026-01-11',
          subTransactions: const [],
        ),
      ];
      final incomeArgs = input(condition: IsTrue(const IsIncome()), transactions: transactions);
      final expenseArgs = input(condition: IsTrue(const IsExpense()), transactions: transactions);

      final incomeData = calculateSpendTrackerDataSync(
        spendTracker: incomeArgs.spendTracker,
        onBudgetTransactions: incomeArgs.onBudgetTransactions,
        categoryGroups: incomeArgs.categoryGroups,
        categories: incomeArgs.categories,
        payees: incomeArgs.payees,
        accounts: incomeArgs.accounts,
        selectedDateRange: incomeArgs.selectedDateRange,
      );
      final expenseData = calculateSpendTrackerDataSync(
        spendTracker: expenseArgs.spendTracker,
        onBudgetTransactions: expenseArgs.onBudgetTransactions,
        categoryGroups: expenseArgs.categoryGroups,
        categories: expenseArgs.categories,
        payees: expenseArgs.payees,
        accounts: expenseArgs.accounts,
        selectedDateRange: expenseArgs.selectedDateRange,
      );

      expect(incomeData.netTotal, 5000);
      expect(incomeData.transactionsCount, 1);
      expect(expenseData.netTotal, -1200);
      expect(expenseData.transactionsCount, 1);
      expect(expenseData.percentIncome, 0.24);
    });

    test('runs through the background worker wrapper', () async {
      final args = input(
        condition: IsTrue(const HasCategoryId(categoryId)),
        transactions: [
          TransactionFactory.build(
            amount: -1000,
            categoryId: categoryId,
            date: '2026-01-10',
            subTransactions: const [],
          ),
        ],
      );

      final data = await calculateSpendTrackerDataInWorker(
        worker: Worker.on(IsolateType.background),
        spendTracker: args.spendTracker,
        onBudgetTransactions: args.onBudgetTransactions,
        categoryGroups: args.categoryGroups,
        categories: args.categories,
        payees: args.payees,
        accounts: args.accounts,
        selectedDateRange: args.selectedDateRange,
      );

      expect(data.netTotal, -1000);
      expect(data.transactionsCount, 1);
    });
  });
}

typedef SpendTrackerDataInput = ({
  SpendTracker spendTracker,
  List<PastTransaction> onBudgetTransactions,
  List<CategoryGroup> categoryGroups,
  List<Category> categories,
  List<Payee> payees,
  List<Account> accounts,
  DateRange selectedDateRange,
});
