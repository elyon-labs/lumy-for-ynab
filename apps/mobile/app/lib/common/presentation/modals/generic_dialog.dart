import 'package:design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import 'dialog_action_button.dart';

class GenericDialog extends StatelessWidget {
  const GenericDialog({super.key, this.title, required this.body, this.buttons = const []});

  final Widget? title;
  final Widget body;
  final List<DialogActionButton> buttons;

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isApple) {
      return CupertinoAlertDialog(
        title: title,
        content: body,
        actions: buttons.map((button) {
          return CupertinoDialogAction(
            child: Text(
              button.text,
              style: TextStyle(color: button.isDestructive ? context.colors.error : null),
            ),
            onPressed: () {
              Navigator.of(context).pop(button);
              button.onPressed?.call();
            },
          );
        }).toList(),
      );
    }

    return AlertDialog(
      title: title,
      content: body,
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: Sizes.edgePadding,
        vertical: Sizes.unit,
      ),
      actions: buttons.map((button) {
        return TextButton(
          onPressed: () {
            Navigator.of(context).pop(button);
            button.onPressed?.call();
          },
          child: Text(button.text),
        );
      }).toList(),
    );
  }
}
