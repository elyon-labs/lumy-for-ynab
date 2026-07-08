import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../app/di.dart';
import '../../../../../common/domain/accounts/accounts_repository.dart';
import '../../../../../common/domain/accounts/accounts_view.dart';
import '../../../../../persistence/settings.dart';
import '../../../../../utils/_cubit.dart';
import '../../../../charts/models/chart.dart';
import 'choose_chart_accounts_screen_state.dart';

class ChooseChartAccountsScreenCubit extends Cubit<ChooseChartAccountsScreenState> {
  ChooseChartAccountsScreenCubit({
    required Chart chart,
    required AccountsRepository accountsRepo,
    required Settings settings,
  }) : _accountsRepo = accountsRepo,
       _settings = settings,
       _chart = chart,
       super(ChooseChartAccountsScreenState.initial(chart)) {
    fetch();
  }

  factory ChooseChartAccountsScreenCubit.create(Chart chart) {
    return ChooseChartAccountsScreenCubit(chart: chart, accountsRepo: inject(), settings: inject());
  }

  final Chart _chart;
  final Settings _settings;
  final AccountsRepository _accountsRepo;
  final subs = CompositeSubscription();

  void fetch() {
    final accounts = _accountsRepo.watch(const AllAccounts());
    final chartAccounts = _settings.watchChartAccounts(_chart);
    final sub = Rx.combineLatest2(
      accounts,
      chartAccounts,
      (a, b) =>
          ChooseChartAccountsScreenState(accounts: a, chartAccounts: Loaded(b), chart: _chart),
    ).listen(safeEmit);
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}
