import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../app/firebase/feature_flags/feature_flags_cubit.dart';
import '../../../../../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../../../../../common/presentation/design_system/_build_context.dart';
import '../../../../../../../../common/presentation/design_system/app_screen.dart';
import '../../../../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../../../../persistence/settings.dart';
import '../../../../../../../../utils/_build_context.dart';
import '../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../utils/_local_date.dart';
import '../../../../../../../../ynab_api/_budget.dart';
import '../../../../../../../chart_details/presentation/screens/chart_details_screen/chart_details_screen.dart';
import '../../../../../../../charts/models/chart.dart';
import '../../../../../../../charts/widgets/chart_holder.dart';
import '../../../../../../../income_expense/widgets/income_expense_tile.dart';
import '../../../../../../../recurring_transactions/recurring_transactions_tile.dart';
import '../../../../../../../spend_tracker/domain/models/spend_tracker.dart';
import '../../../../../../../spend_tracker/domain/use_cases/watch_all_spend_trackers.dart';
import '../../../../../../../spend_tracker/presentation/flows/create_spend_tracker/state/create_spend_tracker_cubit.dart';
import '../../../../../../../spend_tracker/presentation/widgets/add_first_spend_tracker_row.dart';
import '../../../../../../../spend_tracker/presentation/widgets/spend_tracker_row.dart';
import '../../../../budget_tab/presentation/screens/budget_tab/widgets/month_in_review_tile.dart';
import 'widgets/choose_timeframe_button.dart';
import 'widgets/dynamic_height_gridview.dart';
import 'widgets/reports_tab_category_view_button/reports_tab_category_view_button.dart';

class ReportsTabState extends Equatable {
  const ReportsTabState({
    required this.spendTrackers,
    required this.selectedCharts,
    required this.shouldShowMonthInReviewSection,
    required this.isLoading,
  });

  factory ReportsTabState.initial() {
    return const ReportsTabState(
      spendTrackers: [],
      selectedCharts: [],
      shouldShowMonthInReviewSection: false,
      isLoading: true,
    );
  }

  final List<SpendTracker> spendTrackers;
  final List<Chart> selectedCharts;
  final bool shouldShowMonthInReviewSection;
  final bool isLoading;

  @override
  List<Object?> get props => [
    spendTrackers,
    selectedCharts,
    shouldShowMonthInReviewSection,
    isLoading,
  ];
}

class ReportsTabCubit extends Cubit<ReportsTabState> {
  ReportsTabCubit({
    required WatchAllSpendTrackers watchAllSpendTrackers,
    required BudgetsRepository budgetsRepository,
    required Settings settings,
  }) : _settings = settings,
       _budgetsRepository = budgetsRepository,
       _watchAllSpendTrackers = watchAllSpendTrackers,
       super(ReportsTabState.initial()) {
    fetch();
  }

  factory ReportsTabCubit.create() {
    return ReportsTabCubit(
      budgetsRepository: inject(),
      settings: inject(),
      watchAllSpendTrackers: WatchAllSpendTrackers.create(),
    );
  }

  final WatchAllSpendTrackers _watchAllSpendTrackers;
  final BudgetsRepository _budgetsRepository;
  final Settings _settings;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub =
        Rx.combineLatest3(
          _watchAllSpendTrackers(),
          _budgetsRepository.watchSelected(),
          _settings.watchSelectedCharts(),
          (a, b, c) => (a, b, c),
        ).listen((event) {
          final (spendTrackers, selectedBudget, selectedCharts) = event;
          final shouldShowMonthInReview = selectedBudget.mapOr(
            (budget) =>
                budget.firstMonthDate != null && //
                (budget.firstMonthDate!.isSameMonthAs(today.firstDayOfMonth().subtractMonths(2)) ||
                    (budget.firstMonthDate!.isBefore(today.firstDayOfMonth().subtractMonths(2)))),
            false,
          );
          safeEmit(
            ReportsTabState(
              spendTrackers: spendTrackers,
              selectedCharts: selectedCharts,
              shouldShowMonthInReviewSection: shouldShowMonthInReview,
              isLoading: false,
            ),
          );
        });
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}

