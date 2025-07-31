import 'package:flutter/material.dart';
import 'package:lune/core/ui/ui.dart';

/// Extension on [ThemeData] to provide access to UI based on the current theme.
extension ThemeStyleResolver on BuildContext {
  /// Access icons based on the current theme.
  UIIcon get icons {
    final brightness = Theme.of(this).brightness;

    final isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      return UIIconDark.instance;
    } else {
      return UIIconLight.instance;
    }
  }

  /// Access colors based on the current theme.
  UIColor get colors {
    final brightness = Theme.of(this).brightness;

    final isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      return UIColorDark.instance;
    } else {
      return UIColorLight.instance;
    }
  }

  /// Access assets based on the current theme.
  UIAsset get assets {
    final brightness = Theme.of(this).brightness;

    final isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      return UIAssetDark.instance;
    } else {
      return UIAssetLight.instance;
    }
  }

  /// Access button styles based on the current theme.
  UIButtonStyle get buttonStyles {
    final brightness = Theme.of(this).brightness;

    final isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      return UIButtonStyleDark.instance;
    } else {
      return UIButtonStyleLight.instance;
    }
  }

  /// Access input styles based on the current theme.
  UIInputStyle get inputStyles {
    final brightness = Theme.of(this).brightness;

    final isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      return UIInputStyleDark.instance;
    } else {
      return UIInputStyleLight.instance;
    }
  }

  /// Access text styles based on the current theme.
  UITextStyle get textStyles {
    final brightness = Theme.of(this).brightness;

    final isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      return UITextStyleDark.instance;
    } else {
      return UITextStyleLight.instance;
    }
  }
}
