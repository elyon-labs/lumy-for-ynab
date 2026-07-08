import 'package:collection/collection.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../ynab_api/_category_group.dart';
import 'category_balance_row.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
    required this.categories,
    required this.allCategoryGroups,
    required this.currencyFormat,
    this.rowBuilder,
  });

  final List<Category> categories;
  final List<CategoryGroup> allCategoryGroups;
  final Option<CurrencyFormat> currencyFormat;
  final Widget Function(Category c)? rowBuilder;

  @override
  Widget build(BuildContext context) {
    final groups = allCategoryGroups
        .map((e) {
          return e.copyWith(
            categories: categories.where((c) => c.categoryGroupId == e.id).toList(),
          );
        })
        .whereNot((g) => g.categories.isEmpty)
        .toList();

    final rows = groups.map((group) {
      return VLayout(
        spacing: 0,
        children: [
          if (!group.isInternalMasterCategory)
            VEdgePadding(
              child: HEdgePadding(
                child: Text(
                  group.name,
                  style: context.text.title.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          VLayout(
            children: group.categories.map((category) {
              return rowBuilder?.call(category) ??
                  CategoryBalanceRow(category: category, currencyFormat: currencyFormat);
            }).toList(),
          ),
        ],
      );
    });

    return VEdgePadding(
      child: VLayout(children: rows, spacing: Sizes.unit * 2),
    );
  }
}
