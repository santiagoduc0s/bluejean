import 'package:flutter/material.dart';

class MaterialTheme {
  const MaterialTheme(this.textTheme);
  final TextTheme textTheme;

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff536524),
      surfaceTint: Color(0xff536524),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd6eb9c),
      onPrimaryContainer: Color(0xff3c4c0e),
      secondary: Color(0xff5b6147),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdfe6c4),
      onSecondaryContainer: Color(0xff434931),
      tertiary: Color(0xff39665f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbcece2),
      onTertiaryContainer: Color(0xff204e47),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffafaee),
      onSurface: Color(0xff1b1c15),
      onSurfaceVariant: Color(0xff46483c),
      outline: Color(0xff76786b),
      outlineVariant: Color(0xffc6c8b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303129),
      inversePrimary: Color(0xffbacf82),
      primaryFixed: Color(0xffd6eb9c),
      onPrimaryFixed: Color(0xff161f00),
      primaryFixedDim: Color(0xffbacf82),
      onPrimaryFixedVariant: Color(0xff3c4c0e),
      secondaryFixed: Color(0xffdfe6c4),
      onSecondaryFixed: Color(0xff181e09),
      secondaryFixedDim: Color(0xffc3caaa),
      onSecondaryFixedVariant: Color(0xff434931),
      tertiaryFixed: Color(0xffbcece2),
      onTertiaryFixed: Color(0xff00201c),
      tertiaryFixedDim: Color(0xffa1d0c7),
      onTertiaryFixedVariant: Color(0xff204e47),
      surfaceDim: Color(0xffdbdbcf),
      surfaceBright: Color(0xfffafaee),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f4e8),
      surfaceContainer: Color(0xffefefe2),
      surfaceContainerHigh: Color(0xffe9e9dd),
      surfaceContainerHighest: Color(0xffe3e3d7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2c3b00),
      surfaceTint: Color(0xff536524),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff627432),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff323921),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff697055),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff0b3d37),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff48756d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffafaee),
      onSurface: Color(0xff10120b),
      onSurfaceVariant: Color(0xff35372c),
      outline: Color(0xff515447),
      outlineVariant: Color(0xff6c6e61),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303129),
      inversePrimary: Color(0xffbacf82),
      primaryFixed: Color(0xff627432),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff4a5b1c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff697055),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff51583e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff48756d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2f5c55),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc7c7bc),
      surfaceBright: Color(0xfffafaee),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f4e8),
      surfaceContainer: Color(0xffe9e9dd),
      surfaceContainerHigh: Color(0xffdeddd2),
      surfaceContainerHighest: Color(0xffd2d2c7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff243000),
      surfaceTint: Color(0xff536524),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3f4f10),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff282f18),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff454c33),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00332d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff23514a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffafaee),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2b2d23),
      outlineVariant: Color(0xff484a3e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303129),
      inversePrimary: Color(0xffbacf82),
      primaryFixed: Color(0xff3f4f10),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff293700),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff454c33),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2f351e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff23514a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff053a33),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb9b9ae),
      surfaceBright: Color(0xfffafaee),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f1e5),
      surfaceContainer: Color(0xffe3e3d7),
      surfaceContainerHigh: Color(0xffd5d5c9),
      surfaceContainerHighest: Color(0xffc7c7bc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbacf82),
      surfaceTint: Color(0xffbacf82),
      onPrimary: Color(0xff273500),
      primaryContainer: Color(0xff3c4c0e),
      onPrimaryContainer: Color(0xffd6eb9c),
      secondary: Color(0xffc3caaa),
      onSecondary: Color(0xff2d331c),
      secondaryContainer: Color(0xff434931),
      onSecondaryContainer: Color(0xffdfe6c4),
      tertiary: Color(0xffa1d0c7),
      onTertiary: Color(0xff023731),
      tertiaryContainer: Color(0xff204e47),
      onTertiaryContainer: Color(0xffbcece2),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff12140d),
      onSurface: Color(0xffe3e3d7),
      onSurfaceVariant: Color(0xffc6c8b8),
      outline: Color(0xff909284),
      outlineVariant: Color(0xff46483c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e3d7),
      inversePrimary: Color(0xff536524),
      primaryFixed: Color(0xffd6eb9c),
      onPrimaryFixed: Color(0xff161f00),
      primaryFixedDim: Color(0xffbacf82),
      onPrimaryFixedVariant: Color(0xff3c4c0e),
      secondaryFixed: Color(0xffdfe6c4),
      onSecondaryFixed: Color(0xff181e09),
      secondaryFixedDim: Color(0xffc3caaa),
      onSecondaryFixedVariant: Color(0xff434931),
      tertiaryFixed: Color(0xffbcece2),
      onTertiaryFixed: Color(0xff00201c),
      tertiaryFixedDim: Color(0xffa1d0c7),
      onTertiaryFixedVariant: Color(0xff204e47),
      surfaceDim: Color(0xff12140d),
      surfaceBright: Color(0xff383a32),
      surfaceContainerLowest: Color(0xff0d0f08),
      surfaceContainerLow: Color(0xff1b1c15),
      surfaceContainer: Color(0xff1f2019),
      surfaceContainerHigh: Color(0xff292b23),
      surfaceContainerHighest: Color(0xff34362d),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd0e596),
      surfaceTint: Color(0xffbacf82),
      onPrimary: Color(0xff1e2900),
      primaryContainer: Color(0xff859852),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd9e0be),
      onSecondary: Color(0xff222812),
      secondaryContainer: Color(0xff8d9476),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb6e6dc),
      onTertiary: Color(0xff002b26),
      tertiaryContainer: Color(0xff6c9991),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff12140d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdcdece),
      outline: Color(0xffb1b3a4),
      outlineVariant: Color(0xff909283),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e3d7),
      inversePrimary: Color(0xff3d4e0f),
      primaryFixed: Color(0xffd6eb9c),
      onPrimaryFixed: Color(0xff0d1300),
      primaryFixedDim: Color(0xffbacf82),
      onPrimaryFixedVariant: Color(0xff2c3b00),
      secondaryFixed: Color(0xffdfe6c4),
      onSecondaryFixed: Color(0xff0e1302),
      secondaryFixedDim: Color(0xffc3caaa),
      onSecondaryFixedVariant: Color(0xff323921),
      tertiaryFixed: Color(0xffbcece2),
      onTertiaryFixed: Color(0xff001511),
      tertiaryFixedDim: Color(0xffa1d0c7),
      onTertiaryFixedVariant: Color(0xff0b3d37),
      surfaceDim: Color(0xff12140d),
      surfaceBright: Color(0xff44453d),
      surfaceContainerLowest: Color(0xff070803),
      surfaceContainerLow: Color(0xff1d1e17),
      surfaceContainer: Color(0xff272921),
      surfaceContainerHigh: Color(0xff32332b),
      surfaceContainerHighest: Color(0xff3d3e36),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe3f9a8),
      surfaceTint: Color(0xffbacf82),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffb6cb7f),
      onPrimaryContainer: Color(0xff080d00),
      secondary: Color(0xffedf4d1),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbfc6a6),
      onSecondaryContainer: Color(0xff080d00),
      tertiary: Color(0xffc9faf0),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff9dccc3),
      onTertiaryContainer: Color(0xff000e0b),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff12140d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff0f1e1),
      outlineVariant: Color(0xffc2c4b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e3d7),
      inversePrimary: Color(0xff3d4e0f),
      primaryFixed: Color(0xffd6eb9c),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffbacf82),
      onPrimaryFixedVariant: Color(0xff0d1300),
      secondaryFixed: Color(0xffdfe6c4),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc3caaa),
      onSecondaryFixedVariant: Color(0xff0e1302),
      tertiaryFixed: Color(0xffbcece2),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa1d0c7),
      onTertiaryFixedVariant: Color(0xff001511),
      surfaceDim: Color(0xff12140d),
      surfaceBright: Color(0xff4f5148),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1f2019),
      surfaceContainer: Color(0xff303129),
      surfaceContainerHigh: Color(0xff3b3c34),
      surfaceContainerHighest: Color(0xff46483f),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
