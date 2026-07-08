import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../common/presentation/markdown.dart';
import '../state/whats_new_state.dart';

class WhatsNewScreen extends HookWidget {
  const WhatsNewScreen({super.key});

  static String route = '/settings/whats_new';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WhatsNewCubit.create(),
      child: _MarkSeen(
        child: BlocBuilder<WhatsNewCubit, WhatsNewState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: const Text("What's New")),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.edgePadding),
                  child: VLayout(
                    children: [SafeArea(child: Markdown(data: state.data))],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MarkSeen extends HookWidget {
  const _MarkSeen({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<WhatsNewCubit>().markSeen();
      return null;
    }, []);
    return child;
  }
}
