import 'package:design/design.dart';
import 'package:flutter/material.dart';

class BottomSheetWithHeader extends StatelessWidget {
  const BottomSheetWithHeader({super.key, required this.builder, required this.title});

  final WidgetBuilder builder;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return VLayout(
      spacing: 0,
      children: [
        _Header(title: title),
        builder(context),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return VLayout(
      spacing: 0,
      children: [
        HStretch(
          child: VLayout(
            children: [
              const VSpace(space: Sizes.edgePadding),
              HEdgePadding(
                child: DefaultTextStyle.merge(child: title, style: context.text.headline),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
