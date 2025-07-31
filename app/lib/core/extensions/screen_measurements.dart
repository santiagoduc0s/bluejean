import 'package:flutter/material.dart';

/// Extension on [BuildContext] to get screen measurements.
extension ScreenMeasurements on BuildContext {
  /// Get the screen height.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get the screen width.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get the screen aspect ratio.
  double get paddingTop => MediaQuery.of(this).padding.top;

  /// Get the screen aspect ratio.
  double get paddingBottom => MediaQuery.of(this).padding.bottom;
}
