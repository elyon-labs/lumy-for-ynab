import 'package:charlatan/charlatan.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/domain/transactions/transactions_fetch_cubit.dart';
import 'package:lumy/external/http_client.dart';
import 'package:lumy/persistence/drift/local_database.dart';
import 'package:lumy/persistence/settings.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../factory/transaction_factory.dart';
import '../../../utilities/fake_shared_preferences.dart';

void main() {
  group('TransactionsFetchCubit', () {
    const budgetId = 'budget-1';
    late LocalDatabase database;
    late Settings settings;

    setUp(() {
      database = LocalDatabase(NativeDatabase.memory());
      settings = Settings(FakeSharedPreferences({'selected_budget_id': budgetId}));
    });

    tearDown(() async {
      await database.close();
    });

    test('a missing knowledge token replaces the budget with a full snapshot', () async {
      await database.insertTransactions(
        [TransactionFactory.build(id: 'stale', isDeleted: false, subTransactions: [])],
        budgetId: budgetId,
        knowledge: 1,
      );
      await database.deleteTransactionKnowledges();

      CharlatanHttpRequest? capturedRequest;
      final charlatan = Charlatan()
        ..whenGet('/budgets/{id}/transactions', (request) {
          capturedRequest = request;
          return CharlatanHttpResponse(
            body: TransactionsResponse(
              data: Transactions(
                serverKnowledge: 42,
                transactions: [
                  TransactionFactory.build(id: 'canonical', isDeleted: false, subTransactions: []),
                  TransactionFactory.build(
                    id: 'pending',
                    isDeleted: false,
                    importId: 'YNAB:P:-1000:2026-01-01:1',
                    subTransactions: [],
                  ),
                ],
              ),
            ).toMap(),
          );
        });
      final cubit = _buildCubit(database: database, settings: settings, charlatan: charlatan);
      addTearDown(() async {
        await cubit.subs.clear();
        await cubit.close();
      });

      final result = await _waitForResult(cubit);

      expect(capturedRequest?.queryParameters, {'since_date': '1900-01-01'});
      expect(
        result.transactions,
        isA<Loaded<List<PastTransaction>>>(),
        reason: switch (result.transactions) {
          Error(:final error) => error.toString(),
          _ => null,
        },
      );
      expect(
        (result.transactions as Loaded<List<PastTransaction>>).value.map(
          (transaction) => transaction.id,
        ),
        unorderedEquals(['canonical', 'pending']),
      );
      expect(await database.getTransactionKnowledge(budgetId: budgetId), 42);
      final transactions = await database.watchTransactions(budgetId: budgetId).first;
      expect(
        transactions.map((transaction) => transaction.id),
        unorderedEquals(['canonical', 'pending']),
      );
    });

    test('an existing knowledge token applies a delta without replacing cached rows', () async {
      await database.insertTransactions(
        [TransactionFactory.build(id: 'cached', isDeleted: false, subTransactions: [])],
        budgetId: budgetId,
        knowledge: 7,
      );

      CharlatanHttpRequest? capturedRequest;
      final charlatan = Charlatan()
        ..whenGet('/budgets/{id}/transactions', (request) {
          capturedRequest = request;
          return CharlatanHttpResponse(
            body: TransactionsResponse(
              data: Transactions(
                serverKnowledge: 8,
                transactions: [
                  TransactionFactory.build(id: 'delta', isDeleted: false, subTransactions: []),
                ],
              ),
            ).toMap(),
          );
        });
      final cubit = _buildCubit(database: database, settings: settings, charlatan: charlatan);
      addTearDown(() async {
        await cubit.subs.clear();
        await cubit.close();
      });

      final result = await _waitForResult(cubit);

      expect(capturedRequest?.queryParameters, {'last_knowledge_of_server': 7});
      expect(
        result.transactions,
        isA<Loaded<List<PastTransaction>>>(),
        reason: switch (result.transactions) {
          Error(:final error) => error.toString(),
          _ => null,
        },
      );
      expect(
        (result.transactions as Loaded<List<PastTransaction>>).value.map(
          (transaction) => transaction.id,
        ),
        ['delta'],
      );
      expect(await database.getTransactionKnowledge(budgetId: budgetId), 8);
      final transactions = await database.watchTransactions(budgetId: budgetId).first;
      expect(
        transactions.map((transaction) => transaction.id),
        unorderedEquals(['cached', 'delta']),
      );
    });

    test('a failed full fetch preserves cached rows and leaves knowledge invalidated', () async {
      await database.insertTransactions(
        [TransactionFactory.build(id: 'cached', isDeleted: false, subTransactions: [])],
        budgetId: budgetId,
        knowledge: 1,
      );
      await database.deleteTransactionKnowledges();

      final charlatan = Charlatan()
        ..whenGet(
          '/budgets/{id}/transactions',
          (request) => CharlatanHttpResponse(statusCode: 500),
        );
      final cubit = _buildCubit(database: database, settings: settings, charlatan: charlatan);
      addTearDown(() async {
        await cubit.subs.clear();
        await cubit.close();
      });

      final result = await _waitForResult(cubit);

      expect(result.transactions, isA<Error<List<PastTransaction>>>());
      final transactions = await database.watchTransactions(budgetId: budgetId).first;
      expect(transactions.map((transaction) => transaction.id), ['cached']);
      expect(await database.getTransactionKnowledge(budgetId: budgetId), isNull);
    });
  });
}

TransactionsFetchCubit _buildCubit({
  required LocalDatabase database,
  required Settings settings,
  required Charlatan charlatan,
}) {
  return TransactionsFetchCubit(
    settings: settings,
    client: HttpClient(dio: Dio()..httpClientAdapter = charlatan.toFakeHttpClientAdapter()),
    database: database,
  );
}

Future<TransactionsFetchState> _waitForResult(TransactionsFetchCubit cubit) {
  return cubit.stream.firstWhere(
    (state) =>
        state.transactions is Loaded<List<PastTransaction>> ||
        state.transactions is Error<List<PastTransaction>>,
  );
}
