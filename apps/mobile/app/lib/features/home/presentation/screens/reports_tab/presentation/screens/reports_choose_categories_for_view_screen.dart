import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../category_views/presentation/flows/create_category_view/screens/choose_categories_for_view_screen/choose_categories_for_view_screen.dart';
import '../../../../../../category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import 'reports_name_category_view_screen.dart';

class ReportsChooseCategoriesForViewScreen extends HookWidget {
  const ReportsChooseCategoriesForViewScreen({super.key});

  static String route = '/reports/new_category_view';

  @override
  Widget build(BuildContext context) {
    return ChooseCategoriesForViewScreen(
      onComplete: (payload) {
        context.read<CreateCategoryViewCubit>().setSelected(
          categoryIds: payload.categoryIds,
          categoryGroupIds: payload.categoryGroupIds,
        );
        GoRouter.of(context).go(ReportsNameCategoryViewScreen.route);
      },
    );
  }
}
