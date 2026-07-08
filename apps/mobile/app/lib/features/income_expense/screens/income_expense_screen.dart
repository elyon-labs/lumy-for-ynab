import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/di.dart';
import '../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../common/domain/calculations/income_expense/fn.dart';
import '../../../common/presentation/_color.dart';
import '../../../common/presentation/_int.dart';
import '../../../common/presentation/badged.dart';
import '../../../common/presentation/bottom_sheet_with_header.dart';
import '../../../common/presentation/currency.dart';
import '../../../common/presentation/design_system/app_screen.dart';
import '../../../common/presentation/design_system/list_row.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../state/income_expense_report_cubit.dart';
import 'choose_income_expense_accounts_screen.dart';
import 'choose_income_expense_categories_screen.dart';
import 'expense_transactions_screen.dart';
import 'income_transactions_screen.dart';

class IncomeExpenseScreenState {
  IncomeExpenseScreenState({
    required this.isFiltering,
    required this.accounts,
    required this.categories,
  });

  factory IncomeExpenseScreenState.initial() {
    return IncomeExpenseScreenState(
      isFiltering: false,
      accounts: const None(),
      categories: const None(),
    );
  }

  final bool isFiltering;
  final Option<List<String>> accounts;
  final Option<String> categories;
}

class IncomeExpenseScreenCubit extends Cubit<IncomeExpenseScreenState> {
  IncomeExpenseScreenCubit({required this.settings}) : super(IncomeExpenseScreenState.initial()) {
    fetch();
  }

