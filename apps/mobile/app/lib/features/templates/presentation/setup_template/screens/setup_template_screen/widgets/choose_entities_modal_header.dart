import 'package:design/design.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/presentation/_color.dart';

class ChooseEntitiesModalHeader extends StatelessWidget {
  const ChooseEntitiesModalHeader({
    super.key,
    required this.title,
    this.allowMultiSelect = false,
    required this.onCancelTapped,
    this.onMultiSelectTapped,
    this.multiSelectChild,
  });

  final Widget title;
  final bool allowMultiSelect;
  final VoidCallback onCancelTapped;
  final VoidCallback? onMultiSelectTapped;
  final Widget? multiSelectChild;

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonTheme(
      data: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(context.colors.foreground.withAlphaOf(0.1)),
          visualDensity: VisualDensity.compact,
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: Sizes.unit)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: WidgetStatePropertyAll(context.colors.foreground),
          side: const WidgetStatePropertyAll(BorderSide.none),
        ),
      ),
      child: HEdgePadding(
        child: HLayout(
          spacing: 0,
          children: [
            OutlinedButton(onPressed: onCancelTapped, child: const Text('Cancel')),
            const Spacer(),
            DefaultTextStyle.merge(child: title, style: context.text.title),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                onMultiSelectTapped?.call();
              },
              child: multiSelectChild ?? const Text('Select'),
            ).visible(allowMultiSelect, maintainSize: true),
          ],
        ),
      ),
    );
  }
}
