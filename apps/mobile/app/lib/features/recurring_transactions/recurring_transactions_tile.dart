import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/presentation/design_system/list_row.dart';
import 'recurring_transactions_screen/recurring_transactions_screen.dart';

class RecurringTransactionsTile extends StatelessWidget {
  const RecurringTransactionsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListRow(
      title: const Text('Recurring Transactions'),
      subtitle: const Text('Keep track of your recurring transactions'),
      onTap: () => context.go(RecurringTransactionsScreen.route),
    );
  }
}
