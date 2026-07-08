import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../external/http_client.dart';
import '../../../persistence/drift/local_database.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../../../utils/typedefs.dart';

class MonthsFetchState {
  MonthsFetchState({required this.months, required this.currentMonth});

  factory MonthsFetchState.initial() {
    return MonthsFetchState(months: const Idle(), currentMonth: const Idle());
  }

  final Async<List<Month>> months;
  final Async<SingleMonth> currentMonth;
}

class MonthsFetchCubit extends Cubit<MonthsFetchState> {
  MonthsFetchCubit({required this.settings, required this.client, required this.database})
    : super(MonthsFetchState.initial()) {
    unawaited(fetch());
  }

  factory MonthsFetchCubit.create() {
    return MonthsFetchCubit(settings: inject(), client: inject(ynabHttpClient), database: inject());
  }

  final Settings settings;
  final HttpClient client;
  final LocalDatabase database;
  final subs = CompositeSubscription();

  Future<void> fetch() async {
    if (subs.isNotEmpty) await subs.clear();

    final monthsStream = settings.watchSelectedBudgetId().switchMap(($budgetId) async* {
      if ($budgetId.isSome()) {
        final budgetId = $budgetId.unwrap();
        yield MonthsFetchState(months: const Loading(), currentMonth: state.currentMonth);
        final lastKnowledge = await database.getMonthKnowledge(budgetId: budgetId);
        final response = await client.execute<Json>(
          GetRequest(
            '/budgets/$budgetId/months',
            queryParameters: {
              if (lastKnowledge != null) //
                'last_knowledge_of_server': lastKnowledge.knowledge,
            },
          ),
        );

        switch (response) {
          case SuccessResponse<Json>():
            final json = response.response.data!;
            final parsed = MonthsResponseMapper.fromMap(json);
            if (parsed.data.months.isEmpty) {
              await database.updateMonthKnowledge(parsed.data.serverKnowledge, budgetId: budgetId);
            } else {
              await database.insertMonths(
                parsed.data.months,
                budgetId: budgetId,
                knowledge: parsed.data.serverKnowledge,
              );
            }
            yield MonthsFetchState(
              months: Loaded(parsed.data.months),
              currentMonth: state.currentMonth,
            );
          case ErrorResponse<Json>(:final error):
            yield MonthsFetchState(months: Error(error), currentMonth: state.currentMonth);
        }
      }
    });

    final currentMonthStream = settings.watchSelectedBudgetId().switchMap(($budgetId) async* {
      if ($budgetId.isSome()) {
        final budgetId = $budgetId.unwrap();
        yield MonthsFetchState(months: state.months, currentMonth: const Loading());
        final currentMonth = today.firstDayOfMonth().yyyyMMddWithHyphens();
        final response = await client.execute<Json>(
          GetRequest('/budgets/$budgetId/months/$currentMonth'),
        );

        switch (response) {
          case SuccessResponse<Json>():
            final json = response.response.data!;
            final parsed = MonthResponseMapper.fromMap(json);
            await database.updateCurrentMonth(parsed.data.month, budgetId: budgetId);
            yield MonthsFetchState(months: state.months, currentMonth: Loaded(parsed.data.month));
          case ErrorResponse<Json>(:final error):
            yield MonthsFetchState(months: state.months, currentMonth: Error(error));
        }
      }
    });
    final sub = Rx.combineLatest2(
      monthsStream,
      currentMonthStream,
      (a, b) => MonthsFetchState(months: a.months, currentMonth: b.currentMonth),
    ).listen(safeEmit);
    subs.add(sub);
  }
}
