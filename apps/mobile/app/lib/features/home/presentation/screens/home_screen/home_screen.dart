import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';
import 'package:provider/provider.dart';

import '../../../../../common/domain/accounts/accounts_fetch_cubit.dart';
import '../../../../../common/domain/budgets/budgets_fetch_cubit.dart';
import '../../../../../common/domain/categories/categories_fetch_cubit.dart';
import '../../../../../common/domain/months/months_fetch_cubit.dart';
import '../../../../../common/domain/payees/payees_fetch_cubit.dart';
import '../../../../../common/domain/scheduled_transactions/scheduled_transactions_fetch_cubit.dart';
import '../../../../../common/domain/transactions/transactions_fetch_cubit.dart';
import '../../../../../common/domain/user/user_id_fetch_cubit.dart';
import '../../../../../common/presentation/_color.dart';
import '../../../../../common/presentation/badged.dart';
import '../../../../../common/presentation/design_system/adaptive_child.dart';
import '../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../common/presentation/design_system/side_navigation_menu.dart';
import '../../../../../common/presentation/error/error_screen.dart';
import '../../../../../common/presentation/lifecycle_listener.dart';
import '../../../../../utils/_date_time.dart';
import '../../../../sync/presentation/screens/sync_screen/sync_screen.dart';
import '../../../../whats_new/state/whats_new_state.dart';
import '../budget_tab/presentation/screens/budget_tab/widgets/initial_fetch_view.dart';
import '../budget_tab/presentation/screens/budget_tab/widgets/select_a_budget_view.dart';
import 'home_screen_cubit.dart';

typedef RefreshYnabData = Future<void> Function();

class HomeScreen extends HookWidget {
  const HomeScreen({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeScreenCubit.create(),
      child: _Body(shell: shell),
    );
  }
}

class _Body extends HookWidget {
  const _Body({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final performingInitialFetch = context.watch<TransactionsFetchCubit>().state.isInitialFetch;
    final budgetId = context.select((HomeScreenCubit cubit) => cubit.state.budgetId);

    if (performingInitialFetch) return const InitialFetchView();

    return switch (budgetId) {
      Loaded<Option<String>>(:final value) => switch (value) {
        Some<String>(:final some) => DataView(budgetId: some, shell: shell),
        None<String>() => const SelectABudgetView(),
      },
      Error<Option<String>>(:final error) => ErrorScreen(error: error),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator.adaptive())),
    };
  }
}

enum HomeScreenTab { budget, reports, settings }

class DataView extends HookWidget {
  const DataView({super.key, required this.budgetId, required this.shell});

  final String budgetId;
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final lastFetch = context.watch<TransactionsFetchCubit>().state.lastFetch;
    final userFetchState = context.watch<UserIdFetchCubit>().state;
    final budgetsFetchState = context.watch<BudgetsFetchCubit>().state;
    final categoriesFetchState = context.watch<CategoriesFetchCubit>().state;
    final payeesFetchState = context.watch<PayeesFetchCubit>().state;
    final accountsFetchState = context.watch<AccountsFetchCubit>().state;
    final transactionsFetchState = context.watch<TransactionsFetchCubit>().state;
    final scheduledTransactionsFetchState = context.watch<ScheduledTransactionsFetchCubit>().state;
    final monthsFetchState = context.watch<MonthsFetchCubit>().state.months;
    final currentMonthFetchState = context.watch<MonthsFetchCubit>().state.currentMonth;

    final fetchStates = [
      userFetchState,
      budgetsFetchState,
      categoriesFetchState,
      payeesFetchState,
      accountsFetchState,
      transactionsFetchState.transactions,
      scheduledTransactionsFetchState,
      monthsFetchState,
      currentMonthFetchState,
    ];

    final hasError = fetchStates.any((e) => e.isError);
    final isLoading = fetchStates.any((e) => e.isLoading);
    final showError = hasError && !isLoading;

