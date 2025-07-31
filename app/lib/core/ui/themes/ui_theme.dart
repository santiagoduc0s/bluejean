import 'package:flutter/material.dart';

/// Abstract class for UITheme.
abstract class UITheme {
  /// Singleton instance of [UITheme].
  ThemeData get theme;

  /// Singleton instance of [UITheme].
  TextTheme get textTheme;

  /// Singleton instance of [UITheme].
  ColorScheme get colorScheme;
}
