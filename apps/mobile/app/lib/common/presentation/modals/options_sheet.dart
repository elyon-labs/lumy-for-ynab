import 'package:design/design.dart';
import 'package:flutter/material.dart';

import '../design_system/list_row.dart';

class OptionsSheetButton {
  OptionsSheetButton({required this.title, required this.onTap, required this.isDestructive});

  final Widget title;
  final VoidCallback onTap;
  final bool isDestructive;
}

class OptionsSheet extends StatelessWidget {
  const OptionsSheet({super.key, required this.options});

  final List<OptionsSheetButton> options;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: VLayout(
          children: options.map((o) {
            return ListRow(
              externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
              implicitTrailing: false,
              title: DefaultTextStyle.merge(
                style: context.text.title.copyWith(
                  color: o.isDestructive ? context.colors.error : context.colors.foreground,
                ),
                child: o.title,
              ),
              onTap: () {
                Navigator.of(context).pop();
                o.onTap();
              },
            );
          }),
        ),
      ),
    );
  }
}
