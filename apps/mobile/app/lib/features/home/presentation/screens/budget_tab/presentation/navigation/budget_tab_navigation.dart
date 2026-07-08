// ignore: non_constant_identifier_names
import 'package:go_router/go_router.dart';

import '../../../../../../frugal_month/presentation/navigation/frugal_month_navigation.dart';
import '../../../../../../templates/presentation/navigation/templates_navigation.dart';
import 'budget_tab_settings_routes.dart';

// ignore: non_constant_identifier_names
List<RouteBase> BudgetTabRoutes() {
  return [...BudgetTabSettingsRoutes(), ...FrugalMonthRoutes(), ...TemplatesRoutes()];
}
