import 'package:flutter/material.dart';
import 'package:lune/core/theme/theme.dart';
import 'package:lune/core/ui/colors/colors.dart';

/// The light theme implementation of [UIColor].
class UIColorLight extends UIColor {
  UIColorLight._singleton();

  /// Singleton instance of [UIColorLight].
  static final UIColorLight instance = UIColorLight._singleton();

  final ColorScheme colorScheme = MaterialTheme.lightScheme();

  @override
  Color get primary => colorScheme.primary;

  @override
  Color get onPrimary => colorScheme.onPrimary;

  @override
  Color get primaryContainer => colorScheme.primaryContainer;

  @override
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  @override
  Color get secondary => colorScheme.secondary;

  @override
  Color get onSecondary => colorScheme.onSecondary;

  @override
  Color get secondaryContainer => colorScheme.secondaryContainer;

  @override
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  @override
  Color get tertiary => colorScheme.tertiary;

  @override
  Color get onTertiary => colorScheme.onTertiary;

  @override
  Color get tertiaryContainer => colorScheme.tertiaryContainer;

  @override
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;

  @override
  Color get error => colorScheme.error;

  @override
  Color get onError => colorScheme.onError;

  @override
  Color get errorContainer => colorScheme.errorContainer;

  @override
  Color get onErrorContainer => colorScheme.onErrorContainer;

  @override
  Color get surface => colorScheme.surface;

  @override
  Color get onSurface => colorScheme.onSurface;

  @override
  Color get inverseSurface => colorScheme.inverseSurface;

  @override
  Color get onInverseSurface => colorScheme.onInverseSurface;

  @override
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;

  @override
  Color get outline => colorScheme.outline;

  @override
  Color get inversePrimary => colorScheme.inversePrimary;

  @override
  Color get primaryFixed => colorScheme.primaryFixed;

  @override
  Color get primaryFixedDim => colorScheme.primaryFixedDim;

  @override
  Color get onPrimaryFixed => colorScheme.onPrimaryFixed;

  @override
  Color get onPrimaryFixedVariant => colorScheme.onPrimaryFixedVariant;

  @override
  Color get secondaryFixed => colorScheme.secondaryFixed;

  @override
  Color get secondaryFixedDim => colorScheme.secondaryFixedDim;

  @override
  Color get onSecondaryFixed => colorScheme.onSecondaryFixed;

  @override
  Color get onSecondaryFixedVariant => colorScheme.onSecondaryFixedVariant;

  @override
  Color get tertiaryFixed => colorScheme.tertiaryFixed;

  @override
  Color get tertiaryFixedDim => colorScheme.tertiaryFixedDim;

  @override
  Color get onTertiaryFixed => colorScheme.onTertiaryFixed;

  @override
  Color get onTertiaryFixedVariant => colorScheme.onTertiaryFixedVariant;

  @override
  Color get surfaceDim => colorScheme.surfaceDim;

  @override
  Color get surfaceBright => colorScheme.surfaceBright;

  @override
  Color get surfaceContainerLowest => colorScheme.surfaceContainerLowest;

  @override
  Color get surfaceContainerLow => colorScheme.surfaceContainerLow;

  @override
  Color get surfaceContainer => colorScheme.surfaceContainer;

  @override
  Color get surfaceContainerHigh => colorScheme.surfaceContainerHigh;

  @override
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;

  @override
  Color get outlineVariant => colorScheme.outlineVariant;

  @override
  Color get scrim => colorScheme.scrim;

  @override
  Color get shadow => colorScheme.shadow;
}
