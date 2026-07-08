import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../app/di.dart';
import '../../../../common/presentation/_int.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../domain/use_cases/watch_available_frugal_months.dart';
import '../navigation/frugal_month_navigation.dart';
import '../screens/frugal_month_splash_screen.dart';

class StartFrugalMonthRowState {
  StartFrugalMonthRowState({
    required this.availableMonths,
    required this.hasSeenFrugalMonthsSplash,
  });

  factory StartFrugalMonthRowState.initial() {
    return StartFrugalMonthRowState(
      availableMonths: List.empty(),
      hasSeenFrugalMonthsSplash: false,
    );
  }

  final List<LocalDate> availableMonths;
  final bool hasSeenFrugalMonthsSplash;
}

class StartFrugalMonthRowCubit extends Cubit<StartFrugalMonthRowState> {
  StartFrugalMonthRowCubit({
    required Settings settings,
    required WatchAvailableFrugalMonths watchAvailableFrugalMonths,
  }) : _settings = settings,
       _watchAvailableFrugalMonths = watchAvailableFrugalMonths,
       super(StartFrugalMonthRowState.initial()) {
    fetch();
  }

  factory StartFrugalMonthRowCubit.create() {
    return StartFrugalMonthRowCubit(
      settings: inject(),
      watchAvailableFrugalMonths: WatchAvailableFrugalMonths.create(),
    );
  }

  final Settings _settings;
  final WatchAvailableFrugalMonths _watchAvailableFrugalMonths;
  final _subs = CompositeSubscription();

  void fetch() {
    final sub =
        Rx.combineLatest2(
          _watchAvailableFrugalMonths(),
          _settings.watchHasSeenFrugalMonthsSplash(),
          (a, b) => (a, b),
        ).listen((event) {
          final (availableMonths, hasSeenFrugalMonthsSplash) = event;
          safeEmit(
            StartFrugalMonthRowState(
              availableMonths: availableMonths,
              hasSeenFrugalMonthsSplash: hasSeenFrugalMonthsSplash,
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

class StartFrugalMonthRow extends StatelessWidget {
  const StartFrugalMonthRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: BlocProvider(
        create: (context) => StartFrugalMonthRowCubit.create(),
        child: BlocBuilder<StartFrugalMonthRowCubit, StartFrugalMonthRowState>(
          builder: (context, state) {
            final title = switch (state.availableMonths.length) {
              1 => 'Plan a Frugal ${state.availableMonths.single.monthOfYear.toMonthName()}',
              _ => 'Start a Frugal Month',
            };
            return ListRow(
              leading: const Icon(Ionicons.logo_usd),
              title: Text(title),
              subtitle: const Text('Set a limit and spend wisely'),
              onTap: () async {
                if (state.hasSeenFrugalMonthsSplash) {
                  context.startCreateFrugalMonth();
                } else {
                  GoRouter.of(context).go(FrugalMonthSplashScreen.route);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
