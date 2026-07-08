import 'dart:ui';

class DialogActionButton {
  DialogActionButton({required this.text, this.onPressed, this.isDestructive = false});

  final String text;
  final bool isDestructive;
  final VoidCallback? onPressed;
}
