import 'package:charlatan/charlatan.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

Charlatan charlatanWithDefaults() {
  return Charlatan()
    ..whenGet(
      '/budgets/{id}/categories',
      (request) => CharlatanHttpResponse(
        body: const CategoriesResponse(data: Categories(categoryGroups: [], serverKnowledge: 1)),
      ),
    )
    ..whenGet('/budgets/{id}/transactions', (request) {
      return CharlatanHttpResponse(
        body: const TransactionsResponse(data: Transactions(serverKnowledge: 1, transactions: [])),
      );
    })
    ..whenGet('/budgets/{id}/accounts', (request) {
      return CharlatanHttpResponse(
        body: const AccountsResponse(data: Accounts(serverKnowledge: 1, accounts: [])),
      );
    })
    ..whenGet('/budgets/{id}/payees', (request) {
      return CharlatanHttpResponse(
        body: const PayeesResponse(data: Payees(serverKnowledge: 1, payees: [])),
      );
    })
    ..whenGet('/user', (request) {
      return CharlatanHttpResponse(
        body: const UserResponse(
          data: UserData(user: User(id: 'id')),
        ),
      );
    })
    ..whenGet('/budgets', (request) {
      return CharlatanHttpResponse(
        body: const BudgetsResponse(data: Budgets(budgets: [])),
      );
    });
}
