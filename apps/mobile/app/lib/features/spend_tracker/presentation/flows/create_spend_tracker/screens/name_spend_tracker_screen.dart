import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/presentation/design_system/outlined_child.dart';
import '../../../../../../utils/_build_context.dart';
import '../../../../../home/presentation/screens/reports_tab/presentation/screens/reports_spend_tracker_details_screen.dart';
import '../state/create_spend_tracker_cubit.dart';

class NameSpendTrackerScreen extends StatelessWidget {
  const NameSpendTrackerScreen({super.key});

  static const String route = '/reports/create_spend_tracker/source/name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Name Spend Tracker')),
      body: const Body(),
    );
  }
}

class Body extends HookWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final updates = useListenable(controller);
    bool shouldShow() {
      return updates.text.isNotEmpty;
    }

    return HEdgePadding(
      child: Stack(
        children: [
          VLayout(
            children: [
              const VSpace(space: Sizes.unit * 2),
              OutlinedChild(
                child: HEdgePadding(
                  child: TextField(
                    autofocus: true,
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Spend tracker name'),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedScale(
              scale: shouldShow() ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Sizes.edgePadding),
                  child: HStretch(
                    child: PrimaryButton(
                      onPressed: !shouldShow()
                          ? null
                          : () async {
                              context.read<CreateSpendTrackerCubit>().setName(updates.text);
                              final result = await context.read<CreateSpendTrackerCubit>().save();
                              if (context.mounted) {
                                result.when(
                                  ok: (id) => GoRouter.of(context).go(
                                    ReportsSpendTrackerDetailsScreen.buildRoute(spendTrackerId: id),
                                  ),
                                  err: (err) {
                                    context.showToast(const Text('Oops! Something went wrong'));
                                  },
                                );
                              }
                            },
                      child: Text(
                        !shouldShow() ? 'Save' : 'Create ${updates.text}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
