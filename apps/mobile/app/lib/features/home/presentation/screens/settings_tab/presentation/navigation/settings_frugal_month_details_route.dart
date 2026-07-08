import 'package:go_router/go_router.dart';
import '../../../../../../frugal_month/presentation/screens/frugal_month_details_screen.dart';
import '../../../../../../frugal_month/presentation/screens/past_frugal_months_screen.dart';

// ignore: non_constant_identifier_names
RouteBase SettingsTabPastFrugalMonthsRoute() {
  return GoRoute(
    path: 'past_frugal_months',
    builder: (context, state) => const PastFrugalMonthsScreen(),
    routes: [
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FrugalMonthDetailsScreen(id: id);
        },
      ),
    ],
  );
}
