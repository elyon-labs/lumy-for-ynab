import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../currency.dart';
import '../decorated_child.dart';
import '../design_system/list_row.dart';

class CategoryBalanceRow extends StatelessWidget {
  const CategoryBalanceRow({super.key, required this.category, required this.currencyFormat});

  final Category category;
  final Option<CurrencyFormat> currencyFormat;

  @override
  Widget build(BuildContext context) {
    Color backgroundColorForBalance() {
      return switch (category.balance) {
        >= 0 => context.colors.good,
        _ => context.colors.error,
      };
    }

    Color textColorForBalance() {
      return switch (category.balance) {
        >= 0 => context.colors.onGood,
        _ => context.colors.onError,
      };
    }

    return ListRow(
      title: Text(category.name),
      leading: CircleAvatar(
        radius: Sizes.unit * 2,
        backgroundColor: context.colors.good,
        child: Text(
          category.name.substring(0, 1).toUpperCase(),
          style: context.text.title.copyWith(color: context.colors.onGood),
        ),
      ),
      trailing: DecoratedChild(
        color: backgroundColorForBalance(),
        child: Text(
          category.balance.format(currencyFormat),
          style: TextStyle(color: textColorForBalance()),
        ),
      ),
    );
  }
}
