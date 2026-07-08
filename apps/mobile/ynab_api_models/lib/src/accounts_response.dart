import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'accounts_response.mapper.dart';

typedef LoanAccountPeriodicValues = Map<String, int>;

@MappableClass()
class AccountsResponse with AccountsResponseMappable {
  const AccountsResponse({required this.data});

  final Accounts data;
}

@MappableClass()
class Accounts with AccountsMappable {
  const Accounts({required this.serverKnowledge, required this.accounts});

  @MappableField(key: 'server_knowledge')
  final int serverKnowledge;
  final List<Account> accounts;
}

@MappableClass()
class Account extends Equatable with Searchable, AccountMappable {
  const Account({
    required this.id,
    required this.name,
    required this.isOnBudget,
    required this.isClosed,
    required this.isDeleted,
    required this.type,
    required this.balance,
    required this.debtInterestRates,
    required this.debtMinimumPayments,
    required this.debtEscrowAmounts,
  });

  final String id;
  final String name;
  @MappableField(key: 'on_budget')
  final bool isOnBudget;
  @MappableField(key: 'closed')
  final bool isClosed;
  @MappableField(key: 'deleted')
  final bool isDeleted;
  @MappableField(key: 'type')
  final AccountType type;
  final int balance;

  // Debt-specific fields
  @MappableField(key: 'debt_interest_rates')
  final LoanAccountPeriodicValues debtInterestRates;
  @MappableField(key: 'debt_minimum_payments')
  final LoanAccountPeriodicValues debtMinimumPayments;
  @MappableField(key: 'debt_escrow_amounts')
  final LoanAccountPeriodicValues debtEscrowAmounts;

  @override
  String get searchKey => name;

  @override
  List<Object?> get props => [id, name, isOnBudget, isClosed, type, balance];
}

@MappableEnum()
enum AccountType {
  checking,
  savings,
  cash,
  creditCard,
  lineOfCredit,
  otherAsset,
  otherLiability,
  mortgage,
  autoLoan,
  studentLoan,
  personalLoan,
  medicalDebt,
  otherDebt,
}
