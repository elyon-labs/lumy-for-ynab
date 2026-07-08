import 'package:go_router/go_router.dart';

import '../../../../../../../app/navigation/router.dart';
import '../screens/reports_choose_categories_for_view_screen.dart';
import '../screens/reports_name_category_view_screen.dart';

// ignore: non_constant_identifier_names
RouteBase ReportsCreateCategoryViewRoute() {
  return GoRoute(
    path: 'new_category_view',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const ReportsChooseCategoriesForViewScreen(),
    routes: [
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: 'name',
        builder: (context, state) => const ReportsNameCategoryViewScreen(),
      ),
    ],
  );
}
