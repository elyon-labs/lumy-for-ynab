import 'package:equatable/equatable.dart';

import '../../../features/date_range/domain/models/date_range.dart';
import '../accounts/accounts_view.dart';
import '../categories/categories_view.dart';
import 'filters.dart';

/// {@template txn_view}
/// Represents a view of transactions. Essentially this provides a contract
/// by which to query transactions from a source.
///
/// [DateRange] is the range of dates to query transactions for (inclusive).
/// [AccountsView] is the accounts to query transactions for.
/// [CategoriesView] is the categories to query transactions for.
/// [FilterReq] is the filter to apply to the transactions. This filters sub-transactions
/// out from under parent transactions.
/// {@endtemplate}
class TransactionsView extends Equatable {
  /// {@macro txn_view}
  const TransactionsView({
    required this.dateRange,
    required this.accounts,
    required this.categories,
    required this.filter,
    this.debugId,
  });

  factory TransactionsView.all() {
    return const TransactionsView(
      dateRange: AllTime(),
      accounts: AllAccounts(),
      categories: AllCategories(),
      filter: NoFilter(),
    );
  }

  final DateRangeReq dateRange;
  final AccountsView accounts;
  final CategoriesView categories;
  final FilterReq filter;
  final String? debugId;

  @override
  List<Object?> get props => [accounts, dateRange, categories, filter];
}

sealed class FilterReq extends Equatable {
  const FilterReq(this.filter);

  final TransactionFilter filter;

  @override
  List<Object?> get props => [filter];
}

class NoFilter extends FilterReq {
  const NoFilter() : super(noFilter);
}

class ExpenseFilter extends FilterReq {
  const ExpenseFilter() : super(isExpense);
}

class CustomFilter extends FilterReq {
  const CustomFilter(super.filter);
}

sealed class DateRangeReq extends Equatable {
  const DateRangeReq();
}

class AllTime extends DateRangeReq {
  const AllTime();

  @override
  List<Object?> get props => [];
}

class SelectedDateRange extends DateRangeReq {
  const SelectedDateRange();

  @override
  List<Object?> get props => [];
}

class SpecificDateRange extends DateRangeReq {
  const SpecificDateRange(this.dateRange);

  final DateRange dateRange;

  @override
  List<Object?> get props => [dateRange];
}
