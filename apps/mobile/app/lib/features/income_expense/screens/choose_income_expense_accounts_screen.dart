import 'package:collection/collection.dart';
import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../common/domain/accounts/accounts_repository.dart';
import '../../../common/domain/accounts/accounts_view.dart';
import '../../../common/presentation/accounts/choose_accounts.dart';
import '../../../common/presentation/bottom_glow_container.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../ynab_api/_account.dart';

class ChooseIncomeExpenseAccountsScreenState {
  ChooseIncomeExpenseAccountsScreenState({
    required this.accounts,
    required this.incomeExpenseAccounts,
  });

  factory ChooseIncomeExpenseAccountsScreenState.initial() {
    return ChooseIncomeExpenseAccountsScreenState(
      accounts: const Loading(),
      incomeExpenseAccounts: const None(),
    );
  }

  final Async<List<Account>> accounts;
  final Option<List<String>> incomeExpenseAccounts;
}

class ChooseIncomeExpenseAccountsScreenCubit extends Cubit<ChooseIncomeExpenseAccountsScreenState> {
  ChooseIncomeExpenseAccountsScreenCubit({required this.accountsRepo, required this.settings})
    : super(ChooseIncomeExpenseAccountsScreenState.initial()) {
    fetch();
  }

  factory ChooseIncomeExpenseAccountsScreenCubit.create() {
    return ChooseIncomeExpenseAccountsScreenCubit(accountsRepo: inject(), settings: inject());
  }

  final AccountsRepository accountsRepo;
  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final accounts = accountsRepo.watch(const OnBudgetAccounts());
    final incomeExpenseAccounts = settings.watchIncomeExpenseAccounts();

    final sub = Rx.combineLatest2(accounts, incomeExpenseAccounts, (a, b) {
      return ChooseIncomeExpenseAccountsScreenState(accounts: Loaded(a), incomeExpenseAccounts: b);
    }).listen(safeEmit);

    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ChooseIncomeExpenseAccountsScreen extends HookWidget {
  const ChooseIncomeExpenseAccountsScreen({super.key});

  static String route = '/reports/income_expense/accounts';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseIncomeExpenseAccountsScreenCubit.create(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Choose accounts')),
        body:
            BlocBuilder<
              ChooseIncomeExpenseAccountsScreenCubit,
              ChooseIncomeExpenseAccountsScreenState
            >(
              builder: (context, state) {
                return switch (state.accounts) {
                  Loaded(:final value) => _LoadedBody(
                    accounts: value,
                    incomeExpenseAccounts: state.incomeExpenseAccounts,
                  ),
                  _ => const Center(child: CircularProgressIndicator.adaptive()),
                };
              },
            ),
      ),
    );
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody({required this.accounts, required this.incomeExpenseAccounts});

  final List<Account> accounts;
  final Option<List<String>> incomeExpenseAccounts;

  @override
  Widget build(BuildContext context) {
    final selectedAccounts = useState(incomeExpenseAccounts.unwrapOr(accounts.ids));
    final isSameAsDefault = const DeepCollectionEquality.unordered().equals(
      selectedAccounts.value,
      accounts.ids,
    );

    return VLayout(
      spacing: 0,
      children: [
        Expanded(
          child: ChooseAccounts(selectedAccountIds: selectedAccounts, options: accounts),
        ),
        BottomGlowContainer(
          child: PrimaryButton(
            onPressed: selectedAccounts.value.isEmpty
                ? null //
                : () async {
                    await $settings().setIncomeExpenseAccounts(
                      isSameAsDefault ? const None() : Some(selectedAccounts.value),
                    );
                    if (context.mounted) Navigator.of(context).pop();
                  },
            child: const Text('Use these accounts'),
          ),
        ),
      ],
    );
  }
}
