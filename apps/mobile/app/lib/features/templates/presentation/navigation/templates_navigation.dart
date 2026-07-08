import 'package:go_router/go_router.dart';

import '../../../../app/navigation/router.dart';
import '../../../../external/flow.dart';
import '../screens/run_template_screen/run_template_screen.dart';
import '../setup_template/screens/configure_template_screen/configure_template_screen.dart';
import '../setup_template/screens/setup_template_screen/setup_template_screen.dart';
import '../setup_template/setup_template_flow.dart';

// ignore: non_constant_identifier_names
List<RouteBase> TemplatesRoutes() {
  return [
    ShellRoute(
      parentNavigatorKey: rootNavigatorKey,
      routes: [SetupTemplateRoute(), EditTemplateRoute()],
      builder: (context, state, child) {
        final templateId = state.pathParameters['templateId'];
        return Flow(
          createManager: (_) => SetupTemplateFlow.create(existingTemplateId: templateId),
          child: child,
        );
      },
    ),
    RunTemplateRoute(),
  ];
}

// ignore: non_constant_identifier_names
RouteBase SetupTemplateRoute() {
  return GoRoute(
    path: '/setup_template',
    builder: (context, state) => const SetupTemplateScreen(existingTemplateId: null),
    routes: [ConfigureNewTemplateRoute()],
  );
}

// ignore: non_constant_identifier_names
RouteBase EditTemplateRoute() {
  return GoRoute(
    path: '/setup_template/:templateId',
    builder: (context, state) =>
        SetupTemplateScreen(existingTemplateId: state.pathParameters['templateId']),
    routes: [ConfigureExistingTemplateRoute()],
  );
}

// ignore: non_constant_identifier_names
RouteBase ConfigureNewTemplateRoute() {
  return GoRoute(
    path: '/configure_template',
    builder: (context, state) => const ConfigureTemplateScreen(existingTemplateId: null),
  );
}

// ignore: non_constant_identifier_names
RouteBase ConfigureExistingTemplateRoute() {
  return GoRoute(
    path: '/configure_template',
    builder: (context, state) =>
        ConfigureTemplateScreen(existingTemplateId: state.pathParameters['templateId']),
  );
}

// ignore: non_constant_identifier_names
RouteBase RunTemplateRoute() {
  return GoRoute(
    path: '/run_template/:templateId',
    builder: (context, state) {
      final templateId = state.pathParameters['templateId']!;
      return RunTemplateScreen(templateId: templateId);
    },
  );
}
