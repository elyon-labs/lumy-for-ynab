import 'package:design/layout/edge_padding.dart';
import 'package:design/layout/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../../common/presentation/design_system/outlined_child.dart';

class TemplateMemoRow extends HookWidget {
  const TemplateMemoRow({super.key, required this.memo, required this.onChanged});

  final String? memo;
  final ValueSetter<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: memo);

    return HEdgePadding(
      padding: Sizes.unit * 1.75,
      child: OutlinedChild(
        child: HEdgePadding(
          child: TextField(
            controller: controller,
            autofocus: false,
            decoration: const InputDecoration(hintText: 'Enter a memo'),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
