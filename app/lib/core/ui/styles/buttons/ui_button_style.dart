import 'package:flutter/material.dart';

/// Abstract class defining button styles.s
abstract class UIButtonStyle {
  /// primaryElevated
  ButtonStyle get primaryElevated;

  /// primaryFilled
  ButtonStyle get primaryFilled;

  /// primaryFilledTonal
  ButtonStyle get primaryFilledTonal;

  /// primaryOutlined
  ButtonStyle get primaryOutlined;

  /// primaryText
  ButtonStyle get primaryText;
}
