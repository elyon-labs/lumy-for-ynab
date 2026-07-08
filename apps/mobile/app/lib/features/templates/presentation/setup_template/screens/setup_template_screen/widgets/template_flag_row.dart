import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../common/presentation/modals/options_sheet.dart';
import '../../../../../../../ynab_api/_flag.dart';

class TemplateFlagRow extends StatelessWidget {
  const TemplateFlagRow({super.key, required this.flag, required this.onChanged});

  final Flag? flag;
  final ValueSetter<Flag?> onChanged;

  @override
  Widget build(BuildContext context) {
    final title = flag != null
        ? Text(flag!.name.capitalize())
        : Text('Choose flag', style: TextStyle(color: context.colors.muted));

    return ListRow(
      title: title,
      leading: flag?.dot ?? const Icon(Ionicons.flag_outline),
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          builder: (_) => OptionsSheet(
            options: [
              ...Flag.values.map((f) {
                return OptionsSheetButton(
                  title: HLayout(children: [f.dot, Text(f.name.capitalize())]),
                  onTap: () {
                    onChanged(f);
                  },
                  isDestructive: false,
                );
              }),
              if (flag != null)
                OptionsSheetButton(
                  title: const HLayout(
                    children: [Icon(Ionicons.close_circle_outline), Text('Clear flag')],
                  ),
                  onTap: () {
                    onChanged(null);
                  },
                  isDestructive: false,
                ),
            ],
          ),
        );
      },
    );
  }
}
