import 'package:dart_mappable/dart_mappable.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../app/di.dart';
import '../../../../external/http_client.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_local_date.dart';
import '../../../../utils/typedefs.dart';
import '../../domain/models/legacy_transaction_template.dart';
import '../../domain/models/transaction_template.dart';

part 'create_transaction.mapper.dart';

class CreateTransactionService {
  CreateTransactionService({required HttpClient ynabClient, required Settings settings})
    : _ynabClient = ynabClient,
      _settings = settings;

  factory CreateTransactionService.create() {
    return CreateTransactionService(ynabClient: inject(ynabHttpClient), settings: inject());
  }

  final HttpClient _ynabClient;
  final Settings _settings;

  Future<Result<String, Exception>> create({required TransactionTemplate template}) async {
    if (!template.isValid) {
      return Err(Exception('Invalid transaction template'));
    }

    return await _settings.runIfBudgetIsSelected<Result<String, Exception>>((id) async {
      final response = await _ynabClient.execute<Json>(
        PostRequest(
          'budgets/$id/transactions',
          body: JsonRequestBody(template.toCreateTransaction().toMap()),
        ),
      );

      switch (response) {
        case SuccessResponse<Json>(:final response):
          if (response.statusCode == 201) {
            return const Ok('Transaction created');
          }
          return Err(
            Exception('Failed to create transaction, received status code ${response.statusCode}'),
          );
        case ErrorResponse<Json>(:final error):
          return Err(error);
      }
    }).flatten();
  }
}

extension on TransactionTemplate {
  CreateTransaction toCreateTransaction() {
    return CreateTransaction(
      transaction: TransactionToCreate(
        accountId: accountId!,
        amount: isInflow ? amount : -amount,
        payeeId: payeeId,
        categoryId: categoryId,
        memo: memo,
        flagColor: flag?.name,
        // We hard-code the values below (for now)
        date: today.yyyyMMddWithHyphens(),
        payeeName: null,
        cleared: null,
        approved: true,
        subtransactions: subTransactions.isNotEmpty
            ? subTransactions.map((e) => e.toSubTransactionToCreate()).toList()
            : null,
      ),
    );
  }
}

extension on SubTransactionTemplate {
  SubTransactionToCreate toSubTransactionToCreate() {
    return SubTransactionToCreate(
      amount: isInflow ? amount : -amount,
      categoryId: categoryId,
      memo: memo,
      cleared: null,
      approved: true,
    );
  }
}

@MappableClass()
class CreateTransaction with CreateTransactionMappable {
  CreateTransaction({required this.transaction});

  final TransactionToCreate transaction;
}

@MappableClass()
class TransactionToCreate with TransactionToCreateMappable {
  TransactionToCreate({
    required this.accountId,
    required this.date,
    required this.amount,
    required this.payeeId,
    required this.payeeName,
    required this.categoryId,
    required this.memo,
    required this.cleared,
    required this.approved,
    required this.flagColor,
    required this.subtransactions,
  });

  @MappableField(key: 'account_id')
  final String accountId;
  final String? date;
  final int amount;
  @MappableField(key: 'payee_id')
  final String? payeeId;
  @MappableField(key: 'payee_name')
  final String? payeeName;
  @MappableField(key: 'category_id')
  final String? categoryId;
  final String? memo;
  final bool? cleared;
  final bool? approved;
  @MappableField(key: 'flag_color')
  final String? flagColor;
  @MappableField(key: 'subtransactions')
  final List<SubTransactionToCreate>? subtransactions;
}

@MappableClass()
class SubTransactionToCreate with SubTransactionToCreateMappable {
  SubTransactionToCreate({
    required this.amount,
    required this.categoryId,
    required this.memo,
    required this.cleared,
    required this.approved,
  });

  final int amount;
  @MappableField(key: 'category_id')
  final String? categoryId;
  final String? memo;
  final bool? cleared;
  final bool? approved;
}
