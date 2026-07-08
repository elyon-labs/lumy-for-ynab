import 'package:dart_mappable/dart_mappable.dart';

part 'transaction_template_from_backend.mapper.dart';

@MappableClass()
class TransactionTemplateFromBackend with TransactionTemplateFromBackendMappable {
  TransactionTemplateFromBackend({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.createdAt,
    required this.userId,
    required this.amount,
    required this.isInflow,
    this.accountId,
    this.payeeId,
    this.categoryId,
    this.memo,
    this.flag,
    required this.fireImmediately,
    required this.subTransactions,
  });

  final String id;
  final String budgetId;
  final String name;
  final DateTime createdAt;
  final String userId;
  final int amount;
  final bool isInflow;
  final String? accountId;
  final String? payeeId;
  final String? categoryId;
  final String? memo;
  final String? flag;
  final bool fireImmediately;
  final List<TransactionTemplateSubTransactionFromBackend> subTransactions;
}

@MappableClass()
class TransactionTemplateSubTransactionFromBackend
    with TransactionTemplateSubTransactionFromBackendMappable {
  TransactionTemplateSubTransactionFromBackend({
    required this.id,
    required this.createdAt,
    this.categoryId,
    required this.amount,
    required this.isInflow,
    this.payeeId,
    this.memo,
    this.templateId,
  });

  final String id;
  final DateTime createdAt;
  final String? categoryId;
  final int amount;
  final bool isInflow;
  final String? payeeId;
  final String? memo;
  final String? templateId;
}
