import 'package:lumy/common/domain/accounts/accounts_repository.dart';
import 'package:lumy/common/domain/accounts/accounts_view.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

class FakeAccountsRepository implements AccountsRepository {
  FakeAccountsRepository({this.accounts});

  final List<Account> Function(AccountsView view)? accounts;

  @override
  Stream<List<Account>> watch(AccountsView view) {
    return Stream.value(accounts?.call(view) ?? const []);
  }

  @override
  Future<void> dispose() async {
    // Do nothing.
  }
}
