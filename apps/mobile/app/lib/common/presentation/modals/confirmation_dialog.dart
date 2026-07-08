import 'package:design/design.dart';
import 'package:flutter/material.dart';

import 'dialog_action_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.title,
    required this.body,
    required this.confirmButton,
    required this.cancelButton,
  });

  final Widget? title;
  final Widget body;
  final DialogActionButton confirmButton;
  final DialogActionButton cancelButton;

  @override
  Widget build(BuildContext context) {
    void onConfirm() {
      Navigator.of(context).pop(true);
      confirmButton.onPressed?.call();
    }

    final confirmChild = Text(
      confirmButton.text,
      style: TextStyle(color: confirmButton.isDestructive ? context.colors.onError : null),
    );

    return AlertDialog(
      title: title,
      content: body,
      actionsPadding: const EdgeInsets.fromLTRB(
        Sizes.edgePadding,
        Sizes.unit,
        Sizes.edgePadding,
        Sizes.edgePadding,
      ),
      actions: [
        if (confirmButton.isDestructive)
          DestructiveButton(onPressed: onConfirm, child: confirmChild),
        if (!confirmButton.isDestructive) PrimaryButton(onPressed: onConfirm, child: confirmChild),
        Padding(
          padding: const EdgeInsets.only(top: Sizes.unit),
          child: SecondaryButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              cancelButton.onPressed?.call();
            },
            child: Text(cancelButton.text),
          ),
        ),
      ],
    );
  }
}
