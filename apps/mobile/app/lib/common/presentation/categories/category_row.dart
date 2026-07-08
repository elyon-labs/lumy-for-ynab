import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../utils/_string.dart';
import '../design_system/list_row.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return ListRow(
      title: Text(category.name),
      leading: CircleAvatar(
        radius: Sizes.unit * 2,
        backgroundColor: context.colors.good,
        child: Text(
          category.name.alphaNumericOnly.safeSubstring(0, 1).toUpperCase(),
          style: context.text.title.copyWith(color: context.colors.onGood, height: 1),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
