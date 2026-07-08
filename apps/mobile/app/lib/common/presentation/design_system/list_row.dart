import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'outlined_child.dart';

class ListRow extends StatelessWidget {
  const ListRow({
    Key? key,
    Widget? title,
    Widget? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    Color? backgroundColor,
    ShapeBorder? shape,
    EdgeInsetsGeometry? externalPadding = const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
    bool implicitTrailing = true,
    bool isSelected = false,
    VisualDensity visualDensity = VisualDensity.standard,
  }) : this._(
         key: key,
         title: title,
         subtitle: subtitle,
         leading: leading,
         trailing: trailing,
         onTap: onTap,
         backgroundColor: backgroundColor,
         shape: shape,
         externalPadding: externalPadding,
         implicitTrailing: implicitTrailing,
         visualDensity: visualDensity,
         isSelected: isSelected,
       );

  const ListRow._({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.trailing,
    required this.onTap,
    required this.backgroundColor,
    required this.shape,
    required this.externalPadding,
    required this.implicitTrailing,
    required this.visualDensity,
    required this.isSelected,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? externalPadding;
  final ShapeBorder? shape;
  final bool implicitTrailing;
  final bool isSelected;
  final VisualDensity visualDensity;

  @override
  Widget build(BuildContext context) {
    final effectiveTrailing =
        trailing ??
        (implicitTrailing && onTap != null
            ? const Icon(Ionicons.chevron_forward_outline, size: Sizes.unit * 2.5).opacity(0.25)
            : null);

    final child = InkWell(
      onTap: onTap,
      customBorder: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadius * 3),
      ),
      child: OutlinedChild(
        showOutline: isSelected,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: effectiveTrailing,
          visualDensity: visualDensity,
          contentPadding: externalPadding,
        ),
      ),
    );

    return HStretch(child: child);
  }
}
