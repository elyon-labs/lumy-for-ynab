import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../../../app/di.dart';
import '../../../../../../../../../common/domain/accounts/accounts_view.dart';
import '../../../../../../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../../../../../../common/domain/categories/categories_view.dart';
import '../../../../../../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../../../../../../common/domain/transactions/transactions_view.dart';
import '../../../../../../../../../common/domain/worker/_transactions_async.dart';
import '../../../../../../../../../common/presentation/_int.dart';
import '../../../../../../../../../common/presentation/bottom_sheet_with_header.dart';
import '../../../../../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../../../../../common/presentation/design_system/section_header.dart';
import '../../../../../../../../../common/presentation/transactions/date_header.dart';
import '../../../../../../../../../common/presentation/transactions/transaction_list.dart';
import '../../../../../../../../../common/presentation/transactions/transaction_row.dart';
import '../../../../../../../../../persistence/settings.dart';
import '../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../../utils/_local_date.dart';
import '../../../../../../../../../utils/sort.dart';
import '../../../../../../../../charts/widgets/visual_card.dart';

class LatestTransactionsSectionState {
  LatestTransactionsSectionState({
    required this.transactions,
    required this.grouped,
    required this.currencyFormat,
    required this.showViewAllButton,
    required this.isLoading,
  });

  factory LatestTransactionsSectionState.initial() {
    return LatestTransactionsSectionState(
      transactions: [],
      grouped: {},
      currencyFormat: const None(),
      showViewAllButton: false,
      isLoading: true,
    );
  }

  final List<PastTransaction> transactions;
  final Map<LocalDate, List<PastTransaction>> grouped;
  final Option<CurrencyFormat> currencyFormat;
  final bool showViewAllButton;
  final bool isLoading;
}

class LatestTransactionsSectionCubit extends Cubit<LatestTransactionsSectionState> {
  LatestTransactionsSectionCubit({
    required this.transactionsRepo,
    required this.budgetsRepo,
    required this.settings,
  }) : super(LatestTransactionsSectionState.initial()) {
    fetch();
  }

  factory LatestTransactionsSectionCubit.create() {
    return LatestTransactionsSectionCubit(
      transactionsRepo: inject(),
      budgetsRepo: inject(),
      settings: inject(),
    );
  }

  final TransactionsRepository transactionsRepo;
  final BudgetsRepository budgetsRepo;
  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final range = SpecificDateRange((from: today.firstDayOfMonth(), to: today));
    final sub = settings
        .watchBudgetTabCategoryView()
        .switchMap((viewId) async* {
          final categoryView = viewId.mapOr(CategoriesInView.new, const ExpenseCategories());
          final transactions = transactionsRepo.watch(
            TransactionsView(
              dateRange: range,
              accounts: const AllAccounts(),
              categories: categoryView,
              filter: const ExpenseFilter(),
            ),
          );
          yield* Rx.combineLatest2(
            transactions,
            budgetsRepo.watchCurrencyFormat(),
            (a, b) => (a, b),
          );
        })
        .switchMap((event) async* {
          final (transactions, currencyFormat) = event;
          final grouped = await transactions.groupByDate(dateDesc);
          yield LatestTransactionsSectionState(
            transactions: transactions,
            grouped: grouped,
            currencyFormat: currencyFormat,
            showViewAllButton: transactions.length > 3,
            isLoading: false,
          );
        })
        .listen(safeEmit);
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 200, child: Center(child: child));
  }
}

class LatestTransactionsSection extends HookWidget {
  const LatestTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HEdgePadding(
      child: BlocBuilder<LatestTransactionsSectionCubit, LatestTransactionsSectionState>(
        builder: (context, state) {
          final children = state.isLoading
              ? [const _EmptyBody(child: CircularProgressIndicator.adaptive())]
              : state.transactions.isEmpty
              ? [
                  const _EmptyBody(
                    child: Text(
                      'None yet.\nGo spend on the things you love!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
              : [
                  for (final txn in state.transactions.take(3)) TransactionRow(transaction: txn),
                  if (state.showViewAllButton) ...[
                    Padding(
                      padding: const EdgeInsets.all(Sizes.edgePadding),
                      child: SecondaryButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            showDragHandle: true,
                            isScrollControlled: true,
                            context: context,
                            useRootNavigator: true,
                            builder: (context) {
                              return DraggableScrollableSheet(
                                expand: false,
                                maxChildSize: 0.90,
                                builder: (context, controller) {
                                  return BottomSheetWithHeader(
                                    title: Text('${today.monthOfYear.toMonthName()} transactions'),
                                    builder: (context) {
                                      return Expanded(
                                        child: TransactionsList(
                                          transactions: state.grouped,
                                          headerBuilder: (v) => DateHeader(date: v),
                                          controller: controller,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: const Text('View all'),
                      ),
                    ),
                  ],
                ];

          return VisualCard(
            title: const SectionHeader('Latest Transactions'),
            child: VLayout(children: [ListSection(children: children)]),
          );
        },
      ),
    );
  }
}
