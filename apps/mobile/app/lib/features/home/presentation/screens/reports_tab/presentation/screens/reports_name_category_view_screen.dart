import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../../../app/di.dart';
import '../../../../../../../utils/_build_context.dart';
import '../../../../../../category_views/presentation/flows/create_category_view/screens/name_category_view_screen.dart';
import '../../../../../../category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import 'reports_tab/reports_tab.dart';

class ReportsNameCategoryViewScreen extends StatelessWidget {
  const ReportsNameCategoryViewScreen({super.key});

  static String route = '/reports/new_category_view/name';

  @override
  Widget build(BuildContext context) {
    return NameCategoryViewScreen(
      onComplete: (name) async {
        context.read<CreateCategoryViewCubit>().setName(name);
        final result = await context.read<CreateCategoryViewCubit>().save();
        if (context.mounted) {
          await result.whenAsync(
            ok: (id) async {
              await $settings().setReportsCategoryView(Some(id));
              if (context.mounted) {
                GoRouter.of(context).go(ReportsTab.route);
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
