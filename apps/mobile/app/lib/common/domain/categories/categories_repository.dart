import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../features/category_views/domain/models/category_view.dart';
import '../../../features/category_views/domain/use_cases/watch_category_views.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../../../ynab_api/_category.dart';
import '../../../ynab_api/_category_group.dart';
import '../typedefs.dart';
import 'categories_view.dart';
import 'category_groups_view.dart';

/// A repository that provides access to [Category]s and [CategoryGroup]s.
class CategoriesRepository {
  CategoriesRepository({
    required BudgetDataWatcher<List<CategoryGroup>> categoryGroups,
    required ValueGetter<Stream<List<CategoryView>>> categoryViews,
    required ValueGetter<Stream<Option<String>>> budgetId,
    required ValueGetter<Stream<Option<String>>> reportsTabCategoryView,
  }) : _reportsTabCategoryView = reportsTabCategoryView,
       _budgetId = budgetId,
       _categoryViews = categoryViews,
       _categoryGroups = categoryGroups {
    _streamFromDatabase();
  }

  /// Creates a new [CategoriesRepository] instance.
  factory CategoriesRepository.create() {
    return CategoriesRepository(
      categoryGroups: (bId) => inject<LocalDatabase>().watchCategoryGroups(budgetId: bId),
      categoryViews: () => WatchCategoryViews.create().call(),
      reportsTabCategoryView: inject<Settings>().watchReportsTabCategoryView,
      budgetId: inject<Settings>().watchSelectedBudgetId,
    );
  }

  final BudgetDataWatcher<List<CategoryGroup>> _categoryGroups;
  final ValueGetter<Stream<List<CategoryView>>> _categoryViews;
  final ValueGetter<Stream<Option<String>>> _budgetId;
  final ValueGetter<Stream<Option<String>>> _reportsTabCategoryView;

  final _allGroups = BehaviorSubject<List<CategoryGroup>>();
  final _allViews = BehaviorSubject<List<CategoryView>>();

  void _streamFromDatabase() {
    _budgetId()
        .switchMap((budgetId) {
          switch (budgetId) {
            case Some<String>(:final some):
              return _categoryGroups(some);
            case None<String>():
              return Stream.value(List<CategoryGroup>.empty());
          }
        })
        .listen(_allGroups.add);

    _categoryViews().listen(_allViews.add);
  }

  ValueStream<List<CategoryGroup>> watchCategoryGroups(CategoryGroupsView view) {
    return _allGroups.map((value) {
      Iterable<CategoryGroup> withoutHiddenAndSpecial(WithoutHiddenAndSpecialGroups view) sync* {
        for (final cg in value) {
          if (cg.isHidden) continue;
          if (!cg.isCreditCardPayments && !cg.isInternalMasterCategory) {
            yield cg;
          }
          if (cg.isCreditCardPayments && view.includeCreditCardPayments) {
            yield cg;
          }
          if (cg.isInternalMasterCategory && view.includeInternalMaster) {
            yield cg;
          }
        }
      }

      return switch (view) {
        AllCategoryGroups() => value.toList(),
        WithoutHiddenAndSpecialGroups() => withoutHiddenAndSpecial(view).toList(),
        OnlyHiddenAndSpecialGroups() => value.whereHiddenOrSpecial().toList(),
      };
    }).shareValue();
  }

  ValueStream<List<Category>> watchCategories(CategoriesView view) {
    return Rx.combineLatest3(_allGroups, _allViews, _reportsTabCategoryView(), (
      categoryGroups,
      categoryViews,
      reportsTabView,
    ) {
      final invalidCategoryGroups = categoryGroups.whereHiddenOrSpecial();
      final categories = categoryGroups.categories;

      final foundReportsTabView = switch (reportsTabView) {
        Some<String>(:final some) => Option.from(
          categoryViews.singleWhereOrNull((view) {
            return view.id == some;
          }),
        ),
        None<String>() => const None<CategoryView>(),
      };

      Set<String> categoriesForView(String viewId) {
        final $view = categoryViews.singleWhereOrNull((v) => v.id == viewId);
        if ($view == null) return Set<String>.from(categories.ids);
        final groupIds = $view.categoryGroupIds;
        final categoryIds = $view.categoryIds;
        return Set.from(
          categoryGroups
              .where((cg) => groupIds.contains(cg.id))
              .expand((cg) => cg.categoryIds)
              .followedBy(categoryIds)
              .toList(),
        );
      }

      final $categoriesInReportTabView = switch (foundReportsTabView) {
        Some<CategoryView>(:final some) => categoriesForView(some.id),
        None<CategoryView>() => Set<String>.from(categories.ids),
      };

      final $categoriesInView = switch (view) {
        CategoriesInView(:final viewId) => categoriesForView(viewId),
        _ => Set<String>.from(categories.ids),
      };

      final expenseCategories = categories.where((c) {
        return invalidCategoryGroups.none((cg) => cg.categoryIds.contains(c.id));
      });

      final expenseCategoriesInView = expenseCategories.select(
        expenseCategories.ids.toSet().intersection($categoriesInReportTabView).toList(),
      );

      return switch (view) {
        AllCategories() => categories.toList(),
        CategoriesInSelectedView() =>
          categories.select($categoriesInReportTabView.toList()).toList(),
        CategoriesInView() => categories.select($categoriesInView).toList(),
        CategoriesWithIds(:final categoryIds) => categories.select(categoryIds).toList(),
        ExpenseCategories() => expenseCategories.toList(),
        ExpensesInSelectedView() => expenseCategoriesInView.toList(),
      };
    }).shareValue();
  }

  Future<void> dispose() async {
    await _allViews.close();
    await _allGroups.close();
  }
}
