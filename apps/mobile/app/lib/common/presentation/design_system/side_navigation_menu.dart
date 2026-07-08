import 'dart:math' as math;
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../_color.dart';

class SideNavigationMenu extends HookWidget {
  const SideNavigationMenu({
    super.key,
    required this.children,
    required this.onItemSelected,
    required this.selectedIndex,
  });

  final List<SideNavigationMenuItem> children;
  final ValueSetter<int> onItemSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final sideMenuWidth = useState<double>(200);
    final minIntrinsicWidth = useState<double?>(null);
    final contentKey = useMemoized(GlobalKey.new);
    final isCollapsed = useState(false);
    final icon = isCollapsed.value
        ? const Icon(Icons.chevron_right_outlined)
        : const Icon(Icons.chevron_left_outlined);
    final maxWidth = MediaQuery.sizeOf(context).width * 0.25;

    // Invalidate measurement when collapse state changes (label visibility affects width)
    useEffect(() {
      minIntrinsicWidth.value = null;
      return null;
    }, [isCollapsed.value]);

    // Measure the intrinsic width after layout when needed
    useEffect(() {
      if (minIntrinsicWidth.value != null) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final w = contentKey.currentContext?.size?.width;
        if (w != null) {
          minIntrinsicWidth.value = w;
          // Only bump stored width to min when expanded
          if (!isCollapsed.value && sideMenuWidth.value < w) {
            sideMenuWidth.value = w;
          }
        }
      });
      return null;
    }, [minIntrinsicWidth.value, children]);

    final menu = ColoredBox(
      color: context.colors.card,
      child: IntrinsicWidth(
        key: contentKey,
        child: VLayout(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: VLayout(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Sizes.edgePadding),
                    child: Image.asset('assets/icon_transparent.png', height: Sizes.unit * 4),
                  ),
                  ...children.map((item) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          final index = children.indexOf(item);
                          onItemSelected.call(index);
                        },
                        child: _SideNavigationMenuItem(
                          icon: item.icon,
                          label: item.label,
                          isSelected: children.indexOf(item) == selectedIndex,
                          showLabel: !isCollapsed.value,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                isCollapsed.value = !isCollapsed.value;
              },
              icon: icon,
            ),
          ],
        ),
      ),
    );

    final targetWidth = minIntrinsicWidth.value == null
        ? null
        : isCollapsed.value
        ? math.min(maxWidth, minIntrinsicWidth.value!)
        : math.min(maxWidth, math.max(minIntrinsicWidth.value!, sideMenuWidth.value));
    return HLayout(
      spacing: 0,
      children: [
        if (targetWidth == null) menu else SizedBox(width: targetWidth, child: menu),
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) {
              final minW = minIntrinsicWidth.value ?? 150;
              if (isCollapsed.value) {
                // Dragging while collapsed expands from the intrinsic min
                final next = minW + details.delta.dx;
                sideMenuWidth.value = math.min(maxWidth, math.max(minW, next));
                isCollapsed.value = false;
              } else {
                final next = sideMenuWidth.value + details.delta.dx;
                sideMenuWidth.value = math.min(maxWidth, math.max(minW, next));
              }
            },
            child: SizedBox(
              width: Sizes.unit / 2,
              height: double.infinity,
              child: VerticalDivider(color: context.colors.card),
            ),
          ),
        ),
      ],
    );
  }
}

class SideNavigationMenuItem {
  const SideNavigationMenuItem({required this.icon, required this.label});

  final Widget icon;
  final Widget label;
}

class _SideNavigationMenuItem extends StatelessWidget {
  const _SideNavigationMenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.showLabel,
  });

  final Widget icon;
  final Widget label;
  final bool isSelected;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isSelected ? context.colors.primary.withAlphaOf(0.25) : context.colors.card,
      child: HEdgePadding(
        padding: Sizes.edgePadding,
        child: VEdgePadding(
          padding: Sizes.edgePadding / 2,
          child: HLayout(
            spacing: 0,
            children: [
              IconTheme(
                data: IconThemeData(size: Sizes.unit * 2.5, color: context.colors.foreground),
                child: SizedBox.fromSize(size: const Size.square(Sizes.unit * 4), child: icon),
              ),
              if (showLabel) ...[
                const HSpace(space: Sizes.unit * 2),
                Expanded(
                  child: DefaultTextStyle(
                    style: context.text.title.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    child: label,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
