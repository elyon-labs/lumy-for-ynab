import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/domain/categories/categories_repository.dart';
import '../../../../common/domain/categories/categories_view.dart';
import '../../../../common/domain/categories/category_groups_view.dart';
import '../../../../common/domain/transactions/filters.dart';
import '../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../common/domain/transactions/transactions_view.dart';
import '../../../../common/domain/worker/_base_transactions_sync.dart';
import '../../../../common/domain/worker/_transactions_sync.dart';
import '../../../../common/domain/worker/worker.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../../../utils/sort.dart';
import '../../../../ynab_api/_category_group.dart';
import '../spend_by_category_chart.dart';

class SpendByCategoryChartDataCubit extends Cubit<Async<SpendByCategoryData>> {
  SpendByCategoryChartDataCubit({
    required this.settings,
    required this.categoriesRepo,
    required this.transactionsRepo,
    required this.worker,
  }) : super(const Loading()) {
    fetch();
  }

  factory SpendByCategoryChartDataCubit.create() {
    return SpendByCategoryChartDataCubit(
      settings: inject(),
      categoriesRepo: inject(),
      transactionsRepo: inject(),
      worker: inject(),
    );
  }

  final Settings settings;
  final CategoriesRepository categoriesRepo;
  final TransactionsRepository transactionsRepo;
  final Worker worker;
  final subs = CompositeSubscription();

