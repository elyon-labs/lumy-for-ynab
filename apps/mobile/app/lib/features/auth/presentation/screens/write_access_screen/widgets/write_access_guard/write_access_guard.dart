import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../write_access_screen.dart';
import 'write_access_guard_cubit.dart';

class WriteAccessGuard extends StatelessWidget {
  const WriteAccessGuard({
    super.key,
    required this.child,
    required this.onAccessGranted,
    required this.isBlocking,
  });

  final Widget child;
  final VoidCallback onAccessGranted;
  final bool isBlocking;

  @override
  Widget build(BuildContext context) {
    if (!isBlocking) {
      return child;
    }
    return BlocProvider(
      create: (context) => WriteAccessGuardCubit.create(),
      child: BlocBuilder<WriteAccessGuardCubit, Async<bool>>(
        builder: (context, state) {
          if (state.isLoading || state.isError) return const SizedBox.shrink();
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              await Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => WriteAccessScreen(onAccessGranted: onAccessGranted),
                ),
              );
            },
            child: IgnorePointer(ignoring: !state.unwrap(), child: child),
          );
        },
      ),
    );
  }
}
