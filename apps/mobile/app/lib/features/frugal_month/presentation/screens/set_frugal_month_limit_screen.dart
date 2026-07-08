import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/domain/categories/categories_view.dart';
import '../../../../common/domain/transactions/filters.dart';
import '../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../common/domain/transactions/transactions_view.dart';
import '../../../../common/domain/worker/_base_transactions_async.dart';
import '../../../../common/domain/worker/_transactions_async.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../utils/_T.dart';
import '../../../../utils/_cubit.dart';
import '../../../../utils/_local_date.dart';
import '../../../../utils/sort.dart';
import '../../../templates/presentation/setup_template/screens/setup_template_screen/widgets/amount_input.dart';
import '../flows/create_frugal_month_flow.dart';

class SetFrugalMonthLimitScreenState {
  const SetFrugalMonthLimitScreenState({
    required this.enforceCurrentMonthLimit,
    required this.currentMonthSpend,
    required this.suggestedLimit,
    required this.showSuggestion,
  });

  factory SetFrugalMonthLimitScreenState.initial() {
    return const SetFrugalMonthLimitScreenState(
      enforceCurrentMonthLimit: false,
      currentMonthSpend: Loading(),
      suggestedLimit: Loading(),
      showSuggestion: false,
    );
  }

  final bool enforceCurrentMonthLimit;
  final Async<int> currentMonthSpend;
  final Async<int> suggestedLimit;
  final bool showSuggestion;
}

class SetFrugalMonthLimitScreenCubit extends Cubit<SetFrugalMonthLimitScreenState> {
  SetFrugalMonthLimitScreenCubit({
    required this.month,
    required this.accountIds,
    required this.categoryIds,
    required this.repo,
  }) : super(SetFrugalMonthLimitScreenState.initial()) {
    fetch();
  }

  factory SetFrugalMonthLimitScreenCubit.create({
    required LocalDate month,
    required List<String> accountIds,
    required List<String> categoryIds,
  }) {
    return SetFrugalMonthLimitScreenCubit(
      month: month,
      accountIds: accountIds,
      categoryIds: categoryIds,
      repo: inject(),
    );
  }

  final LocalDate month;
  final List<String> accountIds;
  final List<String> categoryIds;
  final TransactionsRepository repo;
  final subs = CompositeSubscription();

  void fetch() {
    final sub = repo
        .watch(
          TransactionsView(
            dateRange: const AllTime(),
            accounts: AccountsWithIds(accountIds),
            categories: CategoriesWithIds(categoryIds),
            filter: const ExpenseFilter(),
          ),
        )
        .flatMap((transactions) async* {
          final grouped = await transactions.groupByMonth(compare: dateAsc);
          final sums = await grouped.entries.mapAsync((ts) async {
            final sum = await ts.value.sumAmountFiltered(isExpense);
            return MapEntry(ts.key, sum);
          });
          final sumByMonth = Map.fromEntries(sums);
          final averageSpend = sumByMonth.values.takeLast(12).sum ~/ 12;
          final currentMonthTransactions = grouped[thisMonth] ?? [];
          final currentMonthSpend = await currentMonthTransactions.sumAmountFiltered(isExpense);
          yield (averageSpend, currentMonthSpend);
        })
        .listen((event) {
          final (averageSpend, currentMonthSpend) = event;
          // Suggest 90% of average spend
          final suggested = (averageSpend.abs() * 0.90).floor();

          final creatingForThisMonth = month.isSameMonthAs(thisMonth);

          final enforceCurrentMonthLimit = creatingForThisMonth;

          final showSuggestion = !creatingForThisMonth || suggested > currentMonthSpend;

          safeEmit(
            SetFrugalMonthLimitScreenState(
              enforceCurrentMonthLimit: enforceCurrentMonthLimit,
              currentMonthSpend: Loaded(currentMonthSpend),
              suggestedLimit: Loaded(suggested),
              showSuggestion: showSuggestion,
            ),
          );
        });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class SetFrugalMonthLimitScreen extends HookWidget {
  const SetFrugalMonthLimitScreen({super.key, required this.afterMonthChoice});
  final bool afterMonthChoice;

  static String buildRoute({required bool afterMonthChoice}) {
    return afterMonthChoice
        ? '/budget/choose_frugal_month/choose_categories/choose_accounts/set_target_amount' //
        : '/budget/choose_categories/choose_accounts/set_target_amount';
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final controller = useTextEditingController(text: 0.format(currencyFormat));
    final usedSuggestion = useState(false);

    return BlocProvider(
      create: (context) {
        final draft = context.read<CreateFrugalMonthFlow>().state.draft;
        return SetFrugalMonthLimitScreenCubit.create(
          month: draft.month ?? thisMonth,
          categoryIds: draft.categoryIds ?? [],
          accountIds: draft.accountIds ?? [],
        );
      },
      child: HookBuilder(
        builder: (context) {
          final updates = useListenable(controller);
          final milliunits = updates.text.toMilliUnits(currencyFormat);
          final inputIsValid = milliunits > 0;
          final formattedAmount = milliunits.format(currencyFormat);

          return BlocBuilder<SetFrugalMonthLimitScreenCubit, SetFrugalMonthLimitScreenState>(
            builder: (context, state) {
              final currentMonthSpend = state.currentMonthSpend.valueOr(0).abs();
              final showSuggestionButton =
                  state.suggestedLimit.isLoaded && state.showSuggestion && !usedSuggestion.value;

              // Limit is valid iff the actual *input* is valid and the limit is greather than
              // the existing current months's spend. If the frugal month is being created for
              // a future month, ignore the current month spend and just check the input.
              final limitIsValid =
                  inputIsValid &&
                  (!state.enforceCurrentMonthLimit || (milliunits > currentMonthSpend));

              final message = limitIsValid
                  ? 'Spend less than $formattedAmount'
                  : 'Must be more than current spend of ${currentMonthSpend.format(currencyFormat)}';

              return Scaffold(
                appBar: AppBar(title: const Text('Set target limit')),
                body: HEdgePadding(
                  child: VLayout(
                    spacing: 0,
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: HStretch(
                              child: VLayout(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AmountInput(
                                    showCursor: false,
                                    isInflow: true,
                                    controller: controller,
                                    disableScroll: true,
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      usedSuggestion.value = true;
                                      controller.text = state.suggestedLimit
                                          .valueOr(0)
                                          .abs()
                                          .format(currencyFormat);
                                    },
                                    child: Text(
                                      'Use suggested: ${state.suggestedLimit.valueOr(0).abs().format(currencyFormat)}',
                                      style: context.text.body,
                                    ),
                                  ).visible(showSuggestionButton, maintainSize: true),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      VLayout(
                        children: [
                          HStretch(
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: context.text.body.copyWith(
                                color: limitIsValid ? null : context.colors.error,
                              ),
                            ),
                          ).visible(inputIsValid, maintainSize: true),
                          VEdgePadding(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SafeArea(
                                child: PrimaryButton(
                                  onPressed: limitIsValid
                                      ? () async {
                                          final step = SetLimitStep(limit: milliunits);
                                          await context.read<CreateFrugalMonthFlow>().stepComplete(
                                            step,
                                          );
                                        }
                                      : null,
                                  child: const Text('Set limit'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
