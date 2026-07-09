import 'package:design/design.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart';

import '../../../../../../../app/di.dart';
import '../../../../../../../common/presentation/design_system/app_screen.dart';
import '../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../../../common/presentation/design_system/section_header.dart';
import '../../../../../../../persistence/drift/local_database.dart';
import '../../../../../../../persistence/settings.dart';
import '../../../../../../../utils/_build_context.dart';
import '../../../../../../../utils/_cubit.dart';
import '../../../../../../notifications/notifications.dart';
import 'feature_flags_screen.dart';
import 'feedback/feedback_options_screen.dart';

class DebugScreenState {
  DebugScreenState({required this.prefs});

  factory DebugScreenState.initial() {
    return DebugScreenState(prefs: {});
  }

  final Map<String, Object?> prefs;
}

class DebugScreenCubit extends Cubit<DebugScreenState> {
  DebugScreenCubit({required this.settings, required this.database})
    : super(DebugScreenState.initial()) {
    fetch();
  }

  factory DebugScreenCubit.create() {
    return DebugScreenCubit(settings: inject(), database: inject());
  }

  final Settings settings;
  final LocalDatabase database;
  final subs = CompositeSubscription();

  void fetch() {
    subs.add(settings.watchAll().listen((prefs) => safeEmit(DebugScreenState(prefs: prefs))));
  }

  Future<void> deleteTransactions() async {
    await database.deleteTransactionData();
  }

  Future<void> clearAllBudgetRelatedData() async {
    await database.clearAllBudgetRelatedData();
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class DebugScreen extends HookWidget {
  const DebugScreen({super.key});

  static String route = '/settings/debug';

  @override
  Widget build(BuildContext context) {
    final deleteTransactionsTapped = useState(0);
    final deletePreferencesTapped = useState(0);
    return BlocProvider(
      create: (context) => DebugScreenCubit.create(),
      child: AppScreen(
        title: const Text('Debug'),
        child: SingleChildScrollView(
          child: VLayout(
            spacing: Sizes.unit * 3,
            children: [
              const VSpace(),
              const _FeatureFlagsSection(),
              BlocBuilder<DebugScreenCubit, DebugScreenState>(
                builder: (context, state) {
                  final prefsRows = state.prefs.entries.map<Widget>((e) {
                    return ListRow(
                      title: Text(e.key),
                      subtitle: Text(e.value.toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy_outlined),
                        onPressed: () async {
                          context.showToast(
                            Text('Copied ${e.key} to clipboard'),
                            duration: const Duration(seconds: 1),
                          );
                          await Clipboard.setData(ClipboardData(text: e.value.toString()));
                        },
                      ),
                    );
                  });
                  return VLayout(
                    children: [
                      const HEdgePadding(child: SectionHeader('PREFERENCES')),
                      ListSection(children: prefsRows.toList()),
                    ],
                  );
                },
              ),
              const _NotificationsSection(),
              _DangerZoneSection(
                deleteTransactionsTapped: deleteTransactionsTapped,
                deletePreferencesTapped: deletePreferencesTapped,
              ),
              const VSpace(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureFlagsSection extends StatelessWidget {
  const _FeatureFlagsSection();

  @override
  Widget build(BuildContext context) {
    return VLayout(
      children: [
        const HEdgePadding(child: SectionHeader('FEATURE FLAGS')),
        ListSection(
          children: [
            ListRow(
              title: const Text('Feature flags'),
              subtitle: const Text('Enable or disable in-development features.'),
              onTap: () => GoRouter.of(context).go(FeatureFlagsScreen.route),
            ),
          ],
        ),
      ],
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) {
    return VLayout(
      children: [
        const HEdgePadding(child: SectionHeader('NOTIFICATIONS')),
        ListSection(
          children: [
            ListRow(
              title: const Text('Scheduled notifications'),
              subtitle: const Text('Tap to see scheduled notifications.'),
              onTap: () async {
                final requests = await $notifications().pendingNotificationRequests();
                if (requests.isEmpty && context.mounted) {
                  context.showToast(const Text('No scheduled notifications.'));
                  return;
                }
                if (context.mounted) {
                  await showModalBottomSheet(
                    showDragHandle: true,
                    context: context,
                    useRootNavigator: true,
                    builder: (context) {
                      return SafeArea(
                        child: ListView(
                          children: requests
                              .map(
                                (e) => ListRow(
                                  title: Text('${e.id}: ${e.title}'),
                                  subtitle: Text(e.body ?? 'No body'),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            ListRow(
              title: const Text('Schedule a notification'),
              subtitle: const Text('Tap to schedule a test notification.'),
              onTap: () async {
                final granted = await $notifications().requestPermission();
                if (granted) {
                  await $notifications().schedule(
                    TestNotification(),
                    scheduledDate: TZDateTime.now(local).add(const Duration(seconds: 5)),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _DangerZoneSection extends StatelessWidget {
  const _DangerZoneSection({
    required this.deleteTransactionsTapped,
    required this.deletePreferencesTapped,
  });

  final ValueNotifier<int> deleteTransactionsTapped;
  final ValueNotifier<int> deletePreferencesTapped;

  @override
  Widget build(BuildContext context) {
    return VLayout(
      children: [
        HEdgePadding(
          child: Text(
            'DANGER ZONE',
            style: context.text.title.copyWith(
              color: context.colors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListSection(
          children: [
            ListRow(
              title: const Text('Delete all transaction data'),
              subtitle: const Text('Clear transaction data for all budgets from the database.'),
              onTap: () async {
                deleteTransactionsTapped.value++;
                if (deleteTransactionsTapped.value < 2) {
                  context.showToast(
                    const Text('Tap again to confirm.'),
                    duration: const Duration(seconds: 1),
                  );
                } else {
                  await context.read<DebugScreenCubit>().deleteTransactions();
                  if (context.mounted) {
                    context.showToast(
                      const Text('Transaction data deleted!'),
                      duration: const Duration(seconds: 1),
                    );
                  }
                }
              },
            ),
            // Technically this won't work if you've deleted entities
            // (they're not returned in non-delta requests), so hiding for now
            if (kDebugMode)
              ListRow(
                title: const Text('Clear all YNAB data'),
                subtitle: const Text(
                  'Clear all data from the database, causing a full refetch of all YNAB data.',
                ),
                onTap: () async {
                  await context.read<DebugScreenCubit>().clearAllBudgetRelatedData();
                  if (context.mounted) {
                    context.showToast(const Text('All data deleted!'));
                  }
                },
              ),

            Padding(
              padding: const EdgeInsets.only(bottom: Sizes.edgePadding),
              child: ListRow(
                title: const Text('Clear all preferences'),
                onTap: () async {
                  deletePreferencesTapped.value++;
                  if (deletePreferencesTapped.value < 2) {
                    context.showToast(
                      const Text('Tap again to confirm.'),
                      duration: const Duration(seconds: 1),
                    );
                  } else {
                    await $settings().clear();
                    if (context.mounted) {
                      context.showToast(const Text('Cleared!'));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TestNotification implements LocalNotification {
  @override
  String get body => 'This is just a test notification';

  @override
  NotificationChannel get channel => NotificationChannel.frugalMonths;

  @override
  String get id => 'test_notification';

  @override
  NotificationPayload get payload =>
      NotificationPayload(destination: FeedbackOptionsScreen.buildRoute());

  @override
  String get title => 'Test Notification';
}
