import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../utils/_local_date.dart';
import '../flows/create_frugal_month_flow.dart';

class ChooseFrugalMonthScreen extends StatelessWidget {
  const ChooseFrugalMonthScreen({super.key});

  static const String route = '/budget/choose_frugal_month';

  @override
  Widget build(BuildContext context) {
    Future<void> nextScreen(LocalDate month) async {
      final step = ChooseMonthStep(selectedMonth: month);
      await context.read<CreateFrugalMonthFlow>().stepComplete(step);
    }

    return BlocBuilder<CreateFrugalMonthFlow, CreateFrugalMonthState>(
      builder: (context, state) {
        final showClose = state.availableMonths.valueOr([]).length > 1;
        return Scaffold(
          appBar: AppBar(
            // Need to show this due to being the first route in a ShellRoute
            leading: showClose ? CloseButton(onPressed: () => GoRouter.of(context).pop()) : null,
          ),
          body: HEdgePadding(
            child: VLayout(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VLayout(
                  children: [
                    const VSpace(space: Sizes.unit * 2),

                    CircleAvatar(
                      radius: Sizes.unit * 4,
                      backgroundColor: context.colors.good,
                      child: Icon(
                        Ionicons.calendar_number_outline,
                        size: Sizes.unit * 4,
                        color: context.colors.onGood,
                      ),
                    ),
                    const VSpace(space: Sizes.unit * 2),
                    Text('When should we start?', style: context.text.headline),
                    Text(
                      "There's still time to start this month if you'd like.",
                      style: context.text.body.copyWith(color: context.colors.muted),
                    ),
                  ],
                ),
                const Spacer(),
                SafeArea(
                  child: VEdgePadding(
                    child: VLayout(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PrimaryButton(
                          onPressed: () async {
                            await nextScreen(today.firstDayOfMonth());
                          },
                          child: const Text('This month'),
                        ),
                        SecondaryButton(
                          onPressed: () async {
                            await nextScreen(today.firstDayOfMonth().addMonths(1));
                          },
                          child: const Text('Next month'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
