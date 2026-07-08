import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../common/domain/categories/use_categories.dart';
import '../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../ynab_api/_category.dart';
import '../../../../../domain/models/legacy_transaction_template.dart';
import 'amount_input.dart';
import 'choose_entity_modal.dart';

class TemplateCategoryRows extends HookWidget {
  const TemplateCategoryRows({
    super.key,
    required this.categoryId,
    required this.subTransactions,
    required this.isSplit,
    required this.onCategorySelected,
    required this.onCategoriesSelected,
    required this.onSubTransactionUpdated,
  });

  final String? categoryId;
  final List<SubTransactionTemplate> subTransactions;
  final bool isSplit;
  final ValueSetter<Category> onCategorySelected;
  final ValueSetter<List<Category>> onCategoriesSelected;
  final ValueSetter<SubTransactionTemplate> onSubTransactionUpdated;

  @override
  Widget build(BuildContext context) {
    final (categories, isLoading, error) = useCategories().details();

    if (isLoading || categories == null || error != null) {
      return const SizedBox.shrink();
    }

    final categoryName = categories.firstWhereOrNull((c) => categoryId == c.id)?.name;

    final title = categoryName != null
        ? Text(categoryName)
        : isSplit
        ? const Text('Split')
        : Text('Choose category', style: TextStyle(color: context.colors.muted));

    return VLayout(
      spacing: 0,
      children: [
        ListRow(
          title: title,
          leading: isSplit
              ? const Icon(Ionicons.list_circle_outline)
              : const Icon(Ionicons.folder_open_outline),
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (modalContext) => ChooseEntityModal<Category>.multiple(
                title: const Text('Choose a category'),
                entities: categories,
                builder: (category) => Text(category.name),
                onCancel: () {
                  Navigator.of(modalContext).pop();
                },
                onSelected: (category) {
                  onCategorySelected(category);
                  Navigator.of(modalContext).pop();
                },
                initialSelectedEntities: [
                  ...categories.where((c) => subTransactions.any((st) => st.categoryId == c.id)),
                ],
                onSelectedMultiple: (categories) {
                  onCategoriesSelected(categories);
                  Navigator.of(modalContext).pop();
                },
              ),
            );
          },
        ),
        for (final subTransaction in subTransactions)
          _SubTransactionRow(
            subTransaction: subTransaction,
            categories: categories,
            onUpdated: onSubTransactionUpdated,
          ),
      ],
    );
  }
}

class _SubTransactionRow extends HookWidget {
  const _SubTransactionRow({
    required this.subTransaction,
    required this.categories,
    required this.onUpdated,
  });

  final SubTransactionTemplate subTransaction;
  final List<Category> categories;
  final ValueSetter<SubTransactionTemplate> onUpdated;

  @override
  Widget build(BuildContext context) {
    final category = categories.byId(subTransaction.categoryId!);
    final amount = subTransaction.amount;

    return Padding(
      padding: const EdgeInsets.only(left: Sizes.edgePadding),
      child: ListRow(
        title: Text(category.name),
        trailing: HLayout(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 100,
              child: AmountInput(
                autoFocus: false,
                initialValue: amount,
                isInflow: subTransaction.isInflow,
                onChanged: (value) {
                  onUpdated(subTransaction.copyWith(amount: value));
                },
                style: context.text.title.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.end,
              ),
            ),
            SizedBox(
              width: Sizes.unit * 3.5,
              height: Sizes.unit * 3.5,
              child: IconButton(
                onPressed: () {
                  onUpdated(subTransaction.copyWith(isInflow: !subTransaction.isInflow));
                },
                icon: subTransaction.isInflow
                    ? const Icon(Ionicons.add_circle_outline)
                    : const Icon(Ionicons.remove_circle_outline),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
