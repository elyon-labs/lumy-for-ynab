import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../../common/presentation/_widget.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../../../common/presentation/design_system/section_body.dart';
import '../../../../common/presentation/design_system/section_header.dart';
import '../../../../common/presentation/modals/_build_context.dart';
import '../../../../common/presentation/modals/dialog_action_button.dart';
import '../../../../persistence/settings.dart';
import '../../../../utils/_cubit.dart';
import '../../../../utils/_local_date.dart';
import '../../../home/presentation/screens/budget_tab/presentation/screens/budget_tab/budget_tab.dart';
import '../../domain/models/frugal_month.dart';
import '../../domain/models/frugal_month_data.dart';
import '../../domain/use_cases/delete_frugal_month.dart';
import '../../domain/use_cases/watch_frugal_month_data.dart';
import '../notifications/frugal_month_notifications.dart';
import 'update_frugal_month_notifications_screen.dart';
import 'view_frugal_month_accounts_screen.dart';
import 'view_frugal_month_categories_screen.dart';

class FrugalMonthSettingsScreenState {
  FrugalMonthSettingsScreenState({
    required this.frugalMonthId,
    required this.data,
    required this.frugalMonthNotificationsEnabled,
  });

  factory FrugalMonthSettingsScreenState.initial({required String frugalMonthId}) {
    return FrugalMonthSettingsScreenState(
      frugalMonthId: frugalMonthId,
      data: const Loading(),
      frugalMonthNotificationsEnabled: false,
    );
  }

  final String frugalMonthId;
  final Async<FrugalMonthData> data;
  final bool frugalMonthNotificationsEnabled;
}

class FrugalMonthSettingsScreenCubit extends Cubit<FrugalMonthSettingsScreenState> {
  FrugalMonthSettingsScreenCubit({
    required String frugalMonthId,
    required Settings settings,
    required DeleteFrugalMonth deleteFrugalMonth,
    required WatchFrugalMonthData watchFrugalMonthData,
    required FrugalMonthNotificationsHandler notifications,
  }) : _deleteFrugalMonth = deleteFrugalMonth,
       _watchFrugalMonthData = watchFrugalMonthData,
       _settings = settings,
       _notifications = notifications,
       _frugalMonthId = frugalMonthId,
       super(FrugalMonthSettingsScreenState.initial(frugalMonthId: frugalMonthId)) {
    fetch();
  }

  factory FrugalMonthSettingsScreenCubit.create(String frugalMonthId) {
    return FrugalMonthSettingsScreenCubit(
      frugalMonthId: frugalMonthId,
      deleteFrugalMonth: DeleteFrugalMonth.create(),
      watchFrugalMonthData: WatchFrugalMonthData.create(),
      settings: inject(),
      notifications: inject(),
    );
  }

  final String _frugalMonthId;
  final WatchFrugalMonthData _watchFrugalMonthData;
  final DeleteFrugalMonth _deleteFrugalMonth;
  final FrugalMonthNotificationsHandler _notifications;
  final Settings _settings;
  final subs = CompositeSubscription();

  void fetch() {
    final sub =
        Rx.combineLatest2(
          _watchFrugalMonthData(_frugalMonthId),
          _settings.watchFrugalMonthNotificationsEnabled(),
          (a, b) => (a, b),
        ).listen((event) {
          final (data, notificationsEnabled) = event;
          safeEmit(
            FrugalMonthSettingsScreenState(
              frugalMonthId: _frugalMonthId,
              data: Loaded(data),
              frugalMonthNotificationsEnabled: notificationsEnabled,
            ),
          );
        });
    subs.add(sub);
  }

  Future<void> delete() async {
    await _notifications.cancelFrugalMonthNotifications(_frugalMonthId);
    await _deleteFrugalMonth(_frugalMonthId);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class FrugalMonthSettingsScreen extends StatelessWidget {
  const FrugalMonthSettingsScreen({super.key, required this.frugalMonthId});

  final String frugalMonthId;

  static String buildRoute(String frugalMonthId) {
    return '/budget/frugal_month/$frugalMonthId/settings';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FrugalMonthSettingsScreenCubit.create(frugalMonthId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: BlocBuilder<FrugalMonthSettingsScreenCubit, FrugalMonthSettingsScreenState>(
          builder: (context, state) {
            final name = state.data.mapOr((v) => v.month.name, 'This Frugal Month');
            final showQuit = state.data.mapOr(
              (v) => v.month.month.isSameMonthAsOrAfter(today),
              false,
            );
            return VLayout(
              spacing: Sizes.unit * 2,
              children: [
                const VSpace(space: Sizes.unit * 2),
                VLayout(
                  children: [
                    HEdgePadding(child: SectionHeader(name)),
                    ListSection(
                      children: [
                        ListRow(
                          title: const Text('Categories'),
                          subtitle: const Text('Categories being tracked for spending'),
                          onTap: () {
                            GoRouter.of(
                              context,
                            ).go(ViewFrugalMonthCategoriesScreen.buildRoute(frugalMonthId));
                          },
                        ).trackedBy('frugal_month_settings_categories'),
                        ListRow(
                          title: const Text('Accounts'),
                          subtitle: const Text('Accounts being tracked for spending'),
                          onTap: () {
                            GoRouter.of(
                              context,
                            ).go(ViewFrugalMonthAccountsScreen.buildRoute(frugalMonthId));
                          },
                        ).trackedBy('frugal_month_settings_accounts'),
                        if (showQuit)
                          Padding(
                            padding: const EdgeInsets.all(Sizes.edgePadding),
                            child: HStretch(
                              child: SecondaryButton(
                                onPressed: () async {
                                  await context.showConfirmationDialog(
                                    title: const Text('Quit Frugal Month'),
                                    body: const Text(
                                      'Are you sure you want to quit this Frugal Month? This is permanent, but you can always start a new one.',
                                    ),
                                    confirmButton: DialogActionButton(
                                      text: 'Quit',
                                      isDestructive: true,
                                      onPressed: () async {
                                        await context
                                            .read<FrugalMonthSettingsScreenCubit>()
                                            .delete();
                                        if (context.mounted) {
                                          // ignore: use_build_context_synchronously
                                          GoRouter.of(context).go(BudgetTab.route);
                                        }
                                      },
                                    ),
                                    cancelButton: DialogActionButton(text: 'Nevermind'),
                                  );
                                },
                                child: Text('Quit $name'),
                              ).trackedBy('frugal_month_settings_stop'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                VLayout(
                  children: [
                    const HEdgePadding(child: SectionHeader('All Frugal Months')),
                    ListSection(
                      children: [
                        ListRow(
                          title: const Text('Notifications'),
                          subtitle: Text(
                            'Frugal Month notifications are ${state.frugalMonthNotificationsEnabled ? 'on' : 'off'}',
                          ),
                          onTap: () {
                            GoRouter.of(
                              context,
                            ).go(UpdateFrugalMonthNotificationsScreen.buildRoute(frugalMonthId));
                          },
                          trailing: const Icon(
                            Ionicons.checkmark_circle_outline,
                          ).visible(state.frugalMonthNotificationsEnabled),
                        ).trackedBy('frugal_month_settings_notifications'),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
