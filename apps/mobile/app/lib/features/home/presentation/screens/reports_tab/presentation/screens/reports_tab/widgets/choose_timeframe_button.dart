import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../utils/_local_date.dart';
import '../../../../../../../../date_range/domain/models/date_range.dart';
import '../../../../../../../../date_range/state/selected_date_range_cubit.dart';
import 'choose_period_bottom_sheet.dart';

class ChooseTimeframeButton extends StatelessWidget {
  const ChooseTimeframeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dateRange = context.watch<SelectedDateRangeCubit>().state;
    return SecondaryButton(
      onPressed: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          showDragHandle: true,
          builder: (_) => const ChoosePeriodBottomSheet(),
        );
      },
      child: Text(
        dateRange.shortDescription(),
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

extension on DateRange {
  String shortDescription() {
    if (from.isSameMonthAs(to)) {
      return '${from.MMM()} ${from.yyyy()}';
    } else if (from.year == to.year) {
      return '${from.MMM()} - ${to.MMM()} ${to.year}';
    } else {
      return '${from.MMM()} ${from.yy()} - ${to.MMM()} ${to.yy()}';
    }
  }
}
