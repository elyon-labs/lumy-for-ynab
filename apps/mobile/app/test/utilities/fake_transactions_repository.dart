import 'package:lumy/common/domain/transactions/transactions_repository.dart';
import 'package:lumy/common/domain/transactions/transactions_view.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

class FakeTransactionsRepository implements TransactionsRepository {
  FakeTransactionsRepository({this.transactions});

  final List<PastTransaction> Function(TransactionsView view)? transactions;

  @override
  Stream<List<PastTransaction>> watch(TransactionsView view) {
    return Stream.value(transactions?.call(view) ?? const []);
  }

  @override
  Future<void> dispose() async {
    // Do nothing.
  }
}
