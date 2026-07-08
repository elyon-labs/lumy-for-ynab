import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../utils/_build_context.dart';
import 'write_access_screen_cubit.dart';

class WriteAccessScreen extends HookWidget {
  const WriteAccessScreen({super.key, required this.onAccessGranted});

  final VoidCallback onAccessGranted;

  @override
  Widget build(BuildContext context) {
    final onAccessGranted = useCallback(() {
      Navigator.of(context, rootNavigator: true).pop();
      this.onAccessGranted();
    }, [this.onAccessGranted]);

    return BlocProvider(
      create: (context) => WriteAccessScreenCubit.create(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: HEdgePadding(
            child: VLayout(
              children: [
                CircleAvatar(
                  radius: Sizes.unit * 4,
                  backgroundColor: context.colors.warning,
                  child: Icon(
                    Ionicons.hand_left_outline,
                    size: Sizes.unit * 4,
                    color: context.colors.onWarning,
                  ),
                ),
                const VSpace(space: Sizes.unit * 2),
                Text('Just a sec', style: context.text.headline),
                Text(
                  'Before you can create transactions using Lumy, we need your permission to write to your budget. We will never write to your budget without your permission.',
                  style: context.text.body.copyWith(color: context.colors.muted),
                ),
                const Spacer(),
                _GrantWriteAccessButton(onAccessGranted: onAccessGranted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GrantWriteAccessButton extends StatelessWidget {
  const _GrantWriteAccessButton({required this.onAccessGranted});

  final Null Function() onAccessGranted;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (WriteAccessScreenCubit cubit) => cubit.state.accessRequest.isLoading,
    );
    return PrimaryButton(
      onPressed: isLoading
          ? null
          : () async {
              final result = await context.read<WriteAccessScreenCubit>().requestWriteAccess();
              if (result.isOk()) {
                onAccessGranted();
              } else if (context.mounted) {
                context.showToast(const Text('Failed to grant write access!'));
              }
            },
      child: const Text('Grant write access'),
    );
  }
}
