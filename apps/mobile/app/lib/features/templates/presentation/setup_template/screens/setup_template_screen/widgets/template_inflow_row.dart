import 'package:design/components/smaller_switch.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../../../../common/presentation/design_system/list_row.dart';

class TemplateInflowRow extends StatelessWidget {
  const TemplateInflowRow({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListRow(
      leading: const Icon(Ionicons.arrow_up_circle_outline),
      title: const Text('Inflow'),
      trailing: SmallerSwitch(value: value, onChanged: onChanged),
    );
  }
}
