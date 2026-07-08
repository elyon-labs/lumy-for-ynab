import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../../utils/_build_context.dart';
import '../../../../../../../../category_views/presentation/flows/create_category_view/screens/name_category_view_screen.dart';
import '../../../screens/category_view_details_screen/category_view_details_screen.dart';
import '../settings_create_category_view_flow.dart';

class SettingsNameNewCategoryViewScreen extends StatelessWidget {
  const SettingsNameNewCategoryViewScreen({super.key});

  static String route = '/settings/category_views/new/name';

  @override
  Widget build(BuildContext context) {
    return NameCategoryViewScreen(
      onComplete: (name) async {
        final flow = context.read<SettingsCreateCategoryViewFlow>()
          ..stepComplete(SetName(name: name));
        final result = await flow.save();
        if (context.mounted) {
          result.when(
            ok: (id) => GoRouter.of(context).go(CategoryViewDetailsScreen.buildRoute(id)),
            err: (err) {
              context.showToast(const Text('Oops! Something went wrong'));
            },
          );
        }
      },
    );
  }
}
