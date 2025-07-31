import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  void closeKeyboard() => FocusScope.of(this).unfocus();

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
}
