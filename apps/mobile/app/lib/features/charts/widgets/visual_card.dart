import 'package:design/design.dart';
import 'package:flutter/material.dart';

class VisualCard extends StatelessWidget {
  const VisualCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.button,
    this.onTap,
  });

  final Widget child;
  final Widget? title;
  final Widget? subtitle;
  final Widget? button;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: HStretch(
        child: Card(
          child: VLayout(
            spacing: 0,
            children: [
              const VSpace(space: Sizes.edgePadding),
              VisualHeader(title: title, subtitle: subtitle, button: button),
              const VSpace(),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class VisualHeader extends StatelessWidget {
  const VisualHeader({super.key, this.title, this.subtitle, this.button});

  final Widget? title;
  final Widget? subtitle;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return VLayout(
      spacing: 0,
      children: [
        HLayout(
          spacing: 0,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VLayout(
              spacing: 0,
              mainAxisAlignment: subtitle == null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                if (title != null) ...[
                  Flexible(
                    child: DefaultTextStyle.merge(
                      child: HEdgePadding(child: title!),
                      style: context.text.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            if (button != null) ...[HEdgePadding(padding: Sizes.edgePadding / 2, child: button!)],
          ],
        ),
        if (subtitle != null) ...[
          Flexible(
            child: DefaultTextStyle.merge(
              child: HEdgePadding(child: subtitle!),
              style: context.text.body.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}
