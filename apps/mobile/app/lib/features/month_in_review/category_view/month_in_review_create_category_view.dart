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
import '../screens/choose_month_in_review_categories_screen.dart';

class MonthInReviewCreateCategoryView extends HookWidget {
  const MonthInReviewCreateCategoryView({super.key});

  static String route = '/reports/month_in_review/categories/create_category_view';

  @override
  Widget build(BuildContext context) {
    return ChooseCategoriesForViewScreen(
      onComplete: (payload) {
        context.read<CreateCategoryViewCubit>().setSelected(
          categoryIds: payload.categoryIds,
          categoryGroupIds: payload.categoryGroupIds,
        );
        GoRouter.of(context).go(MonthInReviewNameCategoryViewScreen.route);
      },
    );
  }
}

class MonthInReviewNameCategoryViewScreen extends StatelessWidget {
  const MonthInReviewNameCategoryViewScreen({super.key});

  static String route = '/reports/month_in_review/categories/create_category_view/name';

  @override
  Widget build(BuildContext context) {
    return NameCategoryViewScreen(
      onComplete: (name) async {
        context.read<CreateCategoryViewCubit>().setName(name);
        final result = await context.read<CreateCategoryViewCubit>().save();
        if (context.mounted) {
          await result.whenAsync(
            ok: (id) async {
              await $settings().setMonthInReviewCategoryView(Some(id));
              if (context.mounted) {
                GoRouter.of(context).go(ChooseMonthInReviewCategoriesScreen.route);
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
