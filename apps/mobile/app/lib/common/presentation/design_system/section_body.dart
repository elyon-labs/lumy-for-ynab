import 'package:collection/collection.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';

import '../_color.dart';

class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    required this.children,
    this.showDividers = true,
    this.contentPadding = EdgeInsets.zero,
    this.onTap,
  });

  final List<Widget> children;
  final bool showDividers;
  final VoidCallback? onTap;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return HStretch(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(top: contentPadding.top, bottom: contentPadding.bottom),
          child: VLayout(
            spacing: 0,
            children: children.mapIndexed((index, child) {
              final showDivider = index != children.length - 1 && showDividers && !child.isSpacer;
              return DividerTheme(
                data: context.theme.dividerTheme.copyWith(
                  color: context.colors.divider.withAlphaOf(0.5),
                ),
                child: VLayout(
                  spacing: 0,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: contentPadding.left,
                        right: contentPadding.right,
                      ),
                      child: child,
                    ),
                    if (showDivider) const Divider(),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
