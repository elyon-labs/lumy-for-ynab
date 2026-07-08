import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/di.dart';
import '../../../common/presentation/badged.dart';
import '../../../common/presentation/design_system/app_screen.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../widgets/days_buffer_compare.dart';
import '../widgets/expense_compare.dart';
import '../widgets/expense_title.dart';
import '../widgets/expense_trend.dart';
import '../widgets/income_compare.dart';
import '../widgets/income_title.dart';
import '../widgets/income_trend.dart';
import '../widgets/savings_rate.dart';
import '../widgets/title.dart';
import '../widgets/top_movers.dart';
import 'choose_month_in_review_categories_screen.dart';

class MonthInReviewScreenState {
  MonthInReviewScreenState({required this.isFiltering});

  factory MonthInReviewScreenState.initial() {
    return MonthInReviewScreenState(isFiltering: false);
  }

  final bool isFiltering;
}

class MonthInReviewScreenCubit extends Cubit<MonthInReviewScreenState> {
  MonthInReviewScreenCubit({required this.settings}) : super(MonthInReviewScreenState.initial()) {
    fetch();
  }

  factory MonthInReviewScreenCubit.create() {
    return MonthInReviewScreenCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final categoryView = settings.watchMonthInReviewCategoryViewStream();
    final sub = categoryView.listen(
      (value) => safeEmit(MonthInReviewScreenState(isFiltering: value.isSome())),
    );
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class MonthInReviewScreen extends HookWidget {
  const MonthInReviewScreen({super.key});

  static String route = '/reports/month_in_review';

  @override
  Widget build(BuildContext context) {
    final month = useState(lastMonth);
    List<Widget> buildRows(bool shouldShowTopMovers) {
      return [
        const VSpace(space: Sizes.edgePadding),
        MonthInReviewTitle(month: month.value),
        IncomeTitle(month: month.value),
        IncomeCompare(month: month.value),
        const Divider(),
        IncomeTrend(month: month.value),
        const Divider(),
        ExpenseTitle(month: month.value),
        ExpenseCompare(month: month.value),
        if (shouldShowTopMovers) ...[const Divider(), const TopMovers()],
        const Divider(),
        ExpenseTrend(month: month.value),
        const Divider(),
        DaysBufferCompare(month: month.value),
        const Divider(),
        SavingsRateCompare(month: month.value),
        HStretch(
          child: PrimaryButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ),
        const SafeArea(child: VSpace(space: Sizes.edgePadding)),
      ];
    }

    return BlocProvider(
      create: (context) => MonthInReviewScreenCubit.create(),
      child: AppScreen(
        actions: [
          IconButton(
            onPressed: () async {
              GoRouter.of(context).go(ChooseMonthInReviewCategoriesScreen.route);
            },
            icon: BlocBuilder<MonthInReviewScreenCubit, MonthInReviewScreenState>(
              builder: (context, state) {
                return Badged(
                  showBadge: state.isFiltering,
                  child: const Icon(Ionicons.filter_circle_outline),
                );
              },
            ),
          ),
        ],
        child: HEdgePadding(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (context) => TopMoversCubit.create(month: month.value),
              child: BlocBuilder<TopMoversCubit, Async<TopMoversState>>(
                builder: (context, state) {
                  final shouldShowTopMovers = state
                      .valueOr(TopMoversState.empty())
                      .movements
                      .isNotEmpty;
                  return VLayout(spacing: Sizes.unit * 2, children: buildRows(shouldShowTopMovers));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
