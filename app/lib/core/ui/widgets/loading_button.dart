import 'package:flutter/material.dart';

/// Type of button to be used in [LoadingButton].
enum ButtonType {
  /// elevated
  elevated,

  /// filled
  filled,

  /// tonal
  tonal,

  /// outlined
  outlined,

  /// text
  text;
}

class LoadingButton extends StatelessWidget {
  /// Creates a [LoadingButton].
  const LoadingButton({
    required this.child,
    required this.type,
    super.key,
    this.isLoading = false,
    this.duration = const Duration(milliseconds: 300),
    this.onPressed,
    this.style,
    this.loader,
    this.strokeWidth,
    this.loaderColor,
  });

  /// Whether the button is in loading state.
  final bool isLoading;

  /// The child widget to be displayed inside the button.
  final Widget child;

  /// The type of button to be used.
  final ButtonType type;

  /// Callback function to be called when the button is pressed.
  final VoidCallback? onPressed;

  /// The style of the button.
  final ButtonStyle? style;

  /// The loader widget to be displayed when the button is loading.
  final Widget? loader;

  /// The stroke width of the loader.
  final double? strokeWidth;

  /// The color of the loader.
  final Color? loaderColor;

  /// The duration of the opacity animation.
  final Duration duration;

  void _onPressed() {
    if (isLoading) return;
    onPressed?.call();
  }

  Widget _buildContent(BuildContext context) {
    final loaderIndicator = loader ??
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth ?? 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              loaderColor ?? Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        );

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: isLoading ? 0 : 1,
          duration: duration,
          child: child,
        ),
        if (isLoading) loaderIndicator,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final btnChild = _buildContent(context);

    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed == null ? null : _onPressed,
          style: style,
          child: btnChild,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed == null ? null : _onPressed,
          style: style,
          child: btnChild,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: onPressed == null ? null : _onPressed,
          style: style,
          child: btnChild,
        );
      case ButtonType.tonal:
        return FilledButton.tonal(
          onPressed: onPressed == null ? null : _onPressed,
          style: style,
          child: btnChild,
        );
      case ButtonType.filled:
        return FilledButton(
          onPressed: onPressed == null ? null : _onPressed,
          style: style,
          child: btnChild,
        );
    }
  }
}
