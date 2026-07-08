import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/blend/blend.dart';
import 'package:material_color_utilities/hct/hct.dart';

import '../../../../common/presentation/bottom_sheet_with_header.dart';
import '../../domain/models/frugal_month_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.onTap, this.textStyle});

  final FrugalMonthStatus status;
  final TextStyle? textStyle;
  final ValueSetter<FrugalMonthStatus>? onTap;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final primary = Hct.fromInt(context.colors.primary.value);
    Color blendWithPrimary(Color color) {
      return Color(
        Blend.harmonize(
          // ignore: deprecated_member_use
          Hct.fromInt(color.value).toInt(),
          primary.toInt(),
        ),
      );
    }

    final color = switch (status) {
      FrugalMonthStatus.notStarted => context.colors.muted,
      FrugalMonthStatus.onTrack => context.colors.good,
      FrugalMonthStatus.inDanger => context.colors.warning,
      FrugalMonthStatus.overSpent => context.colors.error,
      FrugalMonthStatus.completeSuccess => context.colors.good,
      FrugalMonthStatus.completeFailure => context.colors.error,
    };

    final name = switch (status) {
      FrugalMonthStatus.notStarted => 'Not Started',
      FrugalMonthStatus.onTrack => 'On Track',
      FrugalMonthStatus.inDanger => 'In Danger',
      FrugalMonthStatus.overSpent => 'Over Spent',
      FrugalMonthStatus.completeSuccess => 'Success',
      FrugalMonthStatus.completeFailure => 'Over Spent',
    };

    final style = textStyle ?? context.text.body;

    return GestureDetector(
      onTap: () async {
        if (onTap != null) {
          onTap!.call(status);
          return;
        } else {
          await showModalBottomSheet(
            showDragHandle: true,
            context: context,
            useRootNavigator: true,
            builder: (_) {
              return BottomSheetWithHeader(
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.edgePadding),
                        child: Text(status.explainer),
                      ),
                    ),
                  );
                },
                title: Text(name),
              );
            },
          );
        }
      },
      child: Text(name, style: style.copyWith(color: blendWithPrimary(color))),
    );
  }
}
