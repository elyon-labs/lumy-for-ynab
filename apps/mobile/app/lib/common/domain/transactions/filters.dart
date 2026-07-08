import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../ynab_api/_base_transaction.dart';
import '../../../ynab_api/_category_group.dart';

typedef TransactionFilter =
    bool Function(
      // The transaction being evaluated
      BaseTransaction transaction,
      // The parent transaction if this is a subtransaction
      BaseTransaction? parent,
    );

/// A [TransactionFilter] that no-ops.
bool noFilter(BaseTransaction transaction, _) {
  return true;
}

/// A [TransactionFilter] that can be used to filter [BaseTransaction]s so
/// that those returned are considered "income". Income is a [BaseTransaction]
/// that is categorized as Ready to Assign and is not a starting balance.
bool isIncome(BaseTransaction transaction, _) {
  return transaction.isIncome;
}

/// A [TransactionFilter] that can be used to filter [BaseTransaction]s so
/// that those returned are considered "expenses". Expenses are [BaseTransaction]s
/// that are not Starting Balance transactions are not income (see above).
bool isExpense(BaseTransaction transaction, _) {
  return transaction.isExpense;
}

TransactionFilter isInCategoryGroup(CategoryGroup group) {
  return (transaction, _) {
    return transaction.categoryId != null && group.categoryIds.contains(transaction.categoryId);
  };
}

TransactionFilter isIncomeFromPayee(Option<Payee> payee) {
  return (transaction, parent) {
    if (!transaction.isIncome) {
      return false;
    }
    return transaction.hasPayeeId(payee.map((p) => p.id), parent: parent);
  };
}

TransactionFilter isExpenseFromPayee(Option<Payee> payee) {
  return (transaction, parent) {
    if (!transaction.isExpense) {
      return false;
    }
    return transaction.hasPayeeId(payee.map((p) => p.id), parent: parent);
  };
}

TransactionFilter isExpenseInCategory(Category category) {
  return (transaction, parent) {
    return isExpense(transaction, parent) && transaction.categoryId == category.id;
  };
}
