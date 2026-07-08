import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/navigation/router.dart';
import '../category_view/month_in_review_create_category_view.dart';
import '../screens/choose_month_in_review_categories_screen.dart';
import '../screens/month_in_review_screen.dart';

// ignore: non_constant_identifier_names
List<RouteBase> MonthInReviewRoutes() {
  return [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'month_in_review',
      pageBuilder: (context, state) {
        return const MaterialPage(fullscreenDialog: true, child: MonthInReviewScreen());
      },
      routes: [
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'categories',
          builder: (context, state) {
            return const ChooseMonthInReviewCategoriesScreen();
          },
          routes: [
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              path: 'create_category_view',
              builder: (context, state) {
                return const MonthInReviewCreateCategoryView();
              },
              routes: [
                GoRoute(
                  parentNavigatorKey: rootNavigatorKey,
                  path: 'name',
                  builder: (context, state) {
                    return const MonthInReviewNameCategoryViewScreen();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];
}
