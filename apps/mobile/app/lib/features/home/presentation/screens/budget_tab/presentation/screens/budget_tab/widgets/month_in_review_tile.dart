import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../../../../../../common/presentation/_int.dart';
import '../../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../month_in_review/screens/month_in_review_screen.dart';

class MonthInReviewTile extends StatelessWidget {
  const MonthInReviewTile({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    final title = Text('${month.monthOfYear.toMonthName()} in Review');
    return ListRow(
      title: title,
      subtitle: const Text('Insights on spending, earning, and more.'),
      onTap: () => GoRouter.of(context).go(MonthInReviewScreen.route),
    );
  }
}
