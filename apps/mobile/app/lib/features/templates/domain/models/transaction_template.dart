import 'package:dart_mappable/dart_mappable.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import 'legacy_transaction_template.dart';
import 'transaction_template_draft.dart';

part 'transaction_template.mapper.dart';

@MappableClass()
class TransactionTemplate with TransactionTemplateMappable {
  TransactionTemplate({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.amount,
    required this.isInflow,
    required this.accountId,
    required this.payeeId,
    required this.categoryId,
    required this.memo,
    required this.flag,
    required this.subTransactions,
    required this.fireImmediately,
  });

  final String id;
  final String budgetId;
  final String name;
  final String? accountId;
  final int amount;
  final bool isInflow;
  final String? payeeId;
  final String? categoryId;
  final String? memo;
  final Flag? flag;
  final List<SubTransactionTemplate> subTransactions;
  final bool fireImmediately;
}

extension TransactionTemplateX on TransactionTemplate {
  bool get isSplit => categoryId == null && subTransactions.isNotEmpty;

  bool get isValid {
    return _hasValidSubTransactions;
  }

  bool get _hasValidSubTransactions {
    if (subTransactions.isEmpty) return true;
    if (subTransactions.any((s) => !s.isValid)) return false;
    final sumOfSubTransactions = subTransactions.fold(
      0,
      (sum, subTransaction) => sum + (subTransaction.canonicalAmount),
    );
    return sumOfSubTransactions == canonicalAmount;
  }

  bool get canCreateTransaction {
    return accountId != null;
  }

  int get canonicalAmount => isInflow ? amount.abs() : -amount.abs();

  TransactionTemplateDraft toTransactionTemplateDraft() {
    return TransactionTemplateDraft(
      id: id,
      name: name,
      accountId: accountId,
      amount: amount,
      payeeId: payeeId,
      categoryId: categoryId,
      memo: memo,
      flag: flag,
      subTransactions: subTransactions,
      fireImmediately: fireImmediately,
    );
  }
}

extension SubTransactionTemplateX on SubTransactionTemplate {
  bool get isValid {
    // For now, enforce nothing on subtransactions
    return true;
  }

  int get canonicalAmount => isInflow ? amount.abs() : -amount.abs();
}
