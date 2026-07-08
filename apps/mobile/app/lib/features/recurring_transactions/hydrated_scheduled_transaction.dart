import 'package:dart_mappable/dart_mappable.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

part 'hydrated_scheduled_transaction.mapper.dart';

@MappableClass()
class HydratedScheduledTransaction extends ScheduledTransaction
    with HydratedScheduledTransactionMappable {
  HydratedScheduledTransaction({
    required super.id,
    required super.payeeId,
    required super.amount,
    required super.categoryId,
    required super.memo,
    required super.transferAccountId,
    required super.isDeleted,
    required super.dateFirst,
    required super.dateNext,
    required super.frequency,
    required super.flagColor,
    required super.flagName,
    required super.accountId,
    required super.accountName,
    required super.payeeName,
    required super.categoryName,
    required super.subTransactions,
  });
}

@MappableClass()
class HydratedScheduledSubTransaction extends ScheduledSubTransaction
    with HydratedScheduledSubTransactionMappable {
  const HydratedScheduledSubTransaction({
    required super.id,
    required super.payeeId,
    required super.amount,
    required super.categoryId,
    required super.memo,
    required super.transferAccountId,
    required super.isDeleted,
    required super.scheduledTransactionId,
    required this.categoryName,
    required this.payeeName,
  });

  final String? categoryName;
  final String? payeeName;
}

extension HydratedScheduledTransactionX on Iterable<ScheduledTransaction> {
  /// Converts a list of [ScheduledTransaction] to a list of [HydratedScheduledTransaction].
  ///
  /// This is necessary because the API for [ScheduledTransaction]s does not return
  /// `payeeName` and `categoryName` fields, which are necessary for displaying
  /// the payee and category names in the UI as well as determining whether a [ScheduledTransaction]
  /// is income or expense.
  Iterable<HydratedScheduledTransaction> toHydratedScheduledTransactions({
    required Map<String, Payee> payeesMap,
    required Map<String, Category> categoriesMap,
  }) {
    return map((t) {
      return HydratedScheduledTransaction(
        id: t.id,
        payeeId: t.payeeId,
        amount: t.amount,
        categoryId: t.categoryId,
        memo: t.memo,
        transferAccountId: t.transferAccountId,
        isDeleted: t.isDeleted,
        dateFirst: t.dateFirst,
        dateNext: t.dateNext,
        frequency: t.frequency,
        flagColor: t.flagColor,
        flagName: t.flagName,
        accountId: t.accountId,
        accountName: t.accountName,
        payeeName: t.payeeName,
        categoryName: t.categoryName,
        subTransactions: t.subTransactions.map((st) {
          return st.toHydratedScheduledSubTransactions(
            payeeName: st.payeeId != null ? payeesMap[st.payeeId]?.name : null,
            categoryName: st.categoryId != null ? categoriesMap[st.categoryId]?.name : null,
          );
        }).toList(),
      );
    });
  }
}

extension ListHydratedScheduledSubTransactionX on ScheduledSubTransaction {
  HydratedScheduledSubTransaction toHydratedScheduledSubTransactions({
    required String? payeeName,
    required String? categoryName,
  }) {
    return HydratedScheduledSubTransaction(
      id: id,
      payeeId: payeeId,
      amount: amount,
      categoryId: categoryId,
      memo: memo,
      transferAccountId: transferAccountId,
      isDeleted: isDeleted,
      scheduledTransactionId: scheduledTransactionId,
      categoryName: categoryName,
      payeeName: payeeName,
    );
  }
}
