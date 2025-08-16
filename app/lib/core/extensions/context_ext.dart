import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  void closeKeyboard() => FocusScope.of(this).unfocus();

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
}
