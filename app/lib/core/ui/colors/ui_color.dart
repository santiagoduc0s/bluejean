import 'package:flutter/material.dart';
import 'package:lune/core/ui/colors/colors.dart';

/// Abstract class for UIColor.
abstract class UIColor {
  /// Black color.
  static const Color black = Color(0xFF000000);

  /// White color.
  static const Color white = Color(0xFFFFFFFF);

  /// Transparent color.
  static const Color transparent = Color(0x00000000);

  static const _primaryGenerator = 0xFF135986;
  static const _secondaryGenerator = 0xFF86929F;
  static const _tertiaryGenerator = 0xFF998BA8;
  static const _errorGenerator = 0xFFFF5449;
  static const _neutralGenerator = 0xFF909093;
  static const _neutralVariantGenerator = 0xFF8D9197;

  /// Primary color.
  final MaterialColor primarySchema = MaterialColor(
    _primaryGenerator,
    HctColor.generateMaterial3TonesHct(
      _primaryGenerator,
    ),
  );

  /// Secondary color.
  final MaterialColor secondarySchema = MaterialColor(
    _secondaryGenerator,
    HctColor.generateMaterial3TonesHct(
      _secondaryGenerator,
    ),
  );

  /// Tertiary color.
  final MaterialColor tertiarySchema = MaterialColor(
    _tertiaryGenerator,
    HctColor.generateMaterial3TonesHct(
      _tertiaryGenerator,
    ),
  );

  /// Error color.
  final MaterialColor errorSchema = MaterialColor(
    _errorGenerator,
    HctColor.generateMaterial3TonesHct(
      _errorGenerator,
    ),
  );

  /// Neutral color.
  final MaterialColor neutralSchema = MaterialColor(
    _neutralGenerator,
    HctColor.generateMaterial3TonesHct(
      _neutralGenerator,
    ),
  );

  /// Neutral variant color.
  final MaterialColor neutralVariantSchema = MaterialColor(
    _neutralVariantGenerator,
    HctColor.generateMaterial3TonesHct(
      _neutralVariantGenerator,
    ),
  );

  /// primary
  Color get primary;

  /// onPrimary
  Color get onPrimary;

  /// primaryContainer
  Color get primaryContainer;

  /// onPrimaryContainer
  Color get onPrimaryContainer;

  /// primaryFixed
  Color get primaryFixed;

  /// primaryFixedDim
  Color get primaryFixedDim;

  /// onPrimaryFixed
  Color get onPrimaryFixed;

  /// onPrimaryFixedVariant
  Color get onPrimaryFixedVariant;

  /// secondary
  Color get secondary;

  /// onSecondary
  Color get onSecondary;

  /// secondaryContainer
  Color get secondaryContainer;

  /// onSecondaryContainer
  Color get onSecondaryContainer;

  /// secondaryFixed
  Color get secondaryFixed;

  /// secondaryFixedDim
  Color get secondaryFixedDim;

  /// onSecondaryFixed
  Color get onSecondaryFixed;

  /// onSecondaryFixedVariant
  Color get onSecondaryFixedVariant;

  /// tertiary
  Color get tertiary;

  /// onTertiary
  Color get onTertiary;

  /// tertiaryContainer
  Color get tertiaryContainer;

  /// onTertiaryContainer
  Color get onTertiaryContainer;

  /// tertiaryFixed
  Color get tertiaryFixed;

  /// tertiaryFixedDim
  Color get tertiaryFixedDim;

  /// onTertiaryFixed
  Color get onTertiaryFixed;

  /// onTertiaryFixedVariant
  Color get onTertiaryFixedVariant;

  /// error
  Color get error;

  /// onError
  Color get onError;

  /// errorContainer
  Color get errorContainer;

  /// onErrorContainer
  Color get onErrorContainer;

  /// surfaceDim
  Color get surfaceDim;

  /// surface
  Color get surface;

  /// surfaceBright
  Color get surfaceBright;

  /// inverseSurface
  Color get inverseSurface;

  /// onInverseSurface
  Color get onInverseSurface;

  /// surfaceContainerLowest
  Color get surfaceContainerLowest;

  /// surfaceContainerLow
  Color get surfaceContainerLow;

  /// surfaceContainer
  Color get surfaceContainer;

  /// surfaceContainerHigh
  Color get surfaceContainerHigh;

  /// surfaceContainerHighest
  Color get surfaceContainerHighest;

  /// onSurface
  Color get onSurface;

  /// onSurfaceVariant
  Color get onSurfaceVariant;

  /// outline
  Color get outline;

  /// outlineVariant
  Color get outlineVariant;

  /// scrim
  Color get scrim;

  /// shadow
  Color get shadow;

  /// inversePrimary
  Color get inversePrimary;
}