  factory IncomeExpenseScreenCubit.create() {
    return IncomeExpenseScreenCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final categorySetting = settings.watchIncomeExpenseCategoryView();
    final accountsSetting = settings.watchIncomeExpenseAccounts();
    final sub = Rx.combineLatest2(categorySetting, accountsSetting, (categories, accounts) {
      return IncomeExpenseScreenState(
        isFiltering: categories.isSome() || accounts.isSome(),
        accounts: accounts,
        categories: categories,
      );
    }).listen(safeEmit);
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class IncomeExpenseScreen extends StatelessWidget {
  const IncomeExpenseScreen({super.key});

  static String route = '/reports/income_expense';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncomeExpenseScreenCubit.create(),
      child: AppScreen(
        title: const Text('Income v Expense'),
        actions: [
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                showDragHandle: true,
                context: context,
                useRootNavigator: true,
                builder: (context) {
                  return const _ChooseAccountsOrCategoriesBottomSheet();
                },
              );
            },
            icon: BlocBuilder<IncomeExpenseScreenCubit, IncomeExpenseScreenState>(
              builder: (context, state) {
                return Badged(
                  showBadge: state.isFiltering,
                  child: const Icon(Ionicons.filter_circle_outline),
                );
              },
            ),
          ),
        ],
        child: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final data = context.watch<IncomeExpenseReportCubit>().state;
    return switch (data) {
      Loaded<IncomeExpenseData>(:final value) => _LoadedBody(data: value),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody({required this.data});

  final IncomeExpenseData data;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final monthData = data.monthData;
    return ListView.builder(
      itemCount: monthData.length,
      itemBuilder: (context, index) {
        final month = monthData.elementAt(index);
        final spend = month.summary.expense;
        final income = month.summary.income;
        final net = month.summary.net;

        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.unit * 2),
          child: VLayout(
            spacing: 0,
            children: [
              VEdgePadding(
                child: HEdgePadding(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: month.month.monthOfYear.toMonthName(),
                          style: context.text.title.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${month.month.year}',
                          style: context.text.title.copyWith(color: context.colors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              VLayout(
                spacing: 0,
                children: [
                  ListRow(
                    title: const Text('Income'),
                    leading: CircleAvatar(
                      radius: Sizes.unit * 2,
                      backgroundColor: context.colors.secondary,
                      child: Icon(
                        Ionicons.arrow_back_outline,
                        color: context.colors.onSecondary,
                        size: Sizes.unit * 2,
                      ),
                    ),
                    trailing: HLayout(
                      spacing: 0,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(income.format(currencyFormat), textAlign: TextAlign.end),
                        const HSpace(),
                        const Icon(
                          Ionicons.chevron_forward_outline,
                          size: Sizes.unit * 2.5,
                        ).opacity(0.25),
                      ],
                    ),
                    visualDensity: VisualDensity.compact,
                    onTap: () {
                      GoRouter.of(context).go(IncomeTransactionsScreen.buildRoute(month.month));
                    },
                  ),
                  ListRow(
                    title: const Text('Expense'),
                    leading: CircleAvatar(
                      radius: Sizes.unit * 2,
                      backgroundColor: context.colors.secondary,
                      child: Icon(
                        Ionicons.arrow_forward_outline,
                        color: context.colors.onSecondary,
                        size: Sizes.unit * 2,
                      ),
                    ),
                    trailing: HLayout(
                      spacing: 0,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(spend.format(currencyFormat), textAlign: TextAlign.end),
                        const HSpace(),
                        const Icon(
                          Ionicons.chevron_forward_outline,
                          size: Sizes.unit * 2.5,
                        ).opacity(0.25),
                      ],
                    ),
                    visualDensity: VisualDensity.compact,
                    onTap: () {
                      GoRouter.of(context).go(ExpenseTransactionsScreen.buildRoute(month.month));
                    },
                  ),
                  ListRow(
                    title: const Text('Net'),
                    leading: CircleAvatar(
                      radius: Sizes.unit * 2,
                      backgroundColor: context.colors.secondary,
                      child: Icon(
                        Ionicons.cash_outline,
                        color: context.colors.onSecondary,
                        size: Sizes.unit * 2,
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                    trailing: HLayout(
                      spacing: 0,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          net.format(currencyFormat),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: net.isNegative
                                ? Colors.red.blendedTo(context.colors.primary) //
                                : Colors.green.blendedTo(context.colors.primary),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const HSpace(),
                        const Icon(
                          Ionicons.chevron_forward_outline,
                          size: Sizes.unit * 2.5,
                        ).visible(false, maintainSize: true),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChooseAccountsOrCategoriesBottomSheet extends StatelessWidget {
  const _ChooseAccountsOrCategoriesBottomSheet();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncomeExpenseScreenCubit.create(),
      child: BlocBuilder<IncomeExpenseScreenCubit, IncomeExpenseScreenState>(
        builder: (context, state) {
          final isFiltering = state.isFiltering;
          return BottomSheetWithHeader(
            title: const Text('Filter report'),
            builder: (context) => SingleChildScrollView(
              padding: const EdgeInsets.only(top: Sizes.edgePadding / 2),
              child: VLayout(
                children: [
                  const VSpace(space: Sizes.unit * 2),
                  ListRow(
                    externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
                    trailing: Badged(
                      label: Text(state.accounts.mapOr((c) => c.length, 0).toString()),
                    ).visible(state.accounts.isSome()),
                    title: const Text('Choose accounts'),
                    onTap: () {
                      Navigator.of(context).pop();
                      GoRouter.of(context).go(ChooseIncomeExpenseAccountsScreen.route);
                    },
                  ),
                  ListRow(
                    externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
                    trailing: const Badged().visible(state.categories.isSome()),
                    title: const Text('Choose categories'),
                    onTap: () {
                      Navigator.of(context).pop();
                      GoRouter.of(context).go(ChooseIncomeExpenseCategoriesScreen.route);
                    },
                  ),
                  const VSpace(space: Sizes.unit * 2),
                  SafeArea(
                    child: HEdgePadding(
                      child: SecondaryButton(
                        onPressed: !isFiltering
                            ? null
                            : () async {
                                Navigator.of(context).pop();
                                await $settings().resetIncomeExpenseFilters();
                              },
                        child: const Text('Reset filters'),
                      ),
                    ),
                  ),
                  const VSpace(space: Sizes.unit * 2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
