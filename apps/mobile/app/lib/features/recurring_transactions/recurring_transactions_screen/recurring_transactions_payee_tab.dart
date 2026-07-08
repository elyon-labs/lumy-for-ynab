import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../common/presentation/currency.dart';
import '../../../common/presentation/design_system/section_body.dart';
import '../../../common/presentation/design_system/section_header.dart';
import '../../../common/presentation/transactions/transaction_row.dart';
import '../../../ynab_api/_scheduled_transaction.dart';
import 'recurring_transactions_screen.dart';
import 'widgets/settings_row.dart';

class RecurringTransactionsPayeeTab extends HookWidget {
  const RecurringTransactionsPayeeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecurringTransactionsScreenCubit, RecurringTransactionsScreenState>(
      builder: (context, state) {
        if (state.transactions.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state.transactions.isError) {
          return Center(child: Text(state.transactions.error.toString()));
        }

        final subscriptions = state.transactions.unwrap();

        final children = subscriptions.entries.map((entry) {
          return VLayout(
            spacing: 0,
            children: [
              VEdgePadding(
                child: HEdgePadding(
                  child: SectionHeader(entry.key.mapOr((p) => p.name, 'No payee')),
                ),
              ),
              for (final subscription in entry.value)
                ListSection(
                  showDividers: false,
                  children: [
                    TransactionRow(
                      transaction: subscription.transaction,
                      buildTitle: (context) => Text(
                        subscription.transaction.frequencyDescription.capitalize(),
                        style: context.text.title,
                      ),
                      buildAmount: (context) => _AmountText(subscription: subscription),
                    ),
                  ],
                ),
              const VSpace(),
            ],
          );
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
          child: VLayout(
            children: [
              const RecurringTransactionsSettingsRow(),
              ...children.spaced(space: Sizes.unit * 3),
            ],
          ),
        );
      },
    );
  }
}

class _AmountText extends HookWidget {
  const _AmountText({required this.subscription});

  final RecurringTransaction subscription;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final state = context.watch<RecurringTransactionsScreenCubit>().state;
    return AnimatedCrossFade(
      firstChild: Text(
        subscription.transaction.amount.format(currencyFormat),
        style: context.text.title,
      ),
      secondChild: Text(
        subscription.transaction.annualAmount.format(currencyFormat),
        style: context.text.title,
      ),
      crossFadeState: state.showAnnualPricing
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: 270.milliseconds,
    );
  }
}
