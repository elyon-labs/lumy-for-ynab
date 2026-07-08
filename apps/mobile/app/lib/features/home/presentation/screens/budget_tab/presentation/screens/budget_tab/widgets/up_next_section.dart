import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../../utils/_local_date.dart';
import '../../../../../../../../frugal_month/domain/models/frugal_month.dart';
import '../../../../../../../../frugal_month/domain/use_cases/watch_can_create_frugal_month.dart';
import '../../../../../../../../frugal_month/presentation/screens/frugal_month_details_screen.dart';
import '../../../../../../../../frugal_month/presentation/widgets/frugal_month_row.dart';
import '../../../../../../../../frugal_month/presentation/widgets/start_frugal_month_row.dart';

class UpNextSectionState {
  UpNextSectionState({
    required this.canCreateFrugalMonthForThisMonth,
    required this.canCreateFrugalMonthForNextMonth,
  });

  factory UpNextSectionState.initial() {
    return UpNextSectionState(
      canCreateFrugalMonthForNextMonth: false,
      canCreateFrugalMonthForThisMonth: false,
    );
  }

  final bool canCreateFrugalMonthForThisMonth;
  final bool canCreateFrugalMonthForNextMonth;
}

class UpNextSectionCubit extends Cubit<UpNextSectionState> {
  UpNextSectionCubit({required WatchCanCreateFrugalMonth watchCanCreateFrugalMonth})
    : _watchCanCreateFrugalMonth = watchCanCreateFrugalMonth,
      super(UpNextSectionState.initial()) {
    fetch();
  }

  factory UpNextSectionCubit.create() {
    return UpNextSectionCubit(watchCanCreateFrugalMonth: WatchCanCreateFrugalMonth.create());
  }

  final WatchCanCreateFrugalMonth _watchCanCreateFrugalMonth;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub =
        Rx.combineLatest2(
          _watchCanCreateFrugalMonth(thisMonth),
          _watchCanCreateFrugalMonth(nextMonth),
          (a, b) => (a, b),
        ).listen((event) {
          final (canCreateThisMonth, canCreateNextMonth) = event;
          safeEmit(
            UpNextSectionState(
              canCreateFrugalMonthForThisMonth: canCreateThisMonth,
              canCreateFrugalMonthForNextMonth: canCreateNextMonth,
            ),
          );
        });
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.cancel();
    return super.close();
  }
}

class UpNextSection extends HookWidget {
  const UpNextSection(this.frugalMonth, {super.key});

  final FrugalMonth? frugalMonth;

  @override
  Widget build(BuildContext context) {
    return HEdgePadding(
      child: BlocBuilder<UpNextSectionCubit, UpNextSectionState>(
        builder: (context, state) {
          return VLayout(
            children: [
              ListSection(
                children: [
                  if (state.canCreateFrugalMonthForThisMonth ||
                      state.canCreateFrugalMonthForNextMonth) ...[
                    const StartFrugalMonthRow(),
                  ],
                  if (frugalMonth != null) ...[
                    Card(
                      child: FrugalMonthRow(
                        frugalMonth: frugalMonth!,
                        onTap: () {
                          GoRouter.of(
                            context,
                          ).go(FrugalMonthDetailsScreen.buildBudgetTabRoute(frugalMonth!.id));
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
