import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../../common/presentation/design_system/app_screen.dart';
import '../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../domain/models/spend_tracker_draft.dart';
import '../../../../domain/models/transaction_conditions.dart';
import '../state/create_spend_tracker_cubit.dart';

class ChooseSpendTrackerTypeScreen extends StatelessWidget {
  const ChooseSpendTrackerTypeScreen({super.key, required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: const Text('Choose type'),
      child: _Body(onContinue: onContinue),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<CreateSpendTrackerCubit>().state.draft;
    void setSingleType(TransactionTestType type) {
      context.read<CreateSpendTrackerCubit>().setType(Single(type));
    }

    void setMultiType() {
      context.read<CreateSpendTrackerCubit>().setType(const Multi());
    }

    return VLayout(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: VLayout(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListRow(
                  title: const Text('Category'),
                  subtitle: const Text('Groceries, Rent'),
                  leading: const Icon(Ionicons.list_circle),
                  trailing: const Icon(
                    Ionicons.checkmark_circle_outline,
                  ).visible(draft.isTestType(TransactionTestType.hasCategoryId)),
                  onTap: () => setSingleType(TransactionTestType.hasCategoryId),
                ),
                ListRow(
                  title: const Text('Category Group'),
                  subtitle: const Text('Bills, True Expenses'),
                  leading: const Icon(Ionicons.layers),
                  trailing: const Icon(
                    Ionicons.checkmark_circle_outline,
                  ).visible(draft.isTestType(TransactionTestType.hasCategoryGroupId)),
                  onTap: () => setSingleType(TransactionTestType.hasCategoryGroupId),
                ),
                ListRow(
                  title: const Text('Payee'),
                  subtitle: const Text('Amazon, Walmart'),
                  leading: const Icon(Ionicons.person_circle),
                  trailing: const Icon(
                    Ionicons.checkmark_circle_outline,
                  ).visible(draft.isTestType(TransactionTestType.hasPayeeId)),
                  onTap: () => setSingleType(TransactionTestType.hasPayeeId),
                ),
                ListRow(
                  title: const Text('Memo'),
                  subtitle: const Text('#MyCoolProject, #IOUs'),
                  leading: const Icon(Ionicons.pricetag_outline),
                  trailing: const Icon(
                    Ionicons.checkmark_circle_outline,
                  ).visible(draft.isTestType(TransactionTestType.hasMemoKeyword)),
                  onTap: () => setSingleType(TransactionTestType.hasMemoKeyword),
                ),
                ListRow(
                  title: const Text('Flag'),
                  subtitle: const Text('Pending Reimbursement'),
                  leading: const Icon(Ionicons.flag_outline),
                  trailing: const Icon(
                    Ionicons.checkmark_circle_outline,
                  ).visible(draft.isTestType(TransactionTestType.hasFlagColor)),
                  onTap: () => setSingleType(TransactionTestType.hasFlagColor),
                ),
                ListRow(
                  title: const Text('Advanced Query'),
                  subtitle: const Text('Track using multiple criteria'),
                  leading: const Icon(Ionicons.code_slash_outline),
                  trailing: const Icon(
                    Ionicons.checkmark_circle_outline,
                  ).visible(draft.isMultiQuery()),
                  onTap: setMultiType,
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
            child: HStretch(
              child: VEdgePadding(
                child: PrimaryButton(
                  onPressed: draft.type == null ? null : onContinue,
                  child: const Text('Continue'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
