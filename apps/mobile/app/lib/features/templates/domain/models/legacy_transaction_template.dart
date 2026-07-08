import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

part 'legacy_transaction_template.mapper.dart';

@MappableClass()
class LegacyTransactionTemplate with LegacyTransactionTemplateMappable {
  // ignore: deprecated_consistency
  LegacyTransactionTemplate({
    required this.name,
    String? id,
    this.amount = 0,
    this.isInflow = false,
    this.accountId,
    this.payeeId,
    this.categoryId,
    this.memo,
    this.flag,
    this.subTransactions = const [],
    this.fireImmediately = false,
  }) : id = id ?? const Uuid().v4();

  final String name;
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

@MappableClass()
class SubTransactionTemplate with SubTransactionTemplateMappable {
  SubTransactionTemplate({
    String? id,
    this.categoryId,
    this.amount = 0,
    this.isInflow = false,
    this.payeeId,
    this.memo,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String? categoryId;
  final int amount;
  final bool isInflow;
  final String? payeeId;
  final String? memo;
}
