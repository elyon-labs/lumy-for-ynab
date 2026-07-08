import 'package:design/design.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../features/home/presentation/screens/budget_tab/presentation/screens/budget_tab/budget_tab.dart';
import 'error_screen_cubit.dart';

class ErrorScreen extends HookWidget {
  const ErrorScreen({super.key, this.error, this.stackTrace});

  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    // useEffect(() {
    //   unawaited($errorReporter().recordError(state.error, StackTrace.current));
    //   return null;
    // }, []);
    return BlocProvider(
      create: (context) => ErrorScreenCubit.create(error: error, stackTrace: stackTrace),
      child: Scaffold(
        appBar: AppBar(),
        body: HEdgePadding(
          child: VLayout(
            children: [
              CircleAvatar(
                radius: Sizes.unit * 4,
                backgroundColor: context.colors.error,
                child: Icon(
                  Icons.error_outline,
                  size: Sizes.unit * 4,
                  color: context.colors.onError,
                ),
              ),
              const VSpace(space: Sizes.unit * 2),
              Text('Oops!', style: context.text.headline),
              Text(
                "Well this is embarrassing...We'll fix it soon!",
                style: context.text.body.copyWith(color: context.colors.muted),
              ),
              if (kDebugMode && error != null) ...[
                Text(
                  error.toString(),
                  style: context.text.body.copyWith(color: context.colors.error),
                ),
                const Spacer(),
                SafeArea(
                  child: VEdgePadding(
                    child: PrimaryButton(
                      onPressed: () => GoRouter.of(context).go(BudgetTab.route),
                      child: const Text('Go Home'),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
