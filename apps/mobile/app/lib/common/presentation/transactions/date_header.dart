import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

import '../../../utils/_local_date.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key, required this.date});
  final LocalDate date;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: date.MMMMd(),
            style: context.text.title.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' ${date.year}',
            style: context.text.title.copyWith(color: context.colors.muted),
          ),
        ],
      ),
    );
  }
}
