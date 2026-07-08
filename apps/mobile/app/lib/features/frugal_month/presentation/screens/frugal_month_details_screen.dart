import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../common/presentation/_int.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../../../common/presentation/design_system/section_body.dart';
import '../../../../common/presentation/design_system/section_header.dart';
import '../../../../utils/_cubit.dart';
import '../../domain/models/frugal_month_data.dart';
import '../../domain/use_cases/watch_frugal_month_data.dart';
import '../widgets/frugal_month_chart.dart';
import '../widgets/status_badge.dart';
import 'frugal_month_settings_screen.dart';
import 'frugal_month_transactions_screen.dart';

class FrugalMonthDetailsScreenState {
  FrugalMonthDetailsScreenState({
    required this.frugalMonthId,
    required this.data,
    required this.currencyFormat,
  });

  factory FrugalMonthDetailsScreenState.initial({required String frugalMonthId}) {
    return FrugalMonthDetailsScreenState(
      frugalMonthId: frugalMonthId,
      data: const Loading(),
      currencyFormat: const None(),
    );
  }

  final String frugalMonthId;
  final Async<FrugalMonthData> data;
  final Option<CurrencyFormat> currencyFormat;
}

class FrugalMonthDetailsScreenCubit extends Cubit<FrugalMonthDetailsScreenState> {
  FrugalMonthDetailsScreenCubit({
    required String frugalMonthId,
    required BudgetsRepository budgetsRepository,
    required WatchFrugalMonthData watchFrugalMonthData,
  }) : _budgetsRepository = budgetsRepository,
       _watchFrugalMonthData = watchFrugalMonthData,
       _frugalMonthId = frugalMonthId,
       super(FrugalMonthDetailsScreenState.initial(frugalMonthId: frugalMonthId)) {
    fetch();
  }

  factory FrugalMonthDetailsScreenCubit.create(String frugalMonthId) {
    return FrugalMonthDetailsScreenCubit(
      frugalMonthId: frugalMonthId,
      budgetsRepository: inject(),
      watchFrugalMonthData: WatchFrugalMonthData.create(),
    );
  }

  final String _frugalMonthId;
  final WatchFrugalMonthData _watchFrugalMonthData;
  final BudgetsRepository _budgetsRepository;
  final subs = CompositeSubscription();

