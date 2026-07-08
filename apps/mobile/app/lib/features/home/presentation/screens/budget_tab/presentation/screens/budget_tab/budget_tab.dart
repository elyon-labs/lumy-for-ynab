import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oxidized/oxidized.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../../../../../../../common/presentation/design_system/_build_context.dart';
import '../../../../../../../../common/presentation/design_system/app_screen.dart';
import '../../../../../../../../common/presentation/markdown.dart';
import '../../../../../../../../common/presentation/modals/_build_context.dart';
import '../../../../../../../../common/presentation/modals/dialog_action_button.dart';
import '../../../../../../../category_views/domain/models/category_view.dart';
import '../../../../../../../templates/presentation/widgets/setup_template_tile.dart';
import '../budget_tab_settings_screen/budget_tab_settings_screen.dart';
import 'budget_tab_cubit.dart';
import 'budget_tab_state.dart';
import 'widgets/burndown_section.dart';
import 'widgets/frugal_month_section.dart';
import 'widgets/latest_transactions_section.dart';
import 'widgets/spent_this_month_section.dart';
import 'widgets/templates_section/templates_section.dart';
import 'widgets/templates_section/templates_section_state.dart';
import 'widgets/up_next_section.dart';

class BudgetTab extends HookWidget {
  const BudgetTab({super.key});

  static String route = '/budget';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BudgetTabCubit.create(),
      child: BlocBuilder<BudgetTabCubit, BudgetTabState>(
        builder: (context, state) {
          return switch (state.isLoading) {
            false => const _LoadedBody(),
            true => const Center(child: CircularProgressIndicator.adaptive()),
          };
        },
      ),
    );
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BudgetTabCubit.create(),
      child: BlocBuilder<BudgetTabCubit, BudgetTabState>(
        builder: (context, state) {
          List<Widget> buildRows() {
            return [
              const VSpace(space: Sizes.unit * 2),
              const TemplatesSection(),
              if (state.currentFrugalMonth.isSome()) ...[
                const FrugalMonthSection(),
                const VSpace(space: Sizes.unit * 2),
              ],
              const SpentThisMonthSection(),
              const VSpace(space: Sizes.unit * 2),
              const BurndownSection(),
              const VSpace(space: Sizes.unit * 2),
              const LatestTransactionsSection(),
              const VSpace(space: Sizes.unit * 2),
              const SetupTemplateTile(),
              const VSpace(space: Sizes.unit * 2),
              UpNextSection(state.plannedFrugalMonth),
              const VSpace(space: Sizes.edgePadding),
            ];
          }

          final frugalMonthBlocProvider = state.currentFrugalMonth.mapOr((frugalMonth) {
            return BlocProvider(
              key: ValueKey(frugalMonth.id),
              create: (_) => FrugalMonthSectionCubit.create(frugalMonth),
            );
          }, null);

          final List<Widget> actions = [
            if (UniversalPlatform.isWeb) const _WebBetaAction(),
            _SettingsAction(selectedView: state.selectedCategoryView),
          ];

          return MultiProvider(
            providers: [
              BlocProvider(create: (_) => LatestTransactionsSectionCubit.create()),
              BlocProvider(create: (_) => SpentThisMonthCubit.create()),
              BlocProvider(create: (_) => BurndownSectionCubit.create()),
              BlocProvider(create: (_) => UpNextSectionCubit.create()),
              BlocProvider(create: (_) => TemplatesSectionCubit.create()),
              if (frugalMonthBlocProvider != null) ...[frugalMonthBlocProvider],
            ],
            child: AppScreen(
              title: context.isDesktop ? const Text('Budget') : null,
              actions: context.isDesktop ? actions : null,
              backgroundColor: context.bespokeColors.bodyVariant,
              child: CustomScrollView(
                slivers: [
                  if (!context.isDesktop)
                    SliverAppBar(
                      actions: actions,
                      automaticallyImplyLeading: false,
                      title: const Text('Budget'),
                      backgroundColor: context.bespokeColors.bodyVariant,
                      centerTitle: false,
                      titleTextStyle: context.text.headline.copyWith(fontWeight: FontWeight.bold),
                      pinned: true,
                    ),
                  SliverList(delegate: SliverChildListDelegate(buildRows())),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WebBetaAction extends StatelessWidget {
  const _WebBetaAction();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await context.showGenericDialog(
          title: const Text('Lumy Web is in Beta'),
          body: const Markdown(
            data:
                'Lumy Web is currently in beta. Issues are expected. Known issues are tracked [here](https://lumyforynab.canny.io/features-and-bugs/p/deploy-lumy-as-a-web-app). Find something else? Drop a comment on the ticket or reach out in Discord. ',
          ),
          buttons: [DialogActionButton(text: 'Close')],
        );
      },
      icon: Icon(Ionicons.flame_outline, size: Sizes.unit * 3, color: context.colors.error),
    );
  }
}

class _SettingsAction extends StatelessWidget {
  const _SettingsAction({required this.selectedView});

  final Option<CategoryView> selectedView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetTabCubit, BudgetTabState>(
      builder: (context, state) {
        void onPressed() {
          GoRouter.of(context).go(BudgetTabSettingsScreen.route);
        }

        return switch (selectedView) {
          Some<CategoryView>() => Padding(
            padding: const EdgeInsets.only(right: Sizes.edgePadding),
            child: TextButton.icon(
              style: ButtonStyle(iconColor: WidgetStateProperty.all(context.colors.foreground)),
              onPressed: onPressed,
              label: const Icon(Ionicons.cog_outline, size: Sizes.unit * 3),
              icon: Text(
                selectedView.unwrap().name,
                style: TextStyle(fontWeight: FontWeight.bold, color: context.colors.foreground),
              ),
            ),
          ),
          None<CategoryView>() => HEdgePadding(
            child: IconButton(
              style: ButtonStyle(iconColor: WidgetStateProperty.all(context.colors.foreground)),
              onPressed: onPressed,
              icon: const Icon(Ionicons.cog_outline, size: Sizes.unit * 3),
            ),
          ),
        };
      },
    );
  }
}
