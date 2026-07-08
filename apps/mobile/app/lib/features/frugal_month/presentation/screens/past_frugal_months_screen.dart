import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/presentation/design_system/section_body.dart';
import '../../../../utils/_cubit.dart';
import '../../domain/models/frugal_month.dart';
import '../../domain/use_cases/watch_past_frugal_months.dart';
import '../widgets/frugal_month_row.dart';
import 'frugal_month_details_screen.dart';

class PastFrugalMonthsScreenState {
  PastFrugalMonthsScreenState({required this.frugalMonths});

  factory PastFrugalMonthsScreenState.initial() {
    return PastFrugalMonthsScreenState(frugalMonths: const Loading());
  }

  final Async<List<FrugalMonth>> frugalMonths;
}

class PastFrugalMonthsScreenCubit extends Cubit<PastFrugalMonthsScreenState> {
  PastFrugalMonthsScreenCubit({required WatchPastFrugalMonths watchPastFrugalMonths})
    : _watchPastFrugalMonths = watchPastFrugalMonths,
      super(PastFrugalMonthsScreenState.initial()) {
    fetch();
  }

  factory PastFrugalMonthsScreenCubit.create() {
    return PastFrugalMonthsScreenCubit(watchPastFrugalMonths: WatchPastFrugalMonths.create());
  }

  final WatchPastFrugalMonths _watchPastFrugalMonths;
  final subs = CompositeSubscription();

  void fetch() {
    safeEmit(PastFrugalMonthsScreenState(frugalMonths: const Loading()));

    final sub = _watchPastFrugalMonths().listen((frugalMonths) {
      safeEmit(PastFrugalMonthsScreenState(frugalMonths: Loaded(frugalMonths)));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class PastFrugalMonthsScreen extends StatelessWidget {
  const PastFrugalMonthsScreen({super.key});

  static String route = '/settings/past_frugal_months';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PastFrugalMonthsScreenCubit.create(),
      child: const _PastFrugalMonthsSection(),
    );
  }
}

class _PastFrugalMonthsSection extends StatelessWidget {
  const _PastFrugalMonthsSection();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Past Frugal Months')),
      body: Builder(
        builder: (context) {
          final pastFrugalMonths = context.select(
            (PastFrugalMonthsScreenCubit c) => c.state.frugalMonths,
          );

          if (pastFrugalMonths.isLoading) {
            return const CircularProgressIndicator.adaptive();
          }

          if (pastFrugalMonths.isError) return const Text('Error');

          final months = pastFrugalMonths.unwrap();

          if (months.isEmpty) {
            return const Center(child: Text('No past frugal months'));
          }

          return ListSection(
            children: [
              for (final frugalMonth in months) ...[
                FrugalMonthRow(
                  frugalMonth: frugalMonth,
                  onTap: () {
                    GoRouter.of(
                      context,
                    ).go(FrugalMonthDetailsScreen.buildSettingsTabRoute(frugalMonth.id));
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
