import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';
import 'dialog_action_button.dart';
import 'generic_dialog.dart';

extension BuildContextModalsX on BuildContext {
  Future<void> showConfirmationDialog({
    Widget? title,
    required Widget body,
    required DialogActionButton confirmButton,
    required DialogActionButton cancelButton,
  }) async {
    await showAdaptiveDialog(
      context: this,
      barrierDismissible: true,
      builder: (_) {
        return ConfirmationDialog(
          title: title,
          body: body,
          confirmButton: confirmButton,
          cancelButton: cancelButton,
        );
      },
    );
  }

  Future<void> showGenericDialog({
    Widget? title,
    required Widget body,
    required List<DialogActionButton> buttons,
  }) async {
    await showAdaptiveDialog(
      context: this,
      barrierDismissible: true,
      builder: (_) {
        return GenericDialog(title: title, body: body, buttons: buttons);
      },
    );
  }
}
