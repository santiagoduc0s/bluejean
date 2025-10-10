import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    required this.message,
    required this.confirmText,
    required this.cancelText,
    this.title,
    super.key,
  });

  final String? title;
  final String message;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttonStyles;
    final texts = context.textStyles;

    return AlertDialog(
      title: title != null ? Text(title!, style: texts.titleLarge) : null,
      content: Text(message, style: texts.bodyMedium),
      actions: [
        TextButton(
          style: buttons.primaryText,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        FilledButton(
          style: buttons.primaryFilled,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
