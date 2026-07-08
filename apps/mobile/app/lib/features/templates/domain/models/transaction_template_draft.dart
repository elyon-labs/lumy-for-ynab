import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import 'legacy_transaction_template.dart';
import 'transaction_template.dart';

part 'transaction_template_draft.mapper.dart';

@MappableClass()
class TransactionTemplateDraft with TransactionTemplateDraftMappable {
  TransactionTemplateDraft({
    String? id,
    this.amount = 0,
    this.isInflow = false,
    this.name,
    this.accountId,
    this.payeeId,
    this.categoryId,
    this.memo,
    this.flag,
    this.subTransactions = const [],
    this.fireImmediately = false,
  }) : id = id ?? const Uuid().v4();

  final String? name;
  final String id;
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

extension TransactionTemplateDraftX on TransactionTemplateDraft {
  bool get isSplit => categoryId == null && subTransactions.isNotEmpty;

  bool get isValid {
    return _hasValidSubTransactions;
  }

  bool get canSave {
    return name?.isNotEmpty ?? false;
  }

  bool get canCreateTransaction {
    return accountId != null && _hasValidSubTransactions;
  }

  bool get _hasValidSubTransactions {
    if (subTransactions.isEmpty) return true;
    if (subTransactions.any((s) => !s.isValid)) return false;
    final sumOfSubTransactions = subTransactions.fold(
      0,
      (sum, subTransaction) => sum + (subTransaction.amount),
    );
    return sumOfSubTransactions == amount;
  }

  LegacyTransactionTemplate toTransactionTemplate() {
    return LegacyTransactionTemplate(
      id: id,
      name: name!,
      accountId: accountId,
      amount: amount,
      isInflow: isInflow,
      payeeId: payeeId,
      categoryId: categoryId,
      memo: memo,
      flag: flag,
      subTransactions: subTransactions,
      fireImmediately: fireImmediately,
    );
  }
}
