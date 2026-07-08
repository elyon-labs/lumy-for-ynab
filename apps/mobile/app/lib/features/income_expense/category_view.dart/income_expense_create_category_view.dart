import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:oxidized/oxidized.dart';

import '../../../app/di.dart';
import '../../../utils/_build_context.dart';
import '../../category_views/presentation/flows/create_category_view/screens/choose_categories_for_view_screen/choose_categories_for_view_screen.dart';
import '../../category_views/presentation/flows/create_category_view/screens/name_category_view_screen.dart';
import '../../category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import '../screens/choose_income_expense_categories_screen.dart';

class IncomeExpenseCreateCategoryView extends HookWidget {
  const IncomeExpenseCreateCategoryView({super.key});

  static String route = '/reports/income_expense/categories/create_category_view';

  @override
  Widget build(BuildContext context) {
    return ChooseCategoriesForViewScreen(
      onComplete: (payload) {
        context.read<CreateCategoryViewCubit>().setSelected(
          categoryIds: payload.categoryIds,
          categoryGroupIds: payload.categoryGroupIds,
        );
        GoRouter.of(context).go(IncomeExpenseNameNewCategoryViewScreen.route);
      },
    );
  }
}

class IncomeExpenseNameNewCategoryViewScreen extends StatelessWidget {
  const IncomeExpenseNameNewCategoryViewScreen({super.key});

  static String route = '/reports/income_expense/categories/create_category_view/name';

  @override
  Widget build(BuildContext context) {
    return NameCategoryViewScreen(
      onComplete: (name) async {
        context.read<CreateCategoryViewCubit>().setName(name);
        final result = await context.read<CreateCategoryViewCubit>().save();
        if (context.mounted) {
          await result.whenAsync(
            ok: (id) async {
              await $settings().setIncomeExpenseCategoryView(Some(id));
              if (context.mounted) {
                GoRouter.of(context).go(ChooseIncomeExpenseCategoriesScreen.route);
              }
            },
            err: (err) async {
              context.showToast(const Text('Oops! Something went wrong'));
            },
          );
        }
      },
    );
  }
}