  void fetch() {
    final chart = SpendByCategoryChart();
    final accountsSetting = settings.watchChartAccounts(chart);

    final sub = accountsSetting
        .switchMap((accounts) async* {
          final categories = categoriesRepo.watchCategories(const ExpensesInSelectedView());
          final categoryGroups = categoriesRepo.watchCategoryGroups(const AllCategoryGroups());
          final transactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: const SelectedDateRange(),
              accounts: accounts.mapOr(AccountsWithIds.new, AccountsInFilter(chart.accountFilter)),
              categories: const CategoriesInSelectedView(),
              filter: const ExpenseFilter(),
              debugId: 'reports.spend_by_category.transactions',
            ),
          );
          yield* Rx.combineLatest3(
            categories,
            categoryGroups,
            transactions,
            (a, b, c) => (a, b, c),
          );
        })
        .switchMap((event) async* {
          final (categories, categoryGroups, transactions) = event;
          final data = await calculateSpendByCategoryInWorker(
            worker: worker,
            transactions: transactions,
            categories: categories,
            categoryGroups: categoryGroups,
          );
          yield Loaded(data);
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

Future<SpendByCategoryData> calculateSpendByCategoryInWorker({
  required Worker worker,
  required List<PastTransaction> transactions,
  required List<Category> categories,
  required List<CategoryGroup> categoryGroups,
}) {
  return runTransactionCalculation(
    worker: worker,
    calculate: () => calculateSpendByCategorySync(
      transactions: transactions,
      categories: categories,
      categoryGroups: categoryGroups,
    ),
  );
}

SpendByCategoryData calculateSpendByCategorySync({
  required List<PastTransaction> transactions,
  required List<Category> categories,
  required List<CategoryGroup> categoryGroups,
}) {
  final expenses = transactions.groupByCategorySync(categories.toList());
  final spendByCategory = <Category, int>{};
  for (final entry in expenses.entries) {
    spendByCategory[entry.key] = entry.value.sumAmountFilteredSync(isExpenseInCategory(entry.key));
  }
  final totalSpend = spendByCategory.values.sum;

  final categoriesToSpend = Map<Category, int>.from(spendByCategory)
    ..removeWhere((key, value) {
      // Don't count positive spend because that doesn't count as 'spend'
      return value >= 0;
    });

  final categoryGroupsToSpend = <CategoryGroup, int>{};
  final categoryGroupsToTransactions = <CategoryGroup, Map<LocalDate, List<PastTransaction>>>{};
  final categoryToTransactions = <Category, Map<LocalDate, List<PastTransaction>>>{};

  for (final entry in expenses.entries) {
    final category = entry.key;
    final categoryTransactions = entry.value;
    categoryToTransactions[category] = categoryTransactions.groupByDateSync(dateDesc);
    final categoryGroup = categoryGroups.firstWhereOrNull((c) => c.id == category.categoryGroupId);
    if (categoryGroup == null) {
      continue;
    }
    final inCategoryGroup = categoryTransactions.filterSync(isInCategoryGroup(categoryGroup));
    final existingCgTransactions = categoryGroupsToTransactions[categoryGroup] ?? {};
    categoryGroupsToTransactions[categoryGroup] = {
      ...existingCgTransactions,
      ...inCategoryGroup.groupByDateSync(dateDesc),
    }..sortByKeys(dateDesc);
    final spend = inCategoryGroup.sumAmountFilteredSync(isInCategoryGroup(categoryGroup));
    final existingSpend = categoryGroupsToSpend[categoryGroup] ?? 0;
    categoryGroupsToSpend[categoryGroup] = existingSpend + spend;
  }
  categoryGroupsToSpend.removeWhere((key, value) {
    // Don't count positive spend because that doesn't count as 'spend'
    return value >= 0;
  });

  /// Returns a tuple of percent of category group spend and percent of total spend
  /// for a given category
  (double, double) percentOfCategorySpend(Category category) {
    final categorySpend = categoriesToSpend[category] ?? 0;
    final categoryGroup = categoryGroups.matchingCategoryGroup(category);

    final percentOfTotalSpend = (totalSpend >= 0 ? 0 : categorySpend / totalSpend).toDouble() * 100;

    if (categoryGroup == null) {
      return (0, percentOfTotalSpend);
    }

    final categoryGroupSpend = categoryGroupsToSpend[categoryGroup] ?? 0;
    final percentOfCategoryGroupSpend =
        (categoryGroupSpend == 0 || totalSpend >= 0 ? 0 : categorySpend / categoryGroupSpend)
            .toDouble() *
        100;
    return (percentOfCategoryGroupSpend, percentOfTotalSpend);
  }

  final categorySpendData = categoriesToSpend.entries.map((entry) {
    final (percentOfCategoryGroupSpend, percentOfTotalSpend) = percentOfCategorySpend(entry.key);
    return SingleCategorySpendData(
      category: entry.key,
      spend: entry.value,
      percentOfGroupSpend: percentOfCategoryGroupSpend,
      percentOfTotalSpend: percentOfTotalSpend,
    );
  }).toList();

  double categoryGroupPercentOfTotalSpend(int categoryGroupSpend) {
    return (totalSpend == 0 || categoryGroupSpend >= 0 ? 0 : categoryGroupSpend / totalSpend)
            .toDouble() *
        100;
  }

  final categoryGroupSpendData = categoryGroupsToSpend.entries.map((entry) {
    final percentOfTotalSpend = categoryGroupPercentOfTotalSpend(entry.value);
    return SingleCategoryGroupSpendData(
      categoryGroup: entry.key,
      spend: entry.value,
      percentOfTotalSpend: percentOfTotalSpend,
    );
  }).toList();

  return SpendByCategoryData(
    totalSpend: totalSpend,
    categorySpendData: categorySpendData,
    categoryToTransactions: categoryToTransactions,
    categoryGroupsToSpendData: categoryGroupSpendData,
    categoryGroupsToTransactions: categoryGroupsToTransactions,
  );
}

sealed class CategorySpendData {
  const CategorySpendData({
    required this.spend,
    required this.percentOfGroupSpend,
    required this.percentOfTotalSpend,
  });

  final int spend;
  final double percentOfGroupSpend;
  final double percentOfTotalSpend;

  String get name {
    return switch (this) {
      SingleCategorySpendData(:final category) => category.name,
      OtherCategoriesSpendData() => 'Everything Else',
    };
  }
}

class SingleCategorySpendData extends CategorySpendData {
  const SingleCategorySpendData({
    required this.category,
    required super.spend,
    required super.percentOfGroupSpend,
    required super.percentOfTotalSpend,
  });

  final Category category;
}

class OtherCategoriesSpendData extends CategorySpendData {
  const OtherCategoriesSpendData({
    required super.spend,
    required super.percentOfGroupSpend,
    required super.percentOfTotalSpend,
  });
}

sealed class CategoryGroupSpendData {
  const CategoryGroupSpendData({required this.spend, required this.percentOfTotalSpend});

  final int spend;
  final double percentOfTotalSpend;

  String get name {
    return switch (this) {
      SingleCategoryGroupSpendData(:final categoryGroup) => categoryGroup.name,
      OtherCategoryGroupsSpendData() => 'Everything Else',
    };
  }
}

class SingleCategoryGroupSpendData extends CategoryGroupSpendData {
  const SingleCategoryGroupSpendData({
    required this.categoryGroup,
    required super.spend,
    required super.percentOfTotalSpend,
  });

  final CategoryGroup categoryGroup;
}

class OtherCategoryGroupsSpendData extends CategoryGroupSpendData {
  const OtherCategoryGroupsSpendData({required super.spend, required super.percentOfTotalSpend});
}

class SpendByCategoryData extends Equatable {
  const SpendByCategoryData({
    required this.totalSpend,
    required this.categorySpendData,
    required this.categoryToTransactions,
    required this.categoryGroupsToSpendData,
    required this.categoryGroupsToTransactions,
  });

  final int totalSpend;
  final List<SingleCategorySpendData> categorySpendData;
  final Map<Category, Map<LocalDate, List<PastTransaction>>> categoryToTransactions;
  final List<CategoryGroupSpendData> categoryGroupsToSpendData;
  final Map<CategoryGroup, Map<LocalDate, List<PastTransaction>>> categoryGroupsToTransactions;

  @override
  List<Object?> get props => [
    totalSpend,
    categorySpendData,
    categoryToTransactions,
    categoryGroupsToSpendData,
    categoryGroupsToTransactions,
  ];
}

extension CategorySpendDataX on Iterable<SingleCategorySpendData> {
  List<SingleCategorySpendData> get sortedBySpendAsc {
    return List.from(this)..sort((a, b) => a.spend.compareTo(b.spend));
  }

  List<SingleCategorySpendData> get sortedBySpendDesc {
    return List.from(this)..sort((a, b) => b.spend.compareTo(a.spend));
  }

  List<SingleCategorySpendData> get sortedByPercentOfGroupSpendAsc {
    return List.from(this)..sort((a, b) => a.percentOfGroupSpend.compareTo(b.percentOfGroupSpend));
  }

  List<SingleCategorySpendData> get sortedByPercentOfGroupSpendDesc {
    return List.from(this)..sort((a, b) => b.percentOfGroupSpend.compareTo(a.percentOfGroupSpend));
  }

  List<SingleCategorySpendData> get sortedByPercentOfTotalSpendAsc {
    return List.from(this)..sort((a, b) => a.percentOfTotalSpend.compareTo(b.percentOfTotalSpend));
  }

  List<SingleCategorySpendData> get sortedByPercentOfTotalSpendDesc {
    return List.from(this)..sort((a, b) => b.percentOfTotalSpend.compareTo(a.percentOfTotalSpend));
  }
}

extension CategoryGroupSpendDataX on List<CategoryGroupSpendData> {
  List<CategoryGroupSpendData> get sortedBySpendAsc {
    return List.from(this)..sort((a, b) => a.spend.compareTo(b.spend));
  }

  List<CategoryGroupSpendData> get sortedBySpendDesc {
    return List.from(this)..sort((a, b) => b.spend.compareTo(a.spend));
  }

  List<CategoryGroupSpendData> get sortedByPercentOfTotalSpendAsc {
    return List.from(this)..sort((a, b) => a.percentOfTotalSpend.compareTo(b.percentOfTotalSpend));
  }

  List<CategoryGroupSpendData> get sortedByPercentOfTotalSpendDesc {
    return List.from(this)..sort((a, b) => b.percentOfTotalSpend.compareTo(a.percentOfTotalSpend));
  }
}