  void fetch() {
    final sub =
        Rx.combineLatest2(
          _watchFrugalMonthData(_frugalMonthId),
          _budgetsRepository.watchCurrencyFormat(),
          (a, b) => (a, b),
        ).listen((event) {
          final (frugalMonthData, currencyFormat) = event;
          safeEmit(
            FrugalMonthDetailsScreenState(
              frugalMonthId: _frugalMonthId,
              data: Loaded(frugalMonthData),
              currencyFormat: currencyFormat,
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

class FrugalMonthDetailsScreen extends StatelessWidget {
  const FrugalMonthDetailsScreen({super.key, required this.id});
  final String id;

  static String buildBudgetTabRoute(String id) {
    return '/budget/frugal_month/$id';
  }

  static String buildSettingsTabRoute(String id) {
    return '/settings/past_frugal_months/$id';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FrugalMonthDetailsScreenCubit.create(id),
      child: BlocBuilder<FrugalMonthDetailsScreenCubit, FrugalMonthDetailsScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: switch (state.data) {
                Loaded(:final value) => [
                  IconButton(
                    icon: const Icon(Ionicons.cog_outline),
                    onPressed: () {
                      GoRouter.of(context).go(FrugalMonthSettingsScreen.buildRoute(value.month.id));
                    },
                  ),
                ],
                _ => [],
              },
              title: switch (state.data) {
                Loaded(:final value) => Text(
                  'Frugal ${value.month.month.monthOfYear.toMonthName()}',
                ),
                Error() => const Text('Error'),
                _ => const Text('Loading'),
              },
            ),
            body: const _Body(),
          );
        },
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FrugalMonthDetailsScreenCubit, FrugalMonthDetailsScreenState>(
      builder: (context, state) {
        return switch (state.data) {
          Loaded(:final value) => _LoadedBody(value: value, currencyFormat: state.currencyFormat),
          Error() => const Center(child: Text('Error')),
          _ => const Center(child: CircularProgressIndicator.adaptive()),
        };
      },
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.value, required this.currencyFormat});

  final FrugalMonthData value;
  final Option<CurrencyFormat> currencyFormat;

  @override
  Widget build(BuildContext context) {
    final chart = FrugalMonthChart(frugalMonth: value);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
          child: VLayout(
            spacing: Sizes.unit * 2,
            children: [
              chart,
              VLayout(
                spacing: 0,
                children: [
                  const VEdgePadding(child: HEdgePadding(child: SectionHeader('Setup'))),
                  ListSection(
                    children: [
                      ListRow(
                        title: const Text('Limit'),
                        leading: CircleAvatar(
                          radius: Sizes.unit * 2,
                          backgroundColor: context.colors.secondary,
                          child: Icon(
                            Ionicons.remove_outline,
                            color: context.colors.onSecondary,
                            size: Sizes.unit * 2,
                          ),
                        ),
                        trailing: Text(value.month.targetAmount.format(currencyFormat)),
                      ),
                    ],
                  ),
                ],
              ),
              VLayout(
                spacing: 0,
                children: [
                  const VEdgePadding(child: HEdgePadding(child: SectionHeader('Progress'))),
                  VLayout(
                    children: [
                      ListRow(
                        title: const Text('Status'),
                        leading: CircleAvatar(
                          radius: Sizes.unit * 2,
                          backgroundColor: context.colors.secondary,
                          child: Icon(
                            Ionicons.speedometer_outline,
                            color: context.colors.onSecondary,
                            size: Sizes.unit * 2,
                          ),
                        ),
                        trailing: StatusBadge(status: value.status),
                      ),
                      ListRow(
                        title: const Text('Total spent'),
                        leading: CircleAvatar(
                          radius: Sizes.unit * 2,
                          backgroundColor: context.colors.secondary,
                          child: Icon(
                            Ionicons.arrow_forward_outline,
                            color: context.colors.onSecondary,
                            size: Sizes.unit * 2,
                          ),
                        ),
                        trailing: Text(value.totalSpent.format(currencyFormat)),
                      ),
                      ListRow(
                        title: const Text('Left to spend'),
                        leading: CircleAvatar(
                          radius: Sizes.unit * 2,
                          backgroundColor: context.colors.secondary,
                          child: Icon(
                            Ionicons.cash_outline,
                            color: context.colors.onSecondary,
                            size: Sizes.unit * 2,
                          ),
                        ),
                        trailing: Text(value.leftToSpend.format(currencyFormat)),
                      ),
                      ListRow(
                        title: const Text('Net income'),
                        leading: CircleAvatar(
                          radius: Sizes.unit * 2,
                          backgroundColor: context.colors.secondary,
                          child: Icon(
                            Ionicons.arrow_back_outline,
                            color: context.colors.onSecondary,
                            size: Sizes.unit * 2,
                          ),
                        ),
                        trailing: Text(value.netIncome.format(currencyFormat)),
                      ),
                      ListRow(
                        title: const Text('% of limit spent'),
                        leading: CircleAvatar(
                          radius: Sizes.unit * 2,
                          backgroundColor: context.colors.secondary,
                          child: Icon(
                            Ionicons.card_outline,
                            color: context.colors.onSecondary,
                            size: Sizes.unit * 2,
                          ),
                        ),
                        trailing: Text('${value.percentageSpent.toStringAsFixed(2)}%'),
                      ),
                      ListRow(
                        title: const Text('% of month passed'),
                        leading: CircleAvatar(
                          radius: Sizes.unit * 2,
                          backgroundColor: context.colors.secondary,
                          child: Icon(
                            Ionicons.calendar_number_outline,
                            color: context.colors.onSecondary,
                            size: Sizes.unit * 2,
                          ),
                        ),
                        trailing: Text('${value.percentOfMonthPassed.toStringAsFixed(2)}%'),
                      ),
                      if (value.hasTransactions)
                        ListRow(
                          title: const Text('See transactions'),
                          leading: CircleAvatar(
                            radius: Sizes.unit * 2,
                            backgroundColor: context.colors.secondary,
                            child: Icon(
                              Ionicons.receipt_outline,
                              color: context.colors.onSecondary,
                              size: Sizes.unit * 2,
                            ),
                          ),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) =>
                                    FrugalMonthTransactionsScreen(transactions: value.transactions),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