class ReportsTab extends StatelessWidget {
  const ReportsTab({super.key});

  static String route = '/reports';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsTabCubit.create(),
      child: AppScreen(
        title: context.isDesktop ? const Text('Reports') : null,
        backgroundColor: context.bespokeColors.bodyVariant,
        child: BlocBuilder<ReportsTabCubit, ReportsTabState>(
          builder: (context, state) {
            final rows = [
              const VSpace(space: Sizes.edgePadding),
              const _FilterSection(),
              const VSpace(space: Sizes.unit * 2),
              const _SpendTrackersSection(),
              const VSpace(space: Sizes.unit * 2),
              const _GeneralReportsSection(),
              const VSpace(space: Sizes.unit * 2),
            ];

            return CustomScrollView(
              slivers: [
                if (!context.isDesktop)
                  SliverAppBar(
                    backgroundColor: context.bespokeColors.bodyVariant,
                    automaticallyImplyLeading: false,
                    title: const Text('Reports'),
                    centerTitle: false,
                    titleTextStyle: context.text.headline.copyWith(fontWeight: FontWeight.bold),
                    pinned: true,
                  ),
                SliverList(delegate: SliverChildListDelegate(rows)),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
                  sliver: _ChartsSection(),
                ),
                const SliverVSpace(space: Sizes.edgePadding),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection();

  @override
  Widget build(BuildContext context) {
    return const HEdgePadding(
      padding: Sizes.edgePadding * 1.25,
      child: HLayout(
        children: [
          Expanded(child: ChooseTimeframeButton()),
          Expanded(child: ReportsTabCategoryViewButton()),
        ],
      ),
    );
  }
}

class _SpendTrackersSection extends StatelessWidget {
  const _SpendTrackersSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsTabCubit, ReportsTabState>(
      builder: (context, state) {
        return HEdgePadding(
          child: Card(
            child: VLayout(
              spacing: 0,
              children: [
                ListSection(
                  children: [
                    if (state.spendTrackers.isEmpty) const AddFirstSpendTrackerRow(),
                    ...[
                      for (final spendTracker in state.spendTrackers)
                        SpendTrackerRow(spendTracker: spendTracker),
                    ],
                  ],
                ),
                if (state.spendTrackers.isNotEmpty) ...[
                  const VSpace(space: Sizes.unit),
                  HEdgePadding(
                    child: SecondaryButton(
                      child: const Text('Add tracker'),
                      onPressed: () {
                        final route = context.read<CreateSpendTrackerCubit>().initializeFlow();
                        GoRouter.of(context).go(route);
                      },
                    ),
                  ),
                  const VSpace(space: Sizes.edgePadding),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GeneralReportsSection extends HookWidget {
  const _GeneralReportsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsTabCubit, ReportsTabState>(
      builder: (context, state) {
        return HEdgePadding(
          child: Card(
            child: ListSection(
              children: [
                const IncomeExpenseTile(),
                if (state.shouldShowMonthInReviewSection) MonthInReviewTile(month: lastMonth),
                const RecurringTransactionsTile(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChartsSection extends HookWidget {
  const _ChartsSection();

  @override
  Widget build(BuildContext context) {
    final featureFlags = useFeatureFlags();
    return BlocBuilder<ReportsTabCubit, ReportsTabState>(
      builder: (context, state) {
        final charts = state.selectedCharts
            .where((c) => c.isEnabled(featureFlags))
            .map(ChartRow.new)
            .toList();
        return SliverDynamicHeightGridView(
          mainAxisSpacing: Sizes.unit * 2,
          builder: (context, index) => charts[index],
          itemCount: charts.length,
          crossAxisCount: context.whenPortrait((p0) => 1, orElse: (_) => 2),
        );
      },
    );
  }
}

class ChartRow extends StatelessWidget {
  const ChartRow(this.chart, {super.key});

  final Chart chart;

  @override
  Widget build(BuildContext context) {
    return ChartHolder(
      chart: chart,
      onDetailsTapped: () => GoRouter.of(context).go(ChartDetailsScreen.buildRoute(chart.id)),
    );
  }
}
