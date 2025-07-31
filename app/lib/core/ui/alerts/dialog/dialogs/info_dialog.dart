import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    required this.message,
    required this.confirmText,
    super.key,
  });

  final String message;
  final String confirmText;

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttonStyles;
    final texts = context.textStyles;

    return AlertDialog(
      title: Text(
        message,
        style: texts.bodyLarge,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          style: buttons.primaryFilled,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
