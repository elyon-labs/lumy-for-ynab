import 'package:go_router/go_router.dart';
import '../../chart_details/presentation/screens/chart_details_screen/chart_details_screen.dart';
import '../../chart_details/presentation/screens/chart_source_screen.dart';
import '../../chart_details/presentation/screens/choose_chart_accounts_screen/choose_chart_accounts_screen.dart';
import '../../chart_details/presentation/screens/share_chart_screen.dart';

// ignore: non_constant_identifier_names
RouteBase ChartDetailsRoute() {
  return GoRoute(
    path: 'chart_details/:id',
    builder: (context, state) => ChartDetailsScreen(chartId: state.pathParameters['id']!),
    routes: [
      GoRoute(
        path: 'accounts',
        builder: (context, state) =>
            ChooseChartAccountsScreen(chartId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: 'share',
        builder: (context, state) => ShareChartScreen(chartId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: 'source',
        builder: (context, state) => ChartSourceScreen(chartId: state.pathParameters['id']!),
      ),
    ],
  );
}
