import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../common/presentation/categories/choose_category_view.dart';
import '../../../../../../../../common/presentation/design_system/section_header.dart';
import '../../../../../../../category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import '../budget_create_category_view_screen/budget_create_category_view_screen.dart';
import 'budget_tab_settings_screen_cubit.dart';

class BudgetTabSettingsScreen extends StatelessWidget {
  const BudgetTabSettingsScreen({super.key});

  static String route = '/budget/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
        child: BlocProvider(
          create: (context) => BudgetTabSettingsCubit.create(),
          child: const SafeArea(
            child: VLayout(spacing: Sizes.unit * 2, children: [_CategoryViewSection()]),
          ),
        ),
      ),
    );
  }
}

class _CategoryViewSection extends StatelessWidget {
  const _CategoryViewSection();

  @override
  Widget build(BuildContext context) {
    final categoryView = context.watch<BudgetTabSettingsCubit>().state.categoryView;

    return SafeArea(
      child: VLayout(
        children: [
          const HEdgePadding(child: SectionHeader('Categories')),
          ChooseCategoryView(
            current: categoryView,
            onTapCreateView: () {
              context.read<CreateCategoryViewCubit>().reset();
              GoRouter.of(context).go(BudgetChooseCategoriesForViewScreen.route);
            },
            onUpdateSetting: (value) async {
              await $settings().setBudgetTabCategoryView(value);
            },
          ),
        ],
      ),
    );
  }
}
