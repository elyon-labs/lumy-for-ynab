import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../common/presentation/bottom_sheet_with_header.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../recurring_transactions_screen.dart';

enum RecurringTransactionsSortType {
  amountAsc('Amount Asc'),
  amountDesc('Amount Desc'),
  alphabeticallyAsc('Alphabetically Asc'),
  alphabeticallyDesc('Alphabetically Desc');

  const RecurringTransactionsSortType(this.friendlyName);

  final String friendlyName;
}

class RecurringTransactionsOptionsSheet extends StatelessWidget {
  const RecurringTransactionsOptionsSheet({super.key, required this.cubit});

  final RecurringTransactionsScreenCubit cubit;

  @override
  Widget build(BuildContext context) {
    const supportedTypes = RecurringTransactionsSortType.values;
    return BlocProvider.value(
      value: cubit,
      child: BottomSheetWithHeader(
        title: const Text('Options'),
        builder: (context) {
          return BlocBuilder<RecurringTransactionsScreenCubit, RecurringTransactionsScreenState>(
            builder: (context, state) {
              final showAnnualPricing = state.showAnnualPricing;
              final sortType = state.sortType;
              return Expanded(
                child: SingleChildScrollView(
                  child: VLayout(
                    children: [
                      const VSpace(space: Sizes.edgePadding),
                      ListRow(
                        title: const Text('Show annual pricing'),
                        trailing: SmallerSwitch(
                          value: showAnnualPricing,
                          onChanged: (value) {
                            context.read<RecurringTransactionsScreenCubit>().toggleAnnualPricing();
                          },
                        ),
                      ),
                      const VSpace(space: Sizes.unit * 3),
                      HEdgePadding(child: Text('Sort strategy', style: context.text.title)),
                      ...supportedTypes.map((t) {
                        final isSelected = sortType == t;
                        return VLayout(
                          spacing: 0,
                          children: [
                            HEdgePadding(
                              child: Material(
                                type: MaterialType.transparency,
                                child: ListRow(
                                  isSelected: isSelected,
                                  externalPadding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.edgePadding,
                                  ),
                                  title: Text(t.friendlyName),
                                  trailing: const Icon(
                                    Ionicons.checkmark_circle_outline,
                                  ).visible(isSelected),
                                  onTap: () {
                                    context.read<RecurringTransactionsScreenCubit>().setSortType(t);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SafeArea(child: VSpace()),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
