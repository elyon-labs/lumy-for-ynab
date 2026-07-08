import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/presentation/design_system/list_row.dart';
import '../screens/income_expense_screen.dart';

class IncomeExpenseTile extends StatelessWidget {
  const IncomeExpenseTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListRow(
      title: const Text('Income v Expense'),
      subtitle: const Text('Income and expense breakdown'),
      onTap: () => GoRouter.of(context).go(IncomeExpenseScreen.route),
    );
  }
}
