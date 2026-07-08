import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'transactions_response.mapper.dart';

@MappableClass()
class TransactionsResponse with TransactionsResponseMappable {
  const TransactionsResponse({required this.data});

  final Transactions data;
}

@MappableClass()
class Transactions with TransactionsMappable {
  const Transactions({required this.serverKnowledge, required this.transactions});

  @MappableField(key: 'server_knowledge')
  final int serverKnowledge;
  final List<PastTransaction> transactions;
}

sealed class BaseTransaction extends Equatable {
  const BaseTransaction({
    required this.id,
    required this.payeeId,
    required this.amount,
    required this.categoryId,
    required this.memo,
    required this.transferAccountId,
    required this.isDeleted,
  });

  final String id;

  @MappableField(key: 'payee_id')
  final String? payeeId;

  final int amount;

  @MappableField(key: 'category_id')
  final String? categoryId;

  final String? memo;

  @MappableField(key: 'transfer_account_id')
  final String? transferAccountId;

  @MappableField(key: 'deleted')
  final bool isDeleted;
}

sealed class BasePastTransaction extends BaseTransaction {
  const BasePastTransaction({
    required super.id,
    required super.payeeId,
    required super.amount,
    required super.categoryId,
    required super.memo,
    required super.transferAccountId,
    required super.isDeleted,
    required this.payeeName,
    required this.categoryName,
    required this.transferTransactionId,
  });

  @MappableField(key: 'payee_name')
  final String? payeeName;

  @MappableField(key: 'category_name')
  final String? categoryName;

  final String? transferTransactionId;
}

@MappableClass()
class PastTransaction extends BasePastTransaction with PastTransactionMappable {
  PastTransaction({
    required super.id,
    required super.payeeId,
    required super.amount,
    required super.categoryId,
    required super.memo,
    required super.transferAccountId,
    required super.isDeleted,
    required super.payeeName,
    required super.categoryName,
    required super.transferTransactionId,
    required this.date,
    required this.accountId,
    required this.matchedTransactionId,
    required this.importId,
    required this.flagColor,
    required this.subTransactions,
  });

  final String date;
  @MappableField(key: 'account_id')
  final String accountId;
  @MappableField(key: 'matched_transaction_id')
  final String? matchedTransactionId;
  @MappableField(key: 'import_id')
  final String? importId;
  @MappableField(key: 'flag_color')
  final String? flagColor;
  @MappableField(key: 'subtransactions')
  final List<SubTransaction> subTransactions;

  @override
  List<Object?> get props => [
    super.id,
    super.payeeName,
    super.payeeId,
    date,
    super.amount,
    accountId,
    super.categoryId,
    super.categoryName,
    super.memo,
    super.transferAccountId,
    super.transferTransactionId,
    matchedTransactionId,
    importId,
    super.isDeleted,
    flagColor,
    subTransactions,
  ];
}

@MappableClass()
class SubTransaction extends BasePastTransaction with SubTransactionMappable {
  const SubTransaction({
    required this.transactionId,
    required super.id,
    required super.payeeName,
    required super.payeeId,
    required super.amount,
    required super.categoryId,
    required super.categoryName,
    required super.memo,
    required super.transferAccountId,
    required super.transferTransactionId,
    required super.isDeleted,
  });

  @MappableField(key: 'transaction_id')
  final String transactionId;

  @override
  List<Object?> get props => [
    transactionId,
    super.id,
    super.payeeName,
    super.payeeId,
    super.amount,
    super.categoryId,
    super.categoryName,
    super.memo,
    super.transferAccountId,
    super.transferTransactionId,
    super.isDeleted,
  ];
}

@MappableClass()
class ScheduledTransaction extends BaseTransaction with ScheduledTransactionMappable {
  const ScheduledTransaction({
    required super.id,
    required super.payeeId,
    required super.amount,
    required super.categoryId,
    required super.memo,
    required super.transferAccountId,
    required super.isDeleted,
    required this.dateFirst,
    required this.dateNext,
    required this.frequency,
    required this.flagColor,
    required this.flagName,
    required this.accountId,
    required this.accountName,
    required this.payeeName,
    required this.categoryName,
    required this.subTransactions,
  });

  @MappableField(key: 'date_first')
  final String dateFirst;
  @MappableField(key: 'date_next')
  final String dateNext;
  final ScheduledTransactionFrequency frequency;
  @MappableField(key: 'flag_color')
  final String? flagColor;
  @MappableField(key: 'flag_name')
  final String? flagName;
  @MappableField(key: 'account_id')
  final String accountId;
  @MappableField(key: 'account_name')
  final String accountName;
  @MappableField(key: 'payee_name')
  final String? payeeName;
  @MappableField(key: 'category_name')
  final String? categoryName;
  @MappableField(key: 'subtransactions')
  final List<ScheduledSubTransaction> subTransactions;

  @override
  List<Object?> get props => [
    id,
    payeeId,
    amount,
    categoryId,
    memo,
    transferAccountId,
    isDeleted,
    dateFirst,
    dateNext,
    frequency,
    flagColor,
    flagName,
    accountId,
    accountName,
    payeeName,
    categoryName,
    subTransactions,
  ];
}

@MappableClass()
class ScheduledSubTransaction extends BaseTransaction with ScheduledSubTransactionMappable {
  const ScheduledSubTransaction({
    required super.id,
    required super.payeeId,
    required super.amount,
    required super.categoryId,
    required super.memo,
    required super.transferAccountId,
    required super.isDeleted,
    required this.scheduledTransactionId,
  });

  @MappableField(key: 'scheduled_transaction_id')
  final String scheduledTransactionId;

  @override
  List<Object?> get props => [
    id,
    payeeId,
    amount,
    categoryId,
    memo,
    transferAccountId,
    isDeleted,
    scheduledTransactionId,
  ];
}

@MappableEnum()
enum ScheduledTransactionFrequency {
  never,
  daily, // * 365
  weekly, // * 52
  everyOtherWeek, // * 26
  twiceAMonth, // * 24
  every4Weeks, // * 13
  monthly, // * 12
  everyOtherMonth, // * 6
  every3Months, // * 4
  every4Months, // * 3
  twiceAYear, // * 2
  yearly, // * 1
  everyOtherYear, // * 0.5
}
