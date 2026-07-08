import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../common/presentation/badged.dart';
import '../recurring_transactions_screen.dart';
import 'recurring_transactions_options_sheet.dart';

class RecurringTransactionsSettingsRow extends StatelessWidget {
  const RecurringTransactionsSettingsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecurringTransactionsScreenCubit, RecurringTransactionsScreenState>(
      builder: (context, state) {
        final isShowingAnnualPricing = state.showAnnualPricing;
        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: Sizes.unit),
            child: IconButton(
              onPressed: () async {
                await showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  builder: (_) => RecurringTransactionsOptionsSheet(
                    cubit: context.read<RecurringTransactionsScreenCubit>(),
                  ),
                );
              },
              icon: Badged(
                showBadge: isShowingAnnualPricing,
                child: const Icon(Ionicons.options_outline),
              ),
            ),
          ),
        );
      },
    );
  }
}
