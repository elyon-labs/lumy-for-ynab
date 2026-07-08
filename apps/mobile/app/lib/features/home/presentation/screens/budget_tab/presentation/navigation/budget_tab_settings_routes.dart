import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../app/navigation/router.dart';
import '../screens/budget_create_category_view_screen/budget_create_category_view_screen.dart';
import '../screens/budget_name_category_view_screen/budget_name_category_view_screen.dart';
import '../screens/budget_tab_settings_screen/budget_tab_settings_screen.dart';

// ignore: non_constant_identifier_names
List<RouteBase> BudgetTabSettingsRoutes() {
  return [
    GoRoute(
      path: 'settings',
      pageBuilder: (context, state) {
        return const MaterialPage(child: BudgetTabSettingsScreen());
      },
      routes: [
        // TODO: ShellRoute flow
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'create_category_view',
          builder: (context, state) => const BudgetChooseCategoriesForViewScreen(),
          routes: [
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              path: 'name',
              builder: (context, state) => const BudgetNameCategoryViewScreen(),
            ),
          ],
        ),
      ],
    ),
  ];
}
