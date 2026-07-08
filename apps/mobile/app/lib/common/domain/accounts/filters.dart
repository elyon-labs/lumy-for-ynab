import 'package:ynab_api_models/ynab_api_models.dart';

typedef AccountFilter = bool Function(Account account);

bool isOnBudgetAccount(Account account) => account.isOnBudget;

bool includeAccount(Account account) => true;
