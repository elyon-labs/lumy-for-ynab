import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/accounts/accounts_repository.dart';
import '../../../../common/domain/accounts/accounts_view.dart';
import '../../../../common/presentation/accounts/choose_accounts.dart';
import '../../../../common/presentation/bottom_glow_container.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../../../ynab_api/_account.dart';
import '../flows/create_frugal_month_flow.dart';

class ChooseFrugalMonthAccountsScreenState {
  ChooseFrugalMonthAccountsScreenState({
    required this.accounts,
    required this.isFrugalMonthNotificationsEnabled,
  });

  factory ChooseFrugalMonthAccountsScreenState.initial() {
    return ChooseFrugalMonthAccountsScreenState(
      accounts: const Loading(),
      isFrugalMonthNotificationsEnabled: false,
    );
  }

  final Async<List<Account>> accounts;
  final bool isFrugalMonthNotificationsEnabled;
}

class ChooseFrugalMonthAccountsScreenCubit extends Cubit<ChooseFrugalMonthAccountsScreenState> {
  ChooseFrugalMonthAccountsScreenCubit({required this.accountsRepo, required this.settings})
    : super(ChooseFrugalMonthAccountsScreenState.initial()) {
    fetch();
  }

  factory ChooseFrugalMonthAccountsScreenCubit.create() {
    return ChooseFrugalMonthAccountsScreenCubit(accountsRepo: inject(), settings: inject());
  }

  final AccountsRepository accountsRepo;
  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final accounts = accountsRepo.watch(const OnBudgetAccounts(includeClosed: false));
    final isFrugalMonthNotificationsEnabled = settings.watchFrugalMonthNotificationsEnabled();

    subs.add(
      Rx.combineLatest2(
        accounts,
        isFrugalMonthNotificationsEnabled,
        (a, b) => ChooseFrugalMonthAccountsScreenState(
          accounts: Loaded(a),
          isFrugalMonthNotificationsEnabled: b,
        ),
      ).listen(safeEmit),
    );
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ChooseFrugalMonthAccountsScreen extends HookWidget {
  const ChooseFrugalMonthAccountsScreen({super.key, required this.afterMonthChoice});
  final bool afterMonthChoice;

  static String buildRoute(bool afterMonthChoice) {
    return afterMonthChoice
        ? '/budget/choose_frugal_month/choose_categories/choose_accounts' //
        : '/budget/choose_categories/choose_accounts';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseFrugalMonthAccountsScreenCubit.create(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Choose accounts')),
        body:
            BlocBuilder<ChooseFrugalMonthAccountsScreenCubit, ChooseFrugalMonthAccountsScreenState>(
              builder: (context, state) {
                return switch (state.accounts) {
                  Loaded(:final value) => _LoadedBody(value),
                  _ => const Center(child: CircularProgressIndicator.adaptive()),
                };
              },
            ),
      ),
    );
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody(this.accounts);

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    final selectedAccountIds = useState(accounts.ids);
    return VLayout(
      spacing: 0,
      children: [
        Expanded(
          child: ChooseAccounts(selectedAccountIds: selectedAccountIds, options: accounts),
        ),
        BottomGlowContainer(
          child: PrimaryButton(
            onPressed: selectedAccountIds.value.isEmpty
                ? null
                : () async {
                    final step = ChooseAccountsStep(selectedAccounts: selectedAccountIds.value);
                    await context.read<CreateFrugalMonthFlow>().stepComplete(step);
                  },
            child: const Text('Confirm accounts'),
          ),
        ),
      ],
    );
  }
}
