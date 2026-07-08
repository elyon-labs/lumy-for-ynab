import 'package:dart_mappable/dart_mappable.dart';

part 'insert_transaction_template.mapper.dart';

@MappableClass()
class InsertTransactionTemplate with InsertTransactionTemplateMappable {
  InsertTransactionTemplate({
    required this.budgetId,
    required this.userId,
    required this.name,
    required this.amount,
    required this.isInflow,
    required this.accountId,
    required this.payeeId,
    required this.categoryId,
    required this.memo,
    required this.flag,
    required this.fireImmediately,
  });

  final String budgetId;
  final String userId;
  final String name;
  final int amount;
  final bool isInflow;
  final String? accountId;
  final String? payeeId;
  final String? categoryId;
  final String? memo;
  final String? flag;
  final bool fireImmediately;
}

@MappableClass()
class UpdateTransactionTemplate with UpdateTransactionTemplateMappable {
  UpdateTransactionTemplate({
    required this.name,
    required this.amount,
    required this.isInflow,
    required this.accountId,
    required this.payeeId,
    required this.categoryId,
    required this.memo,
    required this.flag,
    required this.fireImmediately,
  });

  final String name;
  final int amount;
  final bool isInflow;
  final String? accountId;
  final String? payeeId;
  final String? categoryId;
  final String? memo;
  final String? flag;
  final bool fireImmediately;
}

@MappableClass()
class InsertTransactionTemplateSubTransaction with InsertTransactionTemplateSubTransactionMappable {
  InsertTransactionTemplateSubTransaction({
    required this.templateId,
    required this.categoryId,
    required this.amount,
    required this.isInflow,
    required this.payeeId,
    required this.memo,
  });

  final String templateId;
  final String? categoryId;
  final int amount;
  final bool isInflow;
  final String? payeeId;
  final String? memo;
}
