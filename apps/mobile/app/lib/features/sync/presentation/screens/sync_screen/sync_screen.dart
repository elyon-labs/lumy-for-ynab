import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../common/presentation/_int.dart';
import '../../../../../persistence/drift/local_database.dart';
import '../../../../home/presentation/screens/budget_tab/presentation/screens/budget_tab/budget_tab.dart';
import '../sync_status_screen/sync_status_screen.dart';
import 'sync_screen_cubit.dart';
import 'sync_screen_state.dart';

class SyncScreen extends HookWidget {
  const SyncScreen({super.key});

  static String route = '${SyncStatusScreen.route}/sync';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync')),
      body: BlocProvider(create: (context) => SyncScreenCubit.create(), child: const _SyncStatus()),
    );
  }
}

class _SyncStatus extends StatelessWidget {
  const _SyncStatus();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SyncScreenCubit>().state;

    String statusText(SyncStatus state, String name) {
      return switch (state) {
        SyncStatus.notSynced => '$name to sync',
        SyncStatus.syncing => '$name syncing',
        SyncStatus.synced => '$name synced',
        SyncStatus.failedSync => '$name failed to sync',
      };
    }

    TextStyle statusTextStyle(SyncStatus state) {
      return switch (state) {
        SyncStatus.notSynced => context.text.title,
        SyncStatus.syncing => context.text.title.copyWith(color: context.colors.good),
        SyncStatus.synced => context.text.title.copyWith(color: context.colors.good),
        SyncStatus.failedSync => context.text.title.copyWith(color: context.colors.error),
      };
    }

