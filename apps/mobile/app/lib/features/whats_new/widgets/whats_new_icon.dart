import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../common/presentation/badged.dart';

class WhatsNewIcon extends StatelessWidget {
  const WhatsNewIcon({super.key, required this.showBadge});

  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Badged(
      color: context.colors.primary,
      showBadge: showBadge,
      child: Semantics(label: "What's New", child: const Icon(Ionicons.gift_outline)),
    );
  }
}
