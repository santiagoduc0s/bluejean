import 'package:flutter/material.dart';
import 'package:lune/core/ui/font_weight/ui_font_weight.dart';
import 'package:lune/core/ui/spacing/ui_spacing.dart';

class AppButtonStyles {
  AppButtonStyles({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  ButtonStyle get primaryElevated {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size.zero),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 4.space),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.space)),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        textTheme.labelLarge!.copyWith(fontWeight: UIFontWeight.light),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface;
        }
        return colorScheme.primary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
        }
        return colorScheme.surfaceContainerLow;
      }),
      shadowColor: WidgetStateProperty.all<Color>(colorScheme.shadow),
      elevation: WidgetStateProperty.all<double>(0.25.space),
    );
  }

  ButtonStyle get primaryFilled {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size(UISpacing.zero, 12.space)),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 4.space),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.space)),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        textTheme.labelLarge!.copyWith(fontWeight: UIFontWeight.light),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.50);
        }
        return colorScheme.onPrimary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
        }
        return colorScheme.primary;
      }),
    );
  }

  ButtonStyle get primaryFilledTonal {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size(UISpacing.zero, 12.space)),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 4.space),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.space)),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        textTheme.labelLarge!.copyWith(fontWeight: UIFontWeight.light),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.50);
        }
        return colorScheme.onSecondaryContainer;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
        }
        return colorScheme.secondaryContainer;
      }),
    );
  }

  ButtonStyle get primaryOutlined {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size(UISpacing.zero, 12.space)),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 4.space),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.space)),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        textTheme.labelLarge!.copyWith(fontWeight: UIFontWeight.light),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.outline;
        }
        return colorScheme.primary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        return Colors.transparent;
      }),
      side: WidgetStateProperty.resolveWith<BorderSide>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.12),
            width: .25.space,
          );
        }
        return BorderSide(color: colorScheme.outline, width: .25.space);
      }),
    );
  }

  ButtonStyle get primaryText {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.outline;
        }
        return colorScheme.primary;
      }),
      minimumSize: WidgetStateProperty.all(Size(UISpacing.zero, 12.space)),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 4.space),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(textTheme.labelLarge!),
      elevation: WidgetStateProperty.all(UISpacing.zero),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
