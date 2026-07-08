import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/domain/worker/worker.dart';
import 'package:lumy/features/charts/spend_by_category/state/spend_by_category_chart_data_cubit.dart';

import '../../factory/category_factory.dart';
import '../../factory/category_group_factory.dart';
import '../../factory/transaction_factory.dart';

void main() {
  test('spend by category calculator runs on background worker', () async {
    const categoryId = 'category-id';
    const categoryGroupId = 'category-group-id';
    final category = CategoryFactory.build(id: categoryId, categoryGroupId: categoryGroupId);
    final categoryGroup = CategoryGroupFactory.build(id: categoryGroupId, categories: [category]);
    final transaction = TransactionFactory.build(
      amount: -1000,
      categoryId: categoryId,
      subTransactions: const [],
    );

    final result = await calculateSpendByCategoryInWorker(
      worker: Worker.on(IsolateType.background),
      transactions: [transaction],
      categories: [category],
      categoryGroups: [categoryGroup],
    );

    expect(result.totalSpend, -1000);
  });
}
