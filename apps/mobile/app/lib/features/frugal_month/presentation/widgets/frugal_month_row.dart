import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../common/presentation/_int.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../../../utils/_cubit.dart';
import '../../domain/models/frugal_month.dart';
import '../../domain/models/frugal_month_data.dart';
import '../../domain/use_cases/watch_frugal_month_data.dart';
import 'status_badge.dart';

class FrugalMonthRowState {
  FrugalMonthRowState({required this.month, required this.data, required this.currencyFormat});

  factory FrugalMonthRowState.initial({required FrugalMonth month}) {
    return FrugalMonthRowState(month: month, data: const Loading(), currencyFormat: const None());
  }

  final FrugalMonth month;
  final Async<FrugalMonthData> data;
  final Option<CurrencyFormat> currencyFormat;
}

class FrugalMonthRowCubit extends Cubit<FrugalMonthRowState> {
  FrugalMonthRowCubit({
    required FrugalMonth frugalMonth,
    required WatchFrugalMonthData watchFrugalMonthData,
    required BudgetsRepository budgetsRepository,
  }) : _frugalMonth = frugalMonth,
       _budgetsRepository = budgetsRepository,
       _watchFrugalMonthData = watchFrugalMonthData,
       super(FrugalMonthRowState.initial(month: frugalMonth)) {
    fetch();
  }

  factory FrugalMonthRowCubit.create(FrugalMonth month) {
    return FrugalMonthRowCubit(
      frugalMonth: month,
      watchFrugalMonthData: WatchFrugalMonthData.create(),
      budgetsRepository: inject(),
    );
  }

  final FrugalMonth _frugalMonth;
  final WatchFrugalMonthData _watchFrugalMonthData;
  final BudgetsRepository _budgetsRepository;
  final subs = CompositeSubscription();

  void fetch() {
    final sub =
        Rx.combineLatest2(
          _watchFrugalMonthData(_frugalMonth.id),
          _budgetsRepository.watchCurrencyFormat(),
          (a, b) => (a, b),
        ).listen((event) {
          final (data, currencyFormat) = event;
          safeEmit(
            FrugalMonthRowState(
              month: _frugalMonth,
              data: Loaded(data),
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

class FrugalMonthRow extends StatelessWidget {
  const FrugalMonthRow({super.key, required this.frugalMonth, required this.onTap});

  final FrugalMonth frugalMonth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FrugalMonthRowCubit.create(frugalMonth),
      child: ListRow(
        title: Text('Frugal ${frugalMonth.month.monthOfYear.toMonthName()}'),
        subtitle: BlocBuilder<FrugalMonthRowCubit, FrugalMonthRowState>(
          builder: (context, state) {
            return Text('${frugalMonth.targetAmount.format(state.currencyFormat)} limit');
          },
        ),
        trailing: BlocBuilder<FrugalMonthRowCubit, FrugalMonthRowState>(
          builder: (context, state) {
            return switch (state.data) {
              Loaded<FrugalMonthData>(:final value) => () {
                return HLayout(
                  spacing: 0,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    StatusBadge(status: value.status),
                    const SizedBox(width: 8),
                    const Icon(
                      Ionicons.chevron_forward_outline,
                      size: Sizes.unit * 2.5,
                    ).opacity(0.25),
                  ],
                );
              }(),
              _ => const Text('Loading...'),
            };
          },
        ),
        onTap: onTap,
      ),
    );
  }
}
