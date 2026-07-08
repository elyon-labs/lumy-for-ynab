import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:ionicons/ionicons.dart';

import '../../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../../common/presentation/markdown.dart';
import '../../../../../../../../../common/presentation/modals/_build_context.dart';
import '../../../../../../../../../common/presentation/modals/dialog_action_button.dart';

class NullCurrencyWarningTile extends HookWidget {
  const NullCurrencyWarningTile({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return ListRow(
      title: const Text('Currency issues?'),
      leading: const Icon(Ionicons.alert_circle_outline),
      subtitle: const Text('Your currency settings are not configured. Tap to learn more.'),
      onTap: () async {
        await context.showGenericDialog(
          title: const Text('Currency settings'),
          body: const HEdgePadding(child: Markdown(data: _body)),
          buttons: [
            DialogActionButton(
              text: 'Close',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            DialogActionButton(
              text: 'Refresh',
              onPressed: () {
                Navigator.of(context).pop();
                onComplete();
              },
            ),
          ],
        );
      },
    );
  }
}

const _body = '''
YNAB hasn't sent us your currency settings. According to the YNAB team, this can sometimes happen with older accounts. If you're seeing incorrect currency symbols, please de the following:
- Head to YNAB on the web and open your budget settings by tapping on your budget name in the top left.
- Make a change in settings and then (if you wish) change it back to your original settings.
- Head back to Lumy and tap refresh below.
''';
