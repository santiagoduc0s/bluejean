import 'package:flutter/material.dart';
import 'package:lune/core/theme/theme.dart';
import 'package:lune/core/ui/styles/texts/app_text_theme.dart';

class AppTheme {
  static ThemeData light() => _build(MaterialTheme.lightScheme());
  static ThemeData dark() => _build(MaterialTheme.darkScheme());

  static ThemeData _build(ColorScheme colorScheme) {
    final textTheme = buildAppTextTheme(colorScheme.onSurface);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
    );
  }
}
