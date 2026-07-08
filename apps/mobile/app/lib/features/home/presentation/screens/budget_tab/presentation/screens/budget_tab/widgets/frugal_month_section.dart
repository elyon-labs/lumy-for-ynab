import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../../../app/di.dart';
import '../../../../../../../../../common/domain/accounts/accounts_view.dart';
import '../../../../../../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../../../../../../common/domain/categories/categories_view.dart';
import '../../../../../../../../../common/domain/transactions/transactions_repository.dart';
import '../../../../../../../../../common/domain/transactions/transactions_view.dart';
import '../../../../../../../../../common/presentation/_int.dart';
import '../../../../../../../../../common/presentation/charts/loading_chart.dart';
import '../../../../../../../../../common/presentation/currency.dart';
import '../../../../../../../../../common/presentation/design_system/section_header.dart';
import '../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../../utils/_local_date.dart';
import '../../../../../../../../charts/widgets/visual_card.dart';
import '../../../../../../../../frugal_month/domain/calculate_frugal_month_data.dart';
import '../../../../../../../../frugal_month/domain/models/frugal_month.dart';
import '../../../../../../../../frugal_month/domain/models/frugal_month_data.dart';
import '../../../../../../../../frugal_month/presentation/screens/frugal_month_details_screen.dart';
import '../../../../../../../../frugal_month/presentation/widgets/frugal_month_chart.dart';

class FrugalMonthSectionState {
  FrugalMonthSectionState({required this.data, required this.isLoading});

  factory FrugalMonthSectionState.initial() {
    return FrugalMonthSectionState(data: null, isLoading: true);
  }

  final FrugalMonthData? data;
  final bool isLoading;
}

class FrugalMonthSectionCubit extends Cubit<FrugalMonthSectionState> {
  FrugalMonthSectionCubit({
    required FrugalMonth frugalMonth,
    required TransactionsRepository transactionsRepository,
  }) : _transactionsRepository = transactionsRepository,
       _frugalMonth = frugalMonth,
       super(FrugalMonthSectionState.initial()) {
    fetch();
  }

  factory FrugalMonthSectionCubit.create(FrugalMonth month) {
    return FrugalMonthSectionCubit(frugalMonth: month, transactionsRepository: inject());
  }

  final FrugalMonth _frugalMonth;
  final TransactionsRepository _transactionsRepository;
  final _subs = CompositeSubscription();

  void fetch() {
    final onBudgetTransactions = _transactionsRepository.watch(
      const TransactionsView(
        dateRange: AllTime(),
        accounts: OnBudgetAccounts(),
        categories: AllCategories(),
        filter: NoFilter(),
      ),
    );
    final sub = onBudgetTransactions
        .flatMap((transactions) async* {
          final data = await calculateFrugalMonthData(
            _frugalMonth,
            onBudgetTransactions: transactions,
          );
          yield data;
        })
        .listen((frugalMonthData) {
          safeEmit(FrugalMonthSectionState(data: frugalMonthData, isLoading: false));
        });
    _subs.add(sub);
  }

  @override
  Future<void> close() async {
    await _subs.cancel();
    return super.close();
  }
}

class FrugalMonthSection extends HookWidget {
  const FrugalMonthSection({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    return HEdgePadding(
      child: BlocBuilder<FrugalMonthSectionCubit, FrugalMonthSectionState>(
        builder: (context, state) {
          final data = Option.from(state.data);
          return VisualCard(
            key: data.mapOr((d) => ValueKey(d.month.id), null),
            title: Skeletonizer(
              enabled: state.isLoading,
              child: SectionHeader(
                data.mapOr((d) => d.month.name, today.monthOfYear.toMonthName()),
              ),
            ),
            subtitle: Skeletonizer(
              enabled: state.isLoading,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: data.mapOr((d) => d.leftToSpend.format(currencyFormat), ''),
                      style: context.text.headline,
                    ),
                    const WidgetSpan(child: HSpace(space: Sizes.unit / 2)),
                    TextSpan(text: 'left', style: context.text.title),
                  ],
                ),
              ),
            ),
            button: const Icon(Ionicons.chevron_forward, size: Sizes.unit * 2.5).opacity(0.25),
            onTap: () {
              unawaited(
                data.whenSome((d) {
                  GoRouter.of(context).go(FrugalMonthDetailsScreen.buildBudgetTabRoute(d.month.id));
                }),
              );
            },
            child: data.mapOr((d) {
              return Padding(
                padding: const EdgeInsets.all(Sizes.edgePadding / 2),
                child: FrugalMonthChart(
                  key: data.mapOr((d) => ValueKey(d.month.id), null),
                  frugalMonth: d,
                ),
              );
            }, const LoadingChart()),
          );
        },
      ),
    );
  }
}
