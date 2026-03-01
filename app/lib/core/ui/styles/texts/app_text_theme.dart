import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lune/core/ui/font_weight/ui_font_weight.dart';

TextTheme buildAppTextTheme(Color onSurface) {
  final base = TextStyle(
    fontFamily: GoogleFonts.openSans().fontFamily,
    fontWeight: UIFontWeight.regular,
    color: onSurface,
  );
  return TextTheme(
    displayLarge: base.copyWith(fontSize: 57),
    displayMedium: base.copyWith(fontSize: 45),
    displaySmall: base.copyWith(fontSize: 36),
    headlineLarge: base.copyWith(fontSize: 32),
    headlineMedium: base.copyWith(fontSize: 28),
    headlineSmall: base.copyWith(fontSize: 24),
    titleLarge: base.copyWith(fontSize: 22),
    titleMedium: base.copyWith(fontSize: 16),
    titleSmall: base.copyWith(fontSize: 14),
    labelLarge: base.copyWith(fontSize: 14),
    labelMedium: base.copyWith(fontSize: 12),
    labelSmall: base.copyWith(fontSize: 11),
    bodyLarge: base.copyWith(fontSize: 16),
    bodyMedium: base.copyWith(fontSize: 14),
    bodySmall: base.copyWith(fontSize: 12),
  );
}
