import 'package:ynab_api_models/ynab_api_models.dart';

extension IterableAccountX on Iterable<Account> {
  Iterable<Account> whereOnBudget() {
    return where((a) => a.isOnBudget);
  }

  Iterable<Account> whereOpen() {
    return where((a) => a.isOpen);
  }

  Iterable<Account> whereClosed() {
    return where((a) => a.isClosed);
  }

  Iterable<Account> whereIsAsset() {
    return where((a) => a.isAsset);
  }

  Iterable<Account> whereIsDebt() {
    return where((a) => a.isDebt);
  }

  int totalBalance() {
    return fold<int>(0, (total, account) => total + account.balance);
  }

  int totalAssets() {
    return whereIsAsset().totalBalance();
  }

  int totalDebts() {
    return whereIsDebt().totalBalance();
  }

  List<Account> select(Iterable<String> ids) {
    return where((a) => ids.contains(a.id)).toList();
  }

  List<String> get ids => map((a) => a.id).toList();
}

extension AccountX on Account {
  bool get isOpen => !isClosed;

  bool get isLiquidAccount => switch (type) {
    AccountType.checking => true,
    AccountType.savings => true,
    AccountType.cash => true,
    AccountType.creditCard => false,
    AccountType.lineOfCredit => false,
    AccountType.otherAsset => false,
    AccountType.otherLiability => false,
    AccountType.mortgage => false,
    AccountType.autoLoan => false,
    AccountType.studentLoan => false,
    AccountType.personalLoan => false,
    AccountType.medicalDebt => false,
    AccountType.otherDebt => false,
  };

  bool get isAsset => switch (type) {
    AccountType.checking => true,
    AccountType.savings => true,
    AccountType.cash => true,
    AccountType.otherAsset => true,
    AccountType.creditCard => false,
    AccountType.lineOfCredit => false,
    AccountType.otherLiability => false,
    AccountType.mortgage => false,
    AccountType.autoLoan => false,
    AccountType.studentLoan => false,
    AccountType.personalLoan => false,
    AccountType.medicalDebt => false,
    AccountType.otherDebt => false,
  };

  bool get isDebt => !isAsset;

  bool get isPayableDebt => isDebt && isOpen && balance.isNegative;
}
