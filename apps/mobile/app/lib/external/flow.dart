import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../utils/_cubit.dart';

part 'flow.mapper.dart';

@MappableClass()
abstract class FlowState with FlowStateMappable {
  FlowState({required this.route});

  final String route;
}

// ignore: avoid_types_as_parameter_names
abstract class FlowManager<State extends FlowState, Step> extends Cubit<State> {
  FlowManager(super.initialState);

  /// Called when a [Step] is complete. It should emit a new state.
  void stepComplete(Step step);

  /// Called when the routing mechanism has updated its route. By updating
  /// the state, we ensure that the state stays in sync with the routing
  /// mechanism which is important when we were not the one to trigger the
  /// route change (e.g when the user presses the back button).
  void _routeUpdated(String route) {
    if (route != state.route) {
      safeEmit(state.copyWith(route: route) as State);
    }
  }
}

// ignore: avoid_types_as_parameter_names
class Flow<F extends FlowManager<State, Step>, State extends FlowState, Step>
    extends StatelessWidget {
  const Flow({super.key, required this.createManager, required this.child});

  final Create<F> createManager;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: createManager,
      child: FlowListener<F, State, Step>(child: child),
    );
  }
}

// ignore: avoid_types_as_parameter_names
class FlowListener<Manager extends FlowManager<State, Step>, State extends FlowState, Step>
    extends SingleChildStatelessWidget {
  const FlowListener({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocListener<Manager, State>(
      listenWhen: (previous, current) {
        return previous.route != current.route;
      },
      listener: (context, state) {
        context.go(state.route);
      },
      child: HookBuilder(
        builder: (context) {
          useEffect(() {
            final router = GoRouter.of(context);
            final delegate = router.routerDelegate;

            void listener() {
              final uri = delegate.currentConfiguration.uri;
              context.read<Manager>()._routeUpdated(uri.path);
            }

            delegate.addListener(listener);
            return () => delegate.removeListener(listener);
          }, []);

          return child!;
        },
      ),
    );
  }
}
