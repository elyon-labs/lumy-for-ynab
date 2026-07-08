import 'package:collection/collection.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../app/environment/environment.dart';
import '../../../../../../../../common/presentation/bottom_sheet_with_header.dart';
import '../../../../../../../../common/presentation/design_system/_build_context.dart';
import '../../../../../../../../common/presentation/design_system/app_screen.dart';
import '../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../../../../common/presentation/modals/_build_context.dart';
import '../../../../../../../../common/presentation/modals/dialog_action_button.dart';
import '../../../../../../../../utils/_build_context.dart';
import '../../../../../../../../utils/_local_date.dart';
import '../../../../../../../../ynab_api/_budget.dart';
import '../../../../../../../about/presentation/screens/about_app_screen/about_app_screen.dart';
import '../../../../../../../auth/presentation/screens/logout_screen/logout_screen.dart';
import '../../../../../../../frugal_month/presentation/screens/past_frugal_months_screen.dart';
import '../../../../../../../sync/presentation/screens/sync_status_screen/sync_status_screen.dart';
import '../../../../../../../whats_new/screens/whats_new_screen.dart';
import '../../../../../../../whats_new/state/whats_new_state.dart';
import '../../../../../../../whats_new/widgets/whats_new_icon.dart';
import '../../../../home_screen/home_screen.dart';
import '../category_view_list_screen/category_views_list_screen.dart';
import '../charts/charts_settings_screen.dart';
import '../debug_screen.dart';
import '../feedback/feedback_options_screen.dart';
import '../spend_tracker_ordering_screen/spend_tracker_ordering_screen.dart';
import 'settings_tab_cubit.dart';
import 'settings_tab_state.dart';
import 'widgets/null_currency_warning_tile.dart';

class SettingsTab extends HookWidget {
  const SettingsTab({super.key});

  static const route = '/settings';

  @override
  Widget build(BuildContext context) {
    final darkModeTappedTimes = useState(0);
    final hasShownDebugSnackBar = useState(false);
    const showDebugThreshold = 9;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsTabCubit.create()),
        BlocProvider(create: (_) => WhatsNewCubit.create()),
      ],
      child: BlocBuilder<SettingsTabCubit, SettingsTabState>(
        builder: (context, state) {
          return AppScreen(
            title: context.isDesktop ? const Text('Settings') : null,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (!context.isDesktop)
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    title: const Text('Settings'),
                    centerTitle: false,
                    titleTextStyle: context.text.headline.copyWith(fontWeight: FontWeight.bold),
                    pinned: true,
                  ),
                BlocBuilder<WhatsNewCubit, WhatsNewState>(
                  builder: (context, whatsNewState) {
                    final showImportantSection =
                        whatsNewState.hasNewFeatures || state.shouldShowNullCurrencyTile;
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        const VSpace(space: Sizes.edgePadding),
                        if (showImportantSection) ...[
                          _ImportantSection(
                            whatsNewState: whatsNewState,
                            shouldShowNullCurrencyTile: state.shouldShowNullCurrencyTile,
                          ),
                          const VSpace(space: Sizes.unit * 2),
                        ],
                        VLayout(
                          spacing: Sizes.unit * 3,
                          children: [
                            const _DataSection(),
                            _AppearanceSection(
                              themeMode: state.themeMode,
                              darkModeTappedTimes: darkModeTappedTimes,
                              showDebugThreshold: showDebugThreshold,
                              hasShownDebugSnackBar: hasShownDebugSnackBar,
                            ),
                            _LumySection(
                              whatsNewState: whatsNewState,
                              darkModeTappedTimes: darkModeTappedTimes,
                              showDebugThreshold: showDebugThreshold,
                            ),
                            const _AccountSection(),
                          ],
                        ),
                      ]),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return HEdgePadding(child: Text(title, style: context.text.headline));
  }
}

class _ImportantSection extends StatelessWidget {
  const _ImportantSection({required this.whatsNewState, required this.shouldShowNullCurrencyTile});

  final WhatsNewState whatsNewState;
  final bool shouldShowNullCurrencyTile;

