import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/l10n/l10n.dart';

class PasswordDialog extends StatefulWidget {
  const PasswordDialog({
    required this.message,
    required this.confirmText,
    required this.cancelText,
    super.key,
  });

  final String message;
  final String confirmText;
  final String cancelText;

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttonStyles;
    final texts = context.textStyles;
    final inputsProvider = context.inputStyles;
    final l10n = context.l10n;
    final colorsProvider = context.colors;

    return AlertDialog(
      title: Text(
        widget.message,
        style: texts.bodyLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: inputsProvider.primary.copyWith(
              hintText: l10n.password,
              fillColor: colorsProvider.surfaceContainerLow,
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            onSubmitted: (_) => _confirm(),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: buttons.primaryText,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelText),
        ),
        FilledButton(
          style: buttons.primaryFilled,
          onPressed: _confirm,
          child: Text(widget.confirmText),
        ),
      ],
    );
  }

  void _confirm() {
    final password = _passwordController.text.trim();
    if (password.isNotEmpty) {
      Navigator.of(context).pop(password);
    }
  }
}
