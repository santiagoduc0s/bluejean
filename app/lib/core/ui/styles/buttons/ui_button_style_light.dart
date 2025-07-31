import 'package:flutter/material.dart';
import 'package:lune/core/ui/colors/colors.dart';
import 'package:lune/core/ui/font_weight/ui_font_weight.dart';
import 'package:lune/core/ui/spacing/ui_spacing.dart';
import 'package:lune/core/ui/styles/buttons/buttons.dart';
import 'package:lune/core/ui/styles/texts/texts.dart';

/// Implements the light theme for [UIButtonStyle].
class UIButtonStyleLight extends UIButtonStyle {
  UIButtonStyleLight._singleton();

  /// Singleton instance of [UIButtonStyleLight].
  static final UIButtonStyleLight instance = UIButtonStyleLight._singleton();

  /// Singleton instance of [UIColor].
  UIColor uiColor = UIColorLight.instance;

  /// Singleton instance of [UITextStyle].
  UITextStyle uiTextStyle = UITextStyleLight.instance;

  @override
  ButtonStyle get primaryElevated {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(
        Size.zero,
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: 4.space,
        ),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.space),
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        uiTextStyle.labelLarge.copyWith(
          fontWeight: UIFontWeight.light,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return uiColor.onSurface;
        }
        return uiColor.primary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return uiColor.onSurface.withValues(alpha: 0.12);
          }
          return uiColor.surfaceContainerLow;
        },
      ),
      shadowColor: WidgetStateProperty.all<Color>(
        uiColor.shadow,
      ),
      elevation: WidgetStateProperty.all<double>(0.25.space),
    );
  }

  @override
  ButtonStyle get primaryFilled {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(
        Size(UISpacing.zero, 12.space),
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: 4.space,
        ),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.space),
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        uiTextStyle.labelLarge.copyWith(
          fontWeight: UIFontWeight.light,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return uiColor.onSurface.withValues(alpha: 0.50);
        }
        return uiColor.onPrimary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return uiColor.onSurface.withValues(alpha: 0.12);
          }
          return uiColor.primary;
        },
      ),
    );
  }

  @override
  ButtonStyle get primaryFilledTonal {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(
        Size(UISpacing.zero, 12.space),
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: 4.space,
        ),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.space),
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        uiTextStyle.labelLarge.copyWith(
          fontWeight: UIFontWeight.light,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return uiColor.onSurface.withValues(alpha: 0.50);
        }
        return uiColor.onSecondaryContainer;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return uiColor.onSurface.withValues(alpha: 0.12);
          }
          return uiColor.secondaryContainer;
        },
      ),
    );
  }

  @override
  ButtonStyle get primaryOutlined {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(
        Size(UISpacing.zero, 12.space),
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: 4.space,
        ),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.space),
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        uiTextStyle.labelLarge.copyWith(
          fontWeight: UIFontWeight.light,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return uiColor.outline;
        }
        return uiColor.primary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return UIColor.transparent;
          }
          return UIColor.transparent;
        },
      ),
      side: WidgetStateProperty.resolveWith<BorderSide>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: uiColor.onSurface.withValues(alpha: 0.12),
              width: .25.space,
            );
          }
          return BorderSide(
            color: uiColor.outline,
            width: .25.space,
          );
        },
      ),
    );
  }

  @override
  ButtonStyle get primaryText {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          return UIColor.transparent;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return uiColor.outline;
          }
          return uiColor.primary;
        },
      ),
      minimumSize: WidgetStateProperty.all(
        Size(UISpacing.zero, 12.space),
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: 4.space,
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(uiTextStyle.labelLarge),
      elevation: WidgetStateProperty.all(UISpacing.zero),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
