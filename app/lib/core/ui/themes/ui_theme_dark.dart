import 'package:flutter/material.dart';
import 'package:lune/core/ui/colors/colors.dart';
import 'package:lune/core/ui/styles/inputs/inputs.dart';
import 'package:lune/core/ui/styles/texts/texts.dart';
import 'package:lune/core/ui/themes/themes.dart';

/// Implements the dark theme for [UITheme].
class UIThemeDark extends UITheme {
  UIThemeDark._singleton();

  /// Singleton instance of [UIThemeDark].
  static final UIThemeDark instance = UIThemeDark._singleton();

  /// Singleton instance of [UIColor].
  final uiColors = UIColorDark.instance;

  /// Singleton instance of [UIInputStyle].
  final uiTextStyle = UITextStyleDark.instance;

  @override
  ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: uiColors.surface,
      canvasColor: uiColors.surface,
    );
  }

  @override
  TextTheme get textTheme {
    return TextTheme(
      displayLarge: uiTextStyle.displayLarge,
      displayMedium: uiTextStyle.displayMedium,
      displaySmall: uiTextStyle.displaySmall,
      headlineLarge: uiTextStyle.headlineLarge,
      headlineMedium: uiTextStyle.headlineMedium,
      headlineSmall: uiTextStyle.headlineSmall,
      titleLarge: uiTextStyle.titleLarge,
      titleMedium: uiTextStyle.titleMedium,
      titleSmall: uiTextStyle.titleSmall,
      bodyLarge: uiTextStyle.bodyLarge,
      bodyMedium: uiTextStyle.bodyMedium,
      bodySmall: uiTextStyle.bodySmall,
      labelLarge: uiTextStyle.labelLarge,
      labelMedium: uiTextStyle.labelMedium,
      labelSmall: uiTextStyle.labelSmall,
    );
  }

  @override
  ColorScheme get colorScheme {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: uiColors.primary,
      onPrimary: uiColors.onPrimary,
      primaryContainer: uiColors.primaryContainer,
      onPrimaryContainer: uiColors.onPrimaryContainer,
      primaryFixed: uiColors.primaryFixed,
      primaryFixedDim: uiColors.primaryFixedDim,
      onPrimaryFixed: uiColors.onPrimaryFixed,
      onPrimaryFixedVariant: uiColors.onPrimaryFixedVariant,
      secondary: uiColors.secondary,
      onSecondary: uiColors.onSecondary,
      secondaryContainer: uiColors.secondaryContainer,
      onSecondaryContainer: uiColors.onSecondaryContainer,
      secondaryFixed: uiColors.secondaryFixed,
      secondaryFixedDim: uiColors.secondaryFixedDim,
      onSecondaryFixed: uiColors.onSecondaryFixed,
      onSecondaryFixedVariant: uiColors.onSecondaryFixedVariant,
      tertiary: uiColors.tertiary,
      onTertiary: uiColors.onTertiary,
      tertiaryContainer: uiColors.tertiaryContainer,
      onTertiaryContainer: uiColors.onTertiaryContainer,
      tertiaryFixed: uiColors.tertiaryFixed,
      tertiaryFixedDim: uiColors.tertiaryFixedDim,
      onTertiaryFixed: uiColors.onTertiaryFixed,
      onTertiaryFixedVariant: uiColors.onTertiaryFixedVariant,
      error: uiColors.error,
      onError: uiColors.onError,
      errorContainer: uiColors.errorContainer,
      onErrorContainer: uiColors.onErrorContainer,
      surfaceDim: uiColors.surfaceDim,
      surface: uiColors.surface,
      surfaceBright: uiColors.surfaceBright,
      inverseSurface: uiColors.inverseSurface,
      onInverseSurface: uiColors.onInverseSurface,
      surfaceContainerLowest: uiColors.surfaceContainerLowest,
      surfaceContainerLow: uiColors.surfaceContainerLow,
      surfaceContainer: uiColors.surfaceContainer,
      surfaceContainerHigh: uiColors.surfaceContainerHigh,
      surfaceContainerHighest: uiColors.surfaceContainerHighest,
      onSurface: uiColors.onSurface,
      onSurfaceVariant: uiColors.onSurfaceVariant,
      outline: uiColors.outline,
      outlineVariant: uiColors.outlineVariant,
      scrim: uiColors.scrim,
      shadow: uiColors.shadow,
      inversePrimary: uiColors.inversePrimary,
    );
  }
}
