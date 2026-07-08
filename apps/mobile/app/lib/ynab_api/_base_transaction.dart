import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../features/recurring_transactions/hydrated_scheduled_transaction.dart';
import '../utils/_T.dart';

extension BaseTransactionX on BaseTransaction {
  bool get isSplit =>
      this is PastTransaction && (this as PastTransaction).subTransactions.isNotEmpty;

  bool get isInflow => amount > 0;

  // Don't include split transactions since they don't have a category.
  bool get isIncome => !isSplit && isCategorizedReadyToAssign && !isStartingBalance;

  bool get isOutflow => amount < 0;

  bool get isTransfer => transferAccountId != null;

  // Don't include split transactions since they don't have a category.
  bool get isExpense => !isSplit && categoryId != null && !(isIncome || isStartingBalance);

  ScheduledTransactionFrequency? get frequency {
    return switch (this) {
      ScheduledTransaction(:final frequency) => frequency,
      _ => null,
    };
  }

  bool get isCategorizedReadyToAssign {
    final categoryName = switch (this) {
      ScheduledTransaction(:final categoryName) => categoryName,
      ScheduledSubTransaction() => () {
        if (this is HydratedScheduledSubTransaction) {
          return (this as HydratedScheduledSubTransaction).categoryName;
        }
        return null;
      }(),
      PastTransaction(:final categoryName) => categoryName,
      SubTransaction(:final categoryName) => categoryName,
    };

    return categoryName == 'Inflow: Ready to Assign';
  }

  bool get isStartingBalance {
    final payeeName = switch (this) {
      ScheduledTransaction(:final payeeName) => payeeName,
      ScheduledSubTransaction() => () {
        if (this is HydratedScheduledSubTransaction) {
          return (this as HydratedScheduledSubTransaction).payeeName;
        }
        return null;
      }(),
      PastTransaction(:final payeeName) => payeeName,
      SubTransaction(:final payeeName) => payeeName,
    };

    return !isSplit && payeeName == 'Starting Balance';
  }

  bool hasAccountId(String accountId, {BaseTransaction? parent}) {
    final parentAccountId = switch (parent) {
      ScheduledTransaction(:final accountId) => accountId,
      PastTransaction(:final accountId) => accountId,
      _ => null,
    };
    final thisAccountId = switch (this) {
      ScheduledTransaction(:final accountId) => accountId,
      PastTransaction(:final accountId) => accountId,
      _ => null,
    };
    return (thisAccountId == accountId) || (parent != null && parentAccountId == accountId);
  }

  bool hasPayeeId(Option<String> payeeId, {BaseTransaction? parent}) {
    if (parent == null && isSplit) {
      // Use sub-transactions to evaluate payee matches.
      return false;
    }

    if (parent != null && (this.payeeId == null || this.payeeId == parent.payeeId)) {
      // Defer to the parent's payee id if this is a subtransaction
      // that has no explicit payee id.
      return parent.payeeId == payeeId.mapOr((p) => p, null);
    } else {
      // If a different payee id is set than that of the parent,
      // we will use the payee id of the transaction itself.
      return this.payeeId == payeeId.mapOr((p) => p, null);
    }
  }

  Iterable<String> get categoryIds {
    return switch (this) {
      PastTransaction(:final subTransactions) => {
        categoryId,
        ...subTransactions.map((e) => e.categoryIds).flattenSafe(),
      }.nonNulls,
      SubTransaction() => {categoryId}.nonNulls,
      ScheduledTransaction(:final subTransactions) => {
        categoryId,
        ...subTransactions.map((e) => e.categoryIds).flattenSafe(),
      }.nonNulls,
      // TODO: Handle this case.
      ScheduledSubTransaction() => {categoryId}.nonNulls,
    };
  }

  Iterable<String> get payeeIds {
    return switch (this) {
      PastTransaction(:final subTransactions) => {
        payeeId,
        ...subTransactions.map((e) => e.payeeIds).flattenSafe(),
      }.nonNulls,
      SubTransaction() => {payeeId}.nonNulls,
      ScheduledTransaction(:final subTransactions) => {
        payeeId,
        ...subTransactions.map((e) => e.payeeIds).flattenSafe(),
      }.nonNulls,
      // TODO: Handle this case.
      ScheduledSubTransaction() => {payeeId}.nonNulls,
    };
  }
}
