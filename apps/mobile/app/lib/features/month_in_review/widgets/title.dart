import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:time_machine/time_machine.dart';

import '../../../common/presentation/_int.dart';

class MonthInReviewTitle extends HookWidget {
  const MonthInReviewTitle({super.key, required this.month});

  final LocalDate month;

  @override
  Widget build(BuildContext context) {
    return VLayout(
      spacing: 0,
      children: [
        Text('Month in review', style: context.text.title),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: month.monthOfYear.toMonthName(), style: context.text.headline),
              const WidgetSpan(child: HSpace()),
              TextSpan(
                text: month.year.toString(),
                style: context.text.headline.copyWith(color: context.colors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
