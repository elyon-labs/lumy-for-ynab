import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../../../../../../app/di.dart';
import '../../../../../../../../../common/domain/accounts/accounts_view.dart';
import '../../../../../../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../../../../../../common/domain/calculations/spent_this_month.dart/fn.dart';
import '../../../../../../../../../common/domain/categories/categories_view.dart';
import '../../../../../../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../../../../../../common/domain/transactions/transactions_view.dart';
import '../../../../../../../../../common/presentation/_color.dart';
import '../../../../../../../../../common/presentation/charts/chart_constants.dart';
import '../../../../../../../../../common/presentation/currency.dart';
import '../../../../../../../../../common/presentation/design_system/_build_context.dart';
import '../../../../../../../../../common/presentation/design_system/section_header.dart';
import '../../../../../../../../../persistence/settings.dart';
import '../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../../utils/_local_date.dart';
import '../../../../../../../../charts/templates/cartesian_chart_template.dart';
import '../../../../../../../../charts/templates/formatters.dart';
import '../../../../../../../../charts/widgets/custom_tooltip.dart';
import '../../../../../../../../charts/widgets/tooltip_row.dart';
import '../../../../../../../../charts/widgets/visual_card.dart';

class SpentThisMonthSectionState extends Equatable {
  const SpentThisMonthSectionState({
    required this.isLoading,
    required this.thisMonth,
    required this.lastMonth,
  });

  factory SpentThisMonthSectionState.initial() {
    return const SpentThisMonthSectionState(isLoading: true, thisMonth: {}, lastMonth: {});
  }

  final bool isLoading;
  final Map<LocalDate, int?> thisMonth;
  final Map<LocalDate, int?> lastMonth;

  @override
  List<Object?> get props => [isLoading, thisMonth, lastMonth];
}

class SpentThisMonthCubit extends Cubit<SpentThisMonthSectionState> {
  SpentThisMonthCubit({
    required TransactionsRepository transactionsRepo,
    required Settings settings,
  }) : _transactionsRepository = transactionsRepo,
       _settings = settings,
       super(SpentThisMonthSectionState.initial()) {
    unawaited(_fetch());
  }

  factory SpentThisMonthCubit.create() {
    return SpentThisMonthCubit(transactionsRepo: inject(), settings: inject());
  }

  final TransactionsRepository _transactionsRepository;
  final Settings _settings;
  final _subs = CompositeSubscription();

  Future<void> _fetch() async {
    final categoryViewStream = _settings.watchBudgetTabCategoryView();
    final sub = categoryViewStream
        .switchMap((categoryViewId) async* {
          final categoryView = categoryViewId.mapOr(
            CategoriesInView.new,
            const ExpenseCategories(),
          );
          yield* _transactionsRepository.watch(
            TransactionsView(
              debugId: 'spent_this_month',
              dateRange: SpecificDateRange((from: lastMonth.firstDayOfMonth(), to: today)),
              accounts: const AllAccounts(),
              categories: categoryView,
              filter: const ExpenseFilter(),
            ),
          );
        })
        .listen((transactions) async {
          final state = SpentThisMonthSectionState(
            isLoading: false,
            thisMonth: await calculateSpentThisMonth(transactions: transactions, month: today),
            lastMonth: await calculateSpentThisMonth(transactions: transactions, month: lastMonth),
          );

          safeEmit(state);
        });
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}

class SpentThisMonthSection extends HookWidget {
  const SpentThisMonthSection({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();

    Widget subTitle(MapEntry<LocalDate, int?>? today) {
      return Text(((today?.value ?? 0) * -1).format(currencyFormat), style: context.text.headline);
    }

    return HEdgePadding(
      child: BlocBuilder<SpentThisMonthCubit, SpentThisMonthSectionState>(
        builder: (context, state) {
          return VisualCard(
            title: const SectionHeader('Spent this month'),
            subtitle: Skeletonizer(
              enabled: state.isLoading,
              child: Builder(
                builder: (context) {
                  final thisMonthSpend = state.thisMonth.entries.singleWhereOrNull(
                    (entry) => entry.key.isToday(),
                  );
                  return subTitle(thisMonthSpend);
                },
              ),
            ),
            child: HEdgePadding(
              child: Skeletonizer(
                enabled: state.isLoading,
                child: Builder(
                  builder: (_) {
                    final thisMonthSpend = state.thisMonth;
                    final lastMonthSpend = state.lastMonth;
                    final thisMonthSource = thisMonthSpend.entries.toList();
                    final lastMonthSource = lastMonthSpend.entries.toList();
                    return CartesianChart(
                      showYAxis: false,
                      xAxisLabelFormatter: MonthXAxisFormatter(
                        context,
                        thisMonthSource.length > lastMonthSource.length
                            ? thisMonthSource
                            : lastMonthSource,
                      ),
                      onMarkerRender: (args) {
                        final isToday = args.pointIndex == today.dayOfMonth - 1;
                        args.color = isToday ? context.colors.primary : Colors.transparent;
                      },
                      trackballBuilder: (context, details) {
                        final info = details.groupingModeInfo;
                        final index = info!.currentPointIndices.first;
                        final thisMonth = thisMonthSource.elementAtOrNull(index);
                        final lastMonth = lastMonthSource.elementAtOrNull(index);
                        final thisMonthAmount = (thisMonth ?? thisMonthSource.last).value;
                        final lastMonthAmount = (lastMonth ?? lastMonthSource.last).value;
                        return CustomTooltip(
                          child: VLayout(
                            spacing: 0,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (lastMonthAmount != null)
                                TooltipRow(
                                  color: context.bespokeColors.chartCompare,
                                  text: 'Last month: ${lastMonthAmount.format(currencyFormat)}',
                                ),
                              if (thisMonthAmount != null)
                                TooltipRow(
                                  color: context.colors.primary,
                                  text: 'This month: ${thisMonthAmount.format(currencyFormat)}',
                                ),
                            ],
                          ),
                        );
                      },
                      yAxisLabelFormatter: CurrencyYAxisFormatter(context),
                      series: [
                        SplineSeries<MapEntry<int, int?>, int>(
                          name: 'Last month',
                          animationDuration: kChartAnimationDurationMs,
                          splineType: SplineType.monotonic,
                          color: context.bespokeColors.chartCompare,
                          dataSource: lastMonthSource.mapKeys((key) => key.dayOfMonth),
                          xValueMapper: (entry, _) => entry.key,
                          yValueMapper: (entry, _) =>
                              entry.value == null ? null : entry.value! * -1,
                          width: 3,
                          dashArray: const [5, 5],
                          legendIconType: LegendIconType.circle,
                        ),
                        SplineAreaSeries<MapEntry<int, int?>, int>(
                          name: 'This month',
                          splineType: SplineType.monotonic,
                          color: context.colors.primary,
                          dataSource: thisMonthSource.mapKeys((key) => key.dayOfMonth),
                          xValueMapper: (entry, _) => entry.key,
                          yValueMapper: (entry, _) =>
                              entry.value == null ? null : entry.value! * -1,
                          borderColor: context.colors.primary,
                          borderWidth: 3,
                          animationDuration: kChartAnimationDurationMs,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [context.colors.primary.withAlphaOf(0.05), context.colors.card],
                          ),
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            width: Sizes.unit * 1.25,
                            height: Sizes.unit * 1.25,
                            borderWidth: 0,
                          ),
                          legendIconType: LegendIconType.circle,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
