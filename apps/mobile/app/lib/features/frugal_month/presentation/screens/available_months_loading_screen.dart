import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../utils/_cubit.dart';
import '../../domain/use_cases/watch_available_frugal_months.dart';
import '../flows/create_frugal_month_flow.dart';

class AvailableMonthsLoadingScreenState {
  const AvailableMonthsLoadingScreenState({required this.months});

  factory AvailableMonthsLoadingScreenState.initial() {
    return const AvailableMonthsLoadingScreenState(months: Loading());
  }

  final Async<List<LocalDate>> months;
}

class AvailableMonthsLoadingScreenCubit extends Cubit<AvailableMonthsLoadingScreenState> {
  AvailableMonthsLoadingScreenCubit({
    required WatchAvailableFrugalMonths watchAvailableFrugalMonths,
  }) : _watchAvailableFrugalMonths = watchAvailableFrugalMonths,
       super(AvailableMonthsLoadingScreenState.initial()) {
    unawaited(fetch());
  }

  factory AvailableMonthsLoadingScreenCubit.create() {
    return AvailableMonthsLoadingScreenCubit(
      watchAvailableFrugalMonths: WatchAvailableFrugalMonths.create(),
    );
  }

  final WatchAvailableFrugalMonths _watchAvailableFrugalMonths;
  final _subs = CompositeSubscription();

  Future<void> fetch() async {
    final availableFrugalMonthsStream = _watchAvailableFrugalMonths();
    final sub = availableFrugalMonthsStream.listen((months) {
      safeEmit(AvailableMonthsLoadingScreenState(months: Loaded(months)));
    });
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}

class AvailableMonthsLoadingScreen extends StatelessWidget {
  const AvailableMonthsLoadingScreen({super.key});

  static String route = '/budget/available_months_loading';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvailableMonthsLoadingScreenCubit.create(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<AvailableMonthsLoadingScreenCubit, AvailableMonthsLoadingScreenState>(
          listener: (context, state) async {
            final months = state.months.valueOr([]);
            if (months.isNotEmpty) {
              final step = FetchAvailableMonthsStep(availableMonths: months);
              await context.read<CreateFrugalMonthFlow>().stepComplete(step);
            }
          },
          child: const Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}
