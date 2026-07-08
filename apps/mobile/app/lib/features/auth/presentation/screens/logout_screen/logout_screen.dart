import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logout_screen_cubit.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  static String route = '/logout';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutScreenCubit.create(),
      child: const _PendingLogout(),
    );
  }
}

class _PendingLogout extends StatelessWidget {
  const _PendingLogout();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LogoutScreenCubit>().state;
    if (state.executeLogout) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await context.read<LogoutScreenCubit>().logOut();
      });
    }
    return const Scaffold(
      body: Center(
        child: VLayout(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(Sizes.edgePadding),
              child: CircularProgressIndicator.adaptive(),
            ),
            Text('Logging out...'),
          ],
        ),
      ),
    );
  }
}
