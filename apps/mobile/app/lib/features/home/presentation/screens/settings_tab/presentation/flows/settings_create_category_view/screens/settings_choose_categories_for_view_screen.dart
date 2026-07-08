import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../../../category_views/presentation/flows/create_category_view/screens/choose_categories_for_view_screen/choose_categories_for_view_screen.dart';
import '../settings_create_category_view_flow.dart';

class SettingsChooseCategoriesForViewScreen extends HookWidget {
  const SettingsChooseCategoriesForViewScreen({super.key});

  static String route = '/settings/category_views/new';

  @override
  Widget build(BuildContext context) {
    return ChooseCategoriesForViewScreen(
      onComplete: (payload) {
        final flow = context.read<SettingsCreateCategoryViewFlow>();
        // ignore: cascade_invocations
        flow.stepComplete(
          SelectCategories(
            categoryIds: payload.categoryIds,
            categoryGroupIds: payload.categoryGroupIds,
          ),
        );
      },
    );
  }
}