    Future<void> refresh() async {
      unawaited(context.read<UserIdFetchCubit>().fetch());
      unawaited(context.read<BudgetsFetchCubit>().fetch());
      unawaited(context.read<CategoriesFetchCubit>().fetch());
      unawaited(context.read<PayeesFetchCubit>().fetch());
      unawaited(context.read<AccountsFetchCubit>().fetch());
      unawaited(context.read<TransactionsFetchCubit>().fetch());
      unawaited(context.read<ScheduledTransactionsFetchCubit>().fetch());
      unawaited(context.read<MonthsFetchCubit>().fetch());

      await Future.delayed(const Duration(milliseconds: 300));

      List<Async<Object>> states() {
        return [
          userFetchState,
          budgetsFetchState,
          categoriesFetchState,
          payeesFetchState,
          accountsFetchState,
          transactionsFetchState.transactions,
          scheduledTransactionsFetchState,
          monthsFetchState,
          currentMonthFetchState,
        ];
      }

      while (states().any((e) => e.isLoading)) {
        // Loop until all the stores are done fetching.
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    bool shouldRefresh() {
      return nowLocal.difference(lastFetch) > const Duration(minutes: 15);
    }

    void goBranch(int index) {
      shell.goBranch(
        index,
        // A common pattern when using bottom navigation bars is to support
        // navigating to the initial location when tapping the item that is
        // already active. This example demonstrates how to support this behavior,
        // using the initialLocation parameter of goBranch.
        initialLocation: index == shell.currentIndex,
      );
    }

    return LifecycleListener(
      onResumed: () async {
        if (!isLoading && shouldRefresh()) {
          await refresh();
        }
      },
      child: AdaptiveChild(
        mobile: (context) {
          return Scaffold(
            body: _DataBody(shell: shell, showError: showError, refresh: refresh),
            bottomNavigationBar: BlocProvider(
              create: (context) => WhatsNewCubit.create(),
              child: VLayout(
                spacing: 0,
                children: [
                  const Divider(indent: 0),
                  NavigationBar(
                    labelPadding: EdgeInsets.zero,
                    selectedIndex: shell.currentIndex,
                    onDestinationSelected: goBranch,
                    height: kToolbarHeight,
                    destinations: [
                      const NavigationDestination(
                        icon: Icon(Ionicons.wallet_outline),
                        selectedIcon: Icon(Ionicons.wallet),
                        label: 'Budget',
                      ),
                      const NavigationDestination(
                        icon: Icon(Ionicons.analytics_outline),
                        selectedIcon: Icon(Ionicons.analytics),
                        label: 'Reports',
                      ),
                      NavigationDestination(
                        icon: BlocBuilder<WhatsNewCubit, WhatsNewState>(
                          builder: (context, state) {
                            return Badged(
                              showBadge: state.hasNewFeatures,
                              child: const Icon(Ionicons.cog_outline),
                            );
                          },
                        ),
                        selectedIcon: const Icon(Ionicons.cog),
                        label: 'Settings',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        desktop: (context) {
          return Scaffold(
            body: Row(
              children: [
                SideNavigationMenu(
                  onItemSelected: goBranch,
                  selectedIndex: shell.currentIndex,
                  children: const [
                    SideNavigationMenuItem(
                      icon: Icon(Ionicons.wallet_outline),
                      label: Text('Budget'),
                    ),
                    SideNavigationMenuItem(
                      icon: Icon(Ionicons.analytics_outline),
                      label: Text('Reports'),
                    ),
                    SideNavigationMenuItem(
                      icon: Icon(Ionicons.cog_outline),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                Expanded(
                  child: _DataBody(shell: shell, showError: showError, refresh: refresh),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DataBody extends StatelessWidget {
  const _DataBody({required this.shell, required this.showError, required this.refresh});

  final RefreshCallback refresh;
  final StatefulNavigationShell shell;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      displacement: MediaQuery.of(context).viewInsets.top + 100,
      onRefresh: refresh,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // An easy way to provide the ability to refresh YNAB data to child
          // widgets.
          _UnsyncedDataListener(
            child: Provider<RefreshYnabData>.value(value: refresh, child: shell),
          ),
          if (showError)
            Align(
              alignment: Alignment.bottomCenter,
              child: HEdgePadding(
                child: Card(
                  color: context.colors.error.withAlphaOf(0.90),
                  child: ListRow(
                    title: Text(
                      'An error occurred while fetching data from YNAB.',
                      style: TextStyle(color: context.colors.onError),
                    ),
                    trailing: IconButton(
                      onPressed: refresh,
                      icon: Icon(Ionicons.reload_circle_outline, color: context.colors.onError),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UnsyncedDataListener extends HookWidget {
  const _UnsyncedDataListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final hasUnsyncedData = context.watch<HomeScreenCubit>().state.hasUnsyncedData;

    useEffect(() {
      if (hasUnsyncedData) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(
            showModalBottomSheet(
              isDismissible: false,
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.5),
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(Sizes.edgePadding),
                  child: VLayout(
                    children: [
                      CircleAvatar(
                        radius: Sizes.unit * 4,
                        backgroundColor: context.colors.error,
                        child: Icon(
                          Ionicons.warning_outline,
                          size: Sizes.unit * 4,
                          color: context.colors.onError,
                        ),
                      ),
                      const VSpace(space: Sizes.unit * 2),
                      Text('You have unsynced data', style: context.text.headline),
                      Text(
                        'Your existing Lumy data needs to be backed up before it can be accessed. For more information, please read the release notes.',
                        style: context.text.body.copyWith(color: context.colors.muted),
                      ),
                      const Spacer(),
                      SafeArea(
                        child: SecondaryButton(
                          child: const Text('Sync Now'),
                          onPressed: () {
                            GoRouter.of(context).go(SyncScreen.route);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
      }
      return null;
    }, [hasUnsyncedData]);

    return child;
  }
}
