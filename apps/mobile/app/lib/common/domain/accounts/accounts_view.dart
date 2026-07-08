import 'package:equatable/equatable.dart';
import 'filters.dart';

sealed class AccountsView extends Equatable {
  const AccountsView();
}

class AllAccounts extends AccountsView {
  const AllAccounts();

  @override
  List<Object?> get props => [];
}

class OnBudgetAccounts extends AccountsView {
  const OnBudgetAccounts({this.includeClosed = true});

  final bool includeClosed;

  @override
  List<Object?> get props => [includeClosed];
}

class OpenAccounts extends AccountsView {
  const OpenAccounts();

  @override
  List<Object?> get props => [];
}

class AccountsWithIds extends AccountsView {
  const AccountsWithIds(this.accountIds);

  final List<String> accountIds;

  @override
  List<Object?> get props => [accountIds];
}

class AccountsInFilter extends AccountsView {
  const AccountsInFilter(this.filter);

  final AccountFilter filter;

  @override
  List<Object?> get props => [filter];
}
