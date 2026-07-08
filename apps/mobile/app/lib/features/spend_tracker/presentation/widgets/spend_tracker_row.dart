import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../../../utils/_cubit.dart';
import '../../../home/presentation/screens/reports_tab/presentation/screens/reports_spend_tracker_details_screen.dart';
import '../../domain/models/spend_tracker.dart';
import '../../domain/models/spend_tracker_data.dart';
import '../../domain/use_cases/watch_spend_tracker_data.dart';

class SpendTrackerRowState {
  SpendTrackerRowState({
    required this.spendTracker,
    required this.currencyFormat,
    required this.spendTrackerData,
  });

  factory SpendTrackerRowState.initial({required SpendTracker spendTracker}) {
    return SpendTrackerRowState(
      spendTracker: spendTracker,
      currencyFormat: const None(),
      spendTrackerData: const Loading(),
    );
  }

  final SpendTracker spendTracker;
  final Option<CurrencyFormat> currencyFormat;
  final Async<SpendTrackerData> spendTrackerData;
}

class SpendTrackerRowCubit extends Cubit<SpendTrackerRowState> {
  SpendTrackerRowCubit({
    required SpendTracker spendTracker,
    required WatchSpendTrackerData watchSpendTrackerData,
    required this.budgetsRepository,
  }) : _spendTracker = spendTracker,
       _watchSpendTrackerData = watchSpendTrackerData,
       super(SpendTrackerRowState.initial(spendTracker: spendTracker)) {
    fetch();
  }

  factory SpendTrackerRowCubit.create({required SpendTracker spendTracker}) {
    return SpendTrackerRowCubit(
      spendTracker: spendTracker,
      watchSpendTrackerData: WatchSpendTrackerData.create(),
      budgetsRepository: inject(),
    );
  }

  final SpendTracker _spendTracker;
  final WatchSpendTrackerData _watchSpendTrackerData;
  final BudgetsRepository budgetsRepository;
  final subs = CompositeSubscription();

  void fetch() {
    final sub = Rx.combineLatest2(
      budgetsRepository.watchCurrencyFormat(),
      _watchSpendTrackerData(_spendTracker.id),
      (currencyFormat, spendTrackerData) {
        return SpendTrackerRowState(
          spendTracker: _spendTracker,
          currencyFormat: currencyFormat,
          spendTrackerData: Loaded(spendTrackerData),
        );
      },
    ).listen(safeEmit);
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class SpendTrackerRow extends StatelessWidget {
  const SpendTrackerRow({super.key, required this.spendTracker});

  final SpendTracker spendTracker;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(spendTracker.id),
      create: (context) => SpendTrackerRowCubit.create(spendTracker: spendTracker),
      child: BlocBuilder<SpendTrackerRowCubit, SpendTrackerRowState>(
        builder: (context, state) {
          return ListRow(
            title: Text(spendTracker.preferredName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                switch (state.spendTrackerData) {
                  Loaded<SpendTrackerData>(:final value) => Text(
                    value.netTotal.format(state.currencyFormat),
                    style: context.text.title,
                  ),
                  _ => const Skeletonizer(child: Text('Loading...')),
                },
                const HSpace(),
                const Icon(Ionicons.chevron_forward_outline, size: Sizes.unit * 2.5).opacity(0.25),
              ],
            ),
            onTap: () => GoRouter.of(
              context,
            ).go(ReportsSpendTrackerDetailsScreen.buildRoute(spendTrackerId: spendTracker.id)),
          );
        },
      ),
    );
  }
}
