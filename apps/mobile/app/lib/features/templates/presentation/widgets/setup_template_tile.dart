import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../common/presentation/design_system/list_row.dart';
import '../setup_template/screens/setup_template_screen/setup_template_screen.dart';

class SetupTemplateTile extends StatelessWidget {
  const SetupTemplateTile({super.key});

  @override
  Widget build(BuildContext context) {
    return HEdgePadding(
      child: Card(
        child: Builder(
          builder: (context) {
            return ListRow(
              title: const Text('Setup template'),
              leading: const Icon(Ionicons.create_outline),
              subtitle: const Text('Create transactions from a template'),
              onTap: () async {
                context.go(SetupTemplateScreen.route);
              },
            );
          },
        ),
      ),
    );
  }
}