  @override
  Widget build(BuildContext context) {
    return VLayout(
      children: [
        const _SettingsSectionTitle(title: 'Important'),
        ListSection(
          showDividers: false,
          children: [
            if (whatsNewState.hasNewFeatures) _WhatsNewTile(whatsNewState: whatsNewState),
            if (shouldShowNullCurrencyTile)
              NullCurrencyWarningTile(onComplete: context.read<RefreshYnabData>().call),
          ],
        ),
      ],
    );
  }
}

class _WhatsNewTile extends StatelessWidget {
  const _WhatsNewTile({required this.whatsNewState});

  final WhatsNewState whatsNewState;

  @override
  Widget build(BuildContext context) {
    return ListRow(
      title: const Text("What's new"),
      leading: WhatsNewIcon(showBadge: whatsNewState.hasNewFeatures),
      onTap: () => GoRouter.of(context).go(WhatsNewScreen.route),
    );
  }
}

class _DataSection extends StatelessWidget {
  const _DataSection();

  @override
  Widget build(BuildContext context) {
    final pastFrugalMonths = context.select((SettingsTabCubit c) => c.state.pastFrugalMonths);
    return BlocBuilder<SettingsTabCubit, SettingsTabState>(
      builder: (context, state) {
        return VLayout(
          children: [
            const _SettingsSectionTitle(title: 'Data'),
            ListSection(
              showDividers: false,
              children: [
                ListRow(
                  title: const Text('Charts'),
                  leading: const Icon(Ionicons.pie_chart_outline),
                  onTap: () => GoRouter.of(context).go(ChartSettingsScreen.route),
                ),
                if (state.spendTrackers.length > 1)
                  ListRow(
                    title: const Text('Spend Trackers'),
                    leading: const Icon(Ionicons.analytics_outline),
                    onTap: () => GoRouter.of(context).go(SpendTrackerOrderingScreen.route),
                  ),
                ListRow(
                  title: const Text('Category Views'),
                  leading: const Icon(Ionicons.filter_circle_outline),
                  onTap: () => GoRouter.of(context).go(CategoryViewsListScreen.route),
                ),
                if (pastFrugalMonths.isNotEmpty)
                  ListRow(
                    title: const Text('Past Frugal Months'),
                    leading: const Icon(Ionicons.calendar_outline),
                    onTap: () => GoRouter.of(context).go(PastFrugalMonthsScreen.route),
                  ),
                ListRow(
                  title: const Text('Change budget'),
                  leading: const Icon(Ionicons.folder_open_outline),
                  onTap: () async {
                    await showModalBottomSheet(
                      useSafeArea: true,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      context: context,
                      showDragHandle: true,
                      builder: (_) => const _BudgetSelectionBottomSheet(),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection({
    required this.themeMode,
    required this.darkModeTappedTimes,
    required this.showDebugThreshold,
    required this.hasShownDebugSnackBar,
  });

  final ThemeMode themeMode;
  final ValueNotifier<int> darkModeTappedTimes;
  final int showDebugThreshold;
  final ValueNotifier<bool> hasShownDebugSnackBar;

  @override
  Widget build(BuildContext context) {
    return VLayout(
      children: [
        const _SettingsSectionTitle(title: 'Appearance'),
        ListSection(
          showDividers: false,
          children: ThemeMode.values.map((mode) {
            final modeName = switch (mode) {
              ThemeMode.system => 'System Default',
              ThemeMode.dark => 'Dark mode',
              ThemeMode.light => 'Light mode',
            };
            final icon = switch (mode) {
              ThemeMode.system => const Icon(Ionicons.contrast_outline),
              ThemeMode.dark => const Icon(Ionicons.moon_outline),
              ThemeMode.light => const Icon(Ionicons.sunny_outline),
            };
            return ListRow(
              title: Text(modeName),
              leading: icon,
              trailing: const Icon(Ionicons.checkmark_circle_outline).visible(themeMode == mode),
              onTap: () async {
                $settings().setThemeMode(mode);
                if (mode == ThemeMode.dark) {
                  darkModeTappedTimes.value++;
                  if (darkModeTappedTimes.value > showDebugThreshold &&
                      !hasShownDebugSnackBar.value) {
                    if (context.mounted) {
                      context.showToast(const Text('Debug mode enabled'));
                      hasShownDebugSnackBar.value = true;
                    }
                  }
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LumySection extends StatelessWidget {
  const _LumySection({
    required this.whatsNewState,
    required this.darkModeTappedTimes,
    required this.showDebugThreshold,
  });

  final WhatsNewState whatsNewState;
  final ValueNotifier<int> darkModeTappedTimes;
  final int showDebugThreshold;

  @override
  Widget build(BuildContext context) {
    return VLayout(
      children: [
        const _SettingsSectionTitle(title: 'Lumy'),
        ListSection(
          showDividers: false,
          children: [
            if (UniversalPlatform.isMobile)
              ListRow(
                leading: const Icon(Ionicons.heart_circle_outline),
                title: const Text('Leave a review'),
                onTap: () async => context.read<SettingsTabCubit>().openStore(),
              ),
            if (!whatsNewState.hasNewFeatures) _WhatsNewTile(whatsNewState: whatsNewState),
            ListRow(
              title: const Text('Get help'),
              leading: const Icon(Ionicons.help_buoy_outline),
              onTap: () => GoRouter.of(context).go(FeedbackOptionsScreen.buildRoute()),
            ),
            ListRow(
              title: const Text('Join the community'),
              leading: const Icon(Ionicons.logo_discord),
              onTap: () async {
                final url = Uri.parse(inject<Environment>().communityServerUrl);
                await launchUrl(url);
              },
            ),
            ListRow(
              title: const Text('About the app'),
              leading: const Icon(Ionicons.information_circle_outline),
              onTap: () => GoRouter.of(context).go(AboutAppScreen.route),
            ),
            if (darkModeTappedTimes.value >= showDebugThreshold)
              ListRow(
                title: const Text('Debug'),
                leading: const Icon(Ionicons.bug_outline),
                onTap: () => GoRouter.of(context).go(DebugScreen.route),
              ),
          ],
        ),
      ],
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    final isUserAnonymous = context.select((SettingsTabCubit cubit) => cubit.state.isUserAnonymous);

    final logOutText = isUserAnonymous
        ? 'Because you logged in as a guest, your Lumy data will be deleted!'
        : 'You will be required to log in again with the email you linked.';

    return VLayout(
      children: [
        const _SettingsSectionTitle(title: 'Account'),
        ListSection(
          showDividers: false,
          children: [
            ListRow(
              title: const Text('Backup Lumy data'),
              leading: const Icon(Ionicons.sync_outline),
              onTap: () => GoRouter.of(context).go(SyncStatusScreen.route),
            ),
            ListRow(
              title: const Text('Log out'),
              leading: const Icon(Ionicons.exit_outline),
              onTap: () async {
                await context.showConfirmationDialog(
                  title: const Text('Log out?'),
                  body: Text(logOutText),
                  confirmButton: DialogActionButton(
                    text: 'Log out',
                    isDestructive: true,
                    onPressed: () => GoRouter.of(context).go(LogoutScreen.route),
                  ),
                  cancelButton: DialogActionButton(text: 'Nevermind'),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _BudgetSelectionBottomSheet extends HookWidget {
  const _BudgetSelectionBottomSheet();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsTabCubit.create(),
      child: BlocBuilder<SettingsTabCubit, SettingsTabState>(
        builder: (context, state) {
          final children = List<Widget>.from(
            state.allBudgets.mapIndexed((index, budget) {
              final isSelected = budget.id == state.selectedBudget.toNullable()?.id;
              return HEdgePadding(
                child: ListRow(
                  isSelected: isSelected,
                  title: Text(budget.name),
                  subtitle: budget.lastModifiedOn != null
                      ? Text('Modified ${budget.lastModifiedOnDate!.MMMdyyyy()}')
                      : const SizedBox.shrink(),
                  trailing: const Icon(Ionicons.checkmark_circle_outline).visible(isSelected),
                  onTap: () async {
                    if (budget.id != state.selectedBudget.toNullable()?.id) {
                      $settings().setSelectedBudgetId(budget.id);
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              );
            }),
          );
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            maxChildSize: 0.9,
            minChildSize: 0.3,
            builder: (context, controller) {
              return BottomSheetWithHeader(
                title: const HEdgePadding(child: Text('Your budgets')),
                builder: (context) {
                  return Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      padding: const EdgeInsets.only(top: Sizes.edgePadding),
                      child: SafeArea(child: VLayout(children: children)),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
