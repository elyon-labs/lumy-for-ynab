import 'package:go_router/go_router.dart';

import '../screens/charts/charts_selection_screen.dart';
import '../screens/charts/charts_settings_screen.dart';

// ignore: non_constant_identifier_names
RouteBase SettingsChartSettingsRoute() {
  return GoRoute(
    path: 'charts',
    builder: (context, state) => const ChartSettingsScreen(),
    routes: [
      GoRoute(path: 'selection', builder: (context, state) => const ChartsSelectionScreen()),
    ],
  );
}
