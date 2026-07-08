import 'package:flutter/foundation.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../../../ynab_api/_account.dart';
import '../typedefs.dart';
import 'accounts_view.dart';

class AccountsRepository {
  AccountsRepository({
    required ValueGetter<Stream<Option<String>>> budgetId,
    required Stream<List<Account>> Function(String) accounts,
  }) : _accounts = accounts,
       _budgetId = budgetId {
    _streamFromDatabase();
  }

  factory AccountsRepository.create() {
    return AccountsRepository(
      budgetId: inject<Settings>().watchSelectedBudgetId,
      accounts: (bId) => inject<LocalDatabase>().watchAccounts(budgetId: bId),
    );
  }

  final ValueGetter<Stream<Option<String>>> _budgetId;
  final BudgetDataWatcher<List<Account>> _accounts;

  final _all = BehaviorSubject<List<Account>>();

  void _streamFromDatabase() {
    _budgetId()
        .switchMap((budgetId) {
          switch (budgetId) {
            case Some<String>(:final some):
              return _accounts(some);
            case None<String>():
              return Stream.value(List<Account>.empty());
          }
        })
        .listen(_all.add);
  }

  Stream<List<Account>> watch(AccountsView view) {
    return _all.map((allAccounts) {
      List<Account> onBudget(bool includeClosed) {
        final onBudget = allAccounts.whereOnBudget();
        return includeClosed
            ? onBudget
                  .toList() //
            : onBudget.whereOpen().toList();
      }

      return switch (view) {
        AllAccounts() => allAccounts,
        OnBudgetAccounts(:final includeClosed) => onBudget(includeClosed),
        OpenAccounts() => allAccounts.whereOpen().toList(),
        AccountsWithIds(:final accountIds) => allAccounts.select(accountIds),
        AccountsInFilter() => allAccounts.where(view.filter).toList(),
      };
    });
  }

  Future<void> dispose() async {
    await _all.close();
  }
}
