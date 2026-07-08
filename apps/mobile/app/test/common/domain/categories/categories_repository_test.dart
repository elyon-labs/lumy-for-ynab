import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:lumy/common/domain/categories/categories_repository.dart';
import 'package:lumy/common/domain/categories/categories_view.dart';
import 'package:lumy/common/domain/categories/category_groups_view.dart';
import 'package:lumy/common/domain/typedefs.dart';
import 'package:lumy/features/category_views/domain/models/category_view.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../factory/category_group_factory.dart';
import '../../../factory/category_view_factory.dart';

void main() {
  group('CategoriesRepository', () {
    BudgetDataWatcher<List<CategoryGroup>> categoryGroups() {
      return (budgetId) {
        return Stream.value([CategoryGroupFactory.build()]).shareValue();
      };
    }

    ValueGetter<Stream<List<CategoryView>>> categoryViews() {
      return () {
        return Stream.value([CategoryViewFactory.build()]);
      };
    }

    group('watchCategories', () {
      test('it emits empty when no budgetId is selected', () async {
        final subject = CategoriesRepository(
          categoryGroups: categoryGroups(),
          categoryViews: categoryViews(),
          budgetId: () => Stream.value(const None<String>()).shareValue(),
          reportsTabCategoryView: () => Stream.value(const None<String>()).shareValue(),
        );

        expect(subject.watchCategories(const AllCategories()), emits([]));
      });

      test('it emits categories when budgetId is selected', () async {
        final subject = CategoriesRepository(
          categoryGroups: categoryGroups(),
          categoryViews: categoryViews(),
          budgetId: () => Stream.value(const Some<String>('abcd12345')).shareValue(),
          reportsTabCategoryView: () => Stream.value(const None<String>()).shareValue(),
        );

        expect(
          subject.watchCategories(const AllCategories()),
          emitsThrough(predicate<List<Category>>((p0) => p0.isNotEmpty)),
        );
      });
    });

    group('watchCategoryGroups', () {
      test('it emits empty when no budgetId is selected', () async {
        final subject = CategoriesRepository(
          categoryGroups: categoryGroups(),
          categoryViews: categoryViews(),
          budgetId: () => Stream.value(const None<String>()).shareValue(),
          reportsTabCategoryView: () => Stream.value(const None<String>()).shareValue(),
        );

        expect(subject.watchCategoryGroups(const AllCategoryGroups()), emits([]));
      });

      test('it emits category groups when budgetId is selected', () async {
        final subject = CategoriesRepository(
          categoryGroups: categoryGroups(),
          categoryViews: categoryViews(),
          budgetId: () => Stream.value(const Some<String>('abcd12345')).shareValue(),
          reportsTabCategoryView: () => Stream.value(const None<String>()).shareValue(),
        );

        expect(
          subject.watchCategoryGroups(const AllCategoryGroups()),
          emitsThrough(predicate<List<CategoryGroup>>((p0) => p0.isNotEmpty)),
        );
      });
    });
  });
}