    if (state.isComplete) {
      return const Center(child: _CompleteBody());
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.edgePadding),
      child: VLayout(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: VLayout(
                spacing: 0,
                children: [
                  if (state.categoryViews.isNotEmpty) ...[
                    VLayout(
                      children: [
                        Text(
                          statusText(
                            state.categoryViewsSync,
                            '${state.categoryViews.length} category view${state.categoryViews.length == 1 ? '' : 's'}',
                          ),
                          style: statusTextStyle(state.categoryViewsSync),
                        ),
                        ...state.categoryViews.map(
                          (view) => Padding(
                            padding: const EdgeInsets.only(left: Sizes.edgePadding),
                            child: Text(view.name),
                          ),
                        ),
                      ],
                    ),
                    const VEdgePadding(child: Divider(indent: 0, endIndent: 0)),
                  ],
                  if (state.frugalMonths.isNotEmpty) ...[
                    VLayout(
                      children: [
                        Text(
                          statusText(
                            state.frugalMonthsSync,
                            '${state.frugalMonths.length} frugal month${state.frugalMonths.length == 1 ? '' : 's'}',
                          ),
                          style: statusTextStyle(state.frugalMonthsSync),
                        ),
                        ...state.frugalMonths.map(
                          (month) => Padding(
                            padding: const EdgeInsets.only(left: Sizes.edgePadding),
                            child: Text('Frugal ${month.month.monthOfYear.toMonthName()}'),
                          ),
                        ),
                      ],
                    ),
                    const VEdgePadding(child: Divider(indent: 0, endIndent: 0)),
                  ],
                  if (state.spendTrackers.isNotEmpty) ...[
                    VLayout(
                      children: [
                        Text(
                          statusText(
                            state.spendTrackersSync,
                            '${state.spendTrackers.length} spend tracker${state.spendTrackers.length == 1 ? '' : 's'}',
                          ),
                          style: statusTextStyle(state.spendTrackersSync),
                        ),
                        ...state.spendTrackers.map(
                          (tracker) => Padding(
                            padding: const EdgeInsets.only(left: Sizes.edgePadding),
                            child: Text(tracker.preferredName),
                          ),
                        ),
                      ],
                    ),
                    const VEdgePadding(child: Divider(indent: 0, endIndent: 0)),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            child: VLayout(
              children: [
                PrimaryButton(
                  onPressed: state.isSyncing
                      ? null
                      : () async {
                          if (state.hasSyncedData) {
                            final choice = await showModalBottomSheet<_SyncChoice>(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height * 0.5,
                              ),
                              context: context,
                              builder: (_) => const _SyncChoiceBottomSheet(),
                            );
                            if (choice == null || !context.mounted) return;
                            switch (choice) {
                              case _SyncChoice.overwrite:
                                await context.read<SyncScreenCubit>().startSync(
                                  deleteExistingData: true,
                                );
                              case _SyncChoice.duplicate:
                                await context.read<SyncScreenCubit>().startSync(
                                  deleteExistingData: false,
                                );
                            }
                          } else {
                            await context.read<SyncScreenCubit>().startSync(
                              deleteExistingData: false,
                            );
                          }
                        },
                  child: const Text('Start syncing'),
                ),
                if (state.hasSyncedData)
                  SecondaryButton(
                    onPressed: state.isSyncing
                        ? null
                        : () async {
                            await context.read<SyncScreenCubit>().skipSync();
                          },
                    child: const Text('Skip sync'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _SyncChoice { overwrite, duplicate }

class _SyncChoiceBottomSheet extends StatelessWidget {
  const _SyncChoiceBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.edgePadding),
      child: VLayout(
        children: [
          CircleAvatar(
            radius: Sizes.unit * 4,
            backgroundColor: context.colors.warning,
            child: Icon(
              Ionicons.hand_left_outline,
              size: Sizes.unit * 4,
              color: context.colors.onWarning,
            ),
          ),
          const VSpace(space: Sizes.unit * 2),
          Text('Before you sync', style: context.text.headline),
          Text(
            'It looks like you have already synced data from a different device. Do you want to replace that data, or add the data from this device (doing so may cause duplicate data that you can delete later). If you prefer to skip syncing this data, close this dialog.',
            style: context.text.body.copyWith(color: context.colors.muted),
          ),
          const Spacer(),
          SafeArea(
            child: VLayout(
              children: [
                PrimaryButton(
                  child: const Text('Add data'),
                  onPressed: () {
                    Navigator.of(context).pop(_SyncChoice.duplicate);
                  },
                ),
                SecondaryButton(
                  child: const Text('Overwrite existing data'),
                  onPressed: () {
                    Navigator.of(context).pop(_SyncChoice.overwrite);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompleteBody extends StatelessWidget {
  const _CompleteBody();

  @override
  Widget build(BuildContext context) {
    final errors = context.watch<SyncScreenCubit>().state.errors;

    if (errors.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Sizes.edgePadding),
        child: VLayout(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                    Text("Shoot, that didn't go as planned.", style: context.text.headline),
                    Text(
                      'You can try to sync again, but if the problem persists, please contact support.',
                      style: context.text.body.copyWith(color: context.colors.muted),
                    ),
                    ...errors.map(
                      (error) => Text(
                        error.toString(),
                        style: context.text.body.copyWith(color: context.colors.error),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: VLayout(
                children: [
                  PrimaryButton(
                    child: const Text('Try again'),
                    onPressed: () async {
                      await context.read<SyncScreenCubit>().startSync(deleteExistingData: false);
                    },
                  ),
                  SecondaryButton(
                    child: const Text('Skip sync'),
                    onPressed: () async {
                      await context.read<SyncScreenCubit>().skipSync();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.edgePadding),
      child: VLayout(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: VLayout(
                children: [
                  CircleAvatar(
                    radius: Sizes.unit * 4,
                    backgroundColor: context.colors.good,
                    child: Icon(
                      Ionicons.checkmark_outline,
                      size: Sizes.unit * 4,
                      color: context.colors.onGood,
                    ),
                  ),
                  Text('Great! Everything is up to date.', style: context.text.headline),
                  Text(
                    "All of your existing Lumy data has been synced, and you won't need to do this again.",
                    style: context.text.body.copyWith(color: context.colors.muted),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: PrimaryButton(
              child: const Text('Go home'),
              onPressed: () async {
                GoRouter.of(context).go(BudgetTab.route);
              },
            ),
          ),
        ],
      ),
    );
  }
}
